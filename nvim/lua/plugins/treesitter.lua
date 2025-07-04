vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/Wansmer/treesj",
}

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  auto_install = true,
  highlight = {
    enable = true,
  }
}
local swap = require("nvim-treesitter.textobjects.swap")
vim.keymap.set("n", "{", function() swap.swap_previous("@parameter.inner") end)
vim.keymap.set("n", "}", function() swap.swap_next("@parameter.inner") end)
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
}
local tsj = require("treesj")

tsj.setup {
  max_join_length = 1000000,
  use_default_keymaps = false,
}

vim.keymap.set("n", "gs", function() tsj.toggle() end, { desc = "Toggle split/join" })
vim.keymap.set("n", "gS", function() tsj.toggle { split = { recursive = true } } end, { desc = "Toggle split/join (recursive)" })
