local mason_bin = vim.fs.joinpath(vim.fn.stdpath('data'), "mason/bin")
---@param name string
---@return string
vim.get_mason_bin = function(name)
  return vim.fs.joinpath(mason_bin, name)
end

---Add vs code style snippet
---@param body string vs code style snippet string
---@param opts {ft: string}
vim.snippet.add = function(trig, body, opts)
  local ls = require("luasnip")
  ls.add_snippets(opts.ft, { ls.parser.parse_snippet(trig, body) })
end

vim.dap = require("dap")
vim.dap.utils = require("dap.utils")
vim.dap.utils.query_args = function()
  return vim.split(vim.fn.input('Program arguments: '), " +")
end

---@type table<string, fun()>
vim.ftplugin = {}
