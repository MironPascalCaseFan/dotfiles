vim.pack.add {
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim"
}

vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Lsp restart" })
vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Mason" })

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

require("mason").setup { ui = { backdrop = 100, } }
require("mason-lspconfig").setup()

-- still can install and setup servers manually without mason
-- rust analyzer ships with rustup so we don't want to install it with mason)
-- just install it manually and then enable it via vim.lsp
vim.lsp.enable("rust_analyzer")
require("fidget").setup {}
