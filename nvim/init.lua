vim.g._ts_force_sync_parsing = true
vim.cmd("colorscheme gruvboxbaby")
require("vim._extui").enable {}
require("core.options")
require("core.autocommands")
require("core.keymaps")

local files = vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true)
local function load_file(path)
  local co = coroutine.running()
  vim.defer_fn(function()
    loadfile(path)()
    coroutine.resume(co)
  end, 2)
  coroutine.yield()
end

coroutine.wrap(function()
  for _, path in ipairs(files) do
    load_file(path)
  end
  require("languages")
end)()
