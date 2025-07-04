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

local function macro()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "Recording macro in: " .. reg
end

vim.pack.add {
  "https://github.com/nvim-lualine/lualine.nvim"
}

local dmode_enabled = false
vim.api.nvim_create_autocmd("User", {
  pattern = "DebugModeChanged",
  callback = function(args)
    dmode_enabled = args.data.enabled
  end
})
require("lualine").setup {
  options = {
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str) return dmode_enabled and "DEBUG" or str end,
        color = function(tb) return dmode_enabled and "dCursor" or tb end,
      },
    },
    lualine_b = {},
    lualine_c = {
      { "filename", path = 1 },
      { "branch" },
      { "diff" },
      { "diagnostics" },
      { macro },
    },
    lualine_x = {
      { lsp_status },
      { "filetype" },
    },
    lualine_y = { { "progress" }, { "location" } },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
}
