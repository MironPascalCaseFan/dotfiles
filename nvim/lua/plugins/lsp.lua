vim.pack.add {
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
}

vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Lsp restart" })
vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Mason" })


require("mason").setup { ui = { backdrop = 100, } }
require("fidget").setup {}
