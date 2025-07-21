vim.pack.add {
  "https://github.com/folke/snacks.nvim"
}

vim.keymap.set("n", "<leader>o", function()
  Snacks.scratch {
    ft = function() return "lua" end,
    filekey = {
      cwd = false,
      branch = false,
      count = false,
    },
  }
end, { desc = "Toggle Scratch Buffer" })
