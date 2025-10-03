vim.pack.add {
  "https://github.com/MagicDuck/grug-far.nvim"
}

require("grug-far").setup {
  keymaps = {
    qflist = { n = "" }
  }
}
vim.keymap.set("n", "<leader>r", function()
  require("grug-far").open { windowCreationCommand = "tabnew" }
end)
