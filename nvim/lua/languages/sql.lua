-- Dadbod version
-- vim.pack.add {
--   "https://github.com/tpope/vim-dadbod",
--   "https://github.com/kristijanhusak/vim-dadbod-ui",
--   "https://github.com/kristijanhusak/vim-dadbod-completion",
-- }
-- vim.g.db_ui_use_nerd_fonts = 1
-- vim.cmd([[
--   autocmd FileType sql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
-- ]])

-- Dbee version
vim.pack.add {
  "https://github.com/kndndrj/nvim-dbee",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/MattiasMTS/cmp-dbee",
}
-- require("dbee").install()
require("dbee").setup()
require("cmp-dbee").setup()
vim.cmd([[
  autocmd FileType sql lua require('cmp').setup.buffer({ sources = {{ name = 'cmp-dbee' }} })
]])
