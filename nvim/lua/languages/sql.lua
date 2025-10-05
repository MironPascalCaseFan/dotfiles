-- https://github.com/kristijanhusak/vim-dadbod-ui/issues/300
vim.pack.add {
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
}
vim.g.db_ui_use_nerd_fonts = 1
vim.cmd([[
  autocmd FileType sql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])

local null_ls = require("null-ls")
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.sqruff,
    null_ls.builtins.diagnostics.sqruff,
  },
}
