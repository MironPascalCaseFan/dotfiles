local api = vim.api

local function macro()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "Recording macro in: " .. reg
end

local function lsp_status()
  local attached_clients = vim.lsp.get_clients { bufnr = 0 }
  if #attached_clients == 0 then
    return ""
  end
  local names = {}
  for _, client in ipairs(attached_clients) do
    local name = client.name:gsub("language.server", "ls")
    table.insert(names, name)
  end
  return "LSP: " .. table.concat(names, ", ")
end

local DIAG_ATTRS = {
  { "Error", "󰅚 ", "DiagnosticError" },
  { "Warn", "󰀪 ", "DiagnosticWarn" },
  { "Info", "󰋽 ", "DiagnosticInfo" },
  { "Hint", "󰌶 ", "DiagnosticHint" },
}

--- @param name string
--- @return string
local function hl(name)
  return "%#" .. name .. "#"
end

--- @return string?
local function diagnostics()
  local status = {} ---@type string[]
  local diags = vim.diagnostic.count(0)
  for i, attrs in ipairs(DIAG_ATTRS) do
    local n = diags[i] or 0
    if n > 0 then
      table.insert(status, (" %s%s %d"):format(hl(attrs[3]), attrs[2], n))
    end
  end

  return table.concat(status, " ")
end

local function git()
  local res = {}
  if vim.g.gitsigns_head then
    table.insert(res, " " .. vim.g.gitsigns_head)
  end

  if vim.b.gitsigns_status and vim.b.gitsigns_status ~= "" then
    table.insert(res, vim.b.gitsigns_status)
  end

  return table.concat(res, " ")
end

--- @return string
local function filetype()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return ""
  end

  local name = api.nvim_buf_get_name(0)
  --- @type string, string
  local icon, iconhl = devicons.get_icon_color(name, vim.bo.filetype, { default = true })

  local hlname = iconhl:gsub("#", "Status")
  api.nvim_set_hl(0, hlname, { fg = iconhl })

  local filetype_symbol = hl(hlname) .. icon
  return table.concat({ vim.bo.filetype, filetype_symbol }, " ")
end


function _G.statusline()
  return table.concat({
    "%f",
    "%h%w%m%r",
    -- git(),
    diagnostics(),
    hl("StatusLine"),
    macro(),
    "%=",
    lsp_status(),
    " %-14(%l,%c%V%)",
    -- filetype(),
    "%P",
  }, " ")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"

local group = api.nvim_create_augroup("statusline", {})


local redrawstatus = vim.schedule_wrap(function()
  vim.cmd.redrawstatus()
end)

api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  group = group,
  callback = redrawstatus,
})

api.nvim_create_autocmd("DiagnosticChanged", {
  group = group,
  callback = redrawstatus,
})
