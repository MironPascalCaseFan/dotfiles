vim.pack.add {
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/miroshQa/debugmaster.nvim"
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "blue" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "orange" })
vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "green" })


local dm = require("debugmaster")
vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true, desc = "Debug mode toggle" })
dm.plugins.osv_integration.enabled = true
