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
  require("core.snippets").add(trig, body, opts)
end

vim.dap = require("dap")
vim.dap.utils = require("dap.utils")
vim.dap.utils.query_args = function()
  return vim.split(vim.fn.input('Program arguments: '), " +")
end

---Allows you to pick any file in your current directory and return it as a string
---@async
---@return string
vim.pick_file = function(cmd)
  cmd = cmd or "find ."
  local co = coroutine.running()
  require("fzf-lua").files({
    cmd = cmd,
    git_icons = false,
    file_icons = false,
    actions = {
      default = function(selected)
        coroutine.resume(co, selected[1])
      end
    }
  })
  return coroutine.yield()
end
