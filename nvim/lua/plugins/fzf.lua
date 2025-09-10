vim.pack.add {
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
}

local fzf = require("fzf-lua")

fzf.setup {
  "hide",
  fzf_opts = { ["--cycle"] = true },
  files = {
    git_icons = false,
  },
  winopts = {
    row = 0.5,
    width = 0.8,
    height = 0.8,
    title_flags = false,
    preview = {
      horizontal = "right:50%",
      scrollbar = false,
    },
    backdrop = 100,
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
    builtin = {
      true,
      ["<esc>"] = "hide",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    }
  }
}
fzf.register_ui_select()


return fzf
