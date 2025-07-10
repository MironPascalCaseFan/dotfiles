-- 1. Snippets
-- 2. Lsp server
-- 3. Debugger
-- 4. Indents and other specific language options

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        },
      }
    },
  }
})
vim.lsp.enable("lua_ls")

vim.snippet.add("au", [[
vim.api.nvim_create_autocmd("${1:Event}", {
  callback = function(args)
    $0
  end
})
]], { ft = "lua" })


vim.snippet.add("cl", [[
---@class ${1:namespace}.${2:ClassName}
local $2 = {}

function $2.new()
  ---@class $1.$2
  local self = setmetatable({}, {__index = $2})
  return self
end

function $2:${3:some_method}()
  $4
end
]], { ft = "lua" })

-- http://lua-users.org/wiki/StringsTutorial (check about [= syntax)
vim.snippet.add("sa", [=[
vim.snippet.add("${1:trigger}", [[
${2:snippet}
]], {ft = "${3:filetype}"})
]=], { ft = "lua" })

vim.snippet.add("bp", [[
local api = vim.api
local buf = api.nvim_create_buf(false, true)
local win = api.nvim_open_win(buf, false, {split = "right"})
]], { ft = "lua" })

vim.snippet.add("k", [[
vim.keymap.set("${1:mode}", "${2:key}", ${3:action})
]], { ft = "lua" })

vim.ftplugin.lua = function()
  vim.keymap.set("v", "r", ":'<,'>lua<CR>", { buffer = 0, silent = true })
  vim.keymap.set("n", "R", ":source %<CR>", { buffer = 0, silent = true })
end
