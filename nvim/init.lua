vim.g._ts_force_sync_parsing = true
vim.cmd("colorscheme gruvboxbaby")
require("vim._extui").enable {}
require("core.options")
require("core.autocommands")
require("core.keymaps")
require("core.statusline")

local function load_file(path)
  local co = coroutine.running()
  vim.defer_fn(function()
    -- local start = vim.uv.hrtime()
    loadfile(path)()
    -- print(path, " loading time: ", (vim.uv.hrtime() - start) / 1000000, "ms")
    coroutine.resume(co)
  end, 2)
  coroutine.yield()
end

coroutine.wrap(function()
  local groups = {
    vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true),
    vim.api.nvim_get_runtime_file("lua/core/std.lua", true),
    vim.api.nvim_get_runtime_file("lua/languages/*.lua", true)
  }
  for _, files in ipairs(groups) do
    for _, path in ipairs(files) do
      load_file(path)
    end
  end
end)()
