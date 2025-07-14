vim.pack.add {
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/miroshQa/debugmaster.nvim"
}



local dm = require("debugmaster")
vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true, desc = "Debug mode toggle" })
dm.plugins.osv_integration.enabled = true
