vim.pack.add {
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/NeogitOrg/neogit"
}

local gitsigns = require("gitsigns")

gitsigns.setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
}

vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>hU", "<cmd>Gitsigns reset_buffer_index<CR>", { desc = "Undo buffer staging" })
vim.keymap.set("n", "H", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "L", function() gitsigns.blame_line { full = true } end, { desc = "Line blame" })
vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" })
vim.keymap.set("n", "[h", function() gitsigns.nav_hunk("prev", { preview = true, navigation_message = false }) end, { desc = "Prev hunk" })
vim.keymap.set("n", "]h", function() gitsigns.nav_hunk("next", { preview = true, navigation_message = false }) end, { desc = "Next hunk" })

vim.keymap.set("n", "<leader>v", "<cmd>Neogit<CR>", { desc = "Open vsc (git)" })
