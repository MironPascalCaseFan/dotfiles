vim.lsp.enable("texlab")
vim.lsp.enable('tinymist')

vim.pack.add {
  'https://github.com/chomosuke/typst-preview.nvim',
}
require("typst-preview").setup({})
