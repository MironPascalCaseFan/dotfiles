vim.pack.add {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MunifTanjim/nui.nvim",
  {src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "3.0"}
}

require("neo-tree").setup {
  popup_border_style = "rounded",
  filesystem = {
    shared_clipboard = true,
    hijack_netrw_behavior = "open_current",
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    },
  },
  window = {
    position = "current",
    mappings = {
      ["/"] = false,
      ["<space>"] = false,
      ["?"] = false,
      ["w"] = false,
      ["e"] = false,
      ["f"] = false,
      ["t"] = false,
      ["D"] = false,
      ["g?"] = "show_help",
      ["q"] = false,
      ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
      ["<esc>"] = false,
      ["#"] = false,
      ["<"] = false,
      [">"] = false,
      ["s"] = false,
    },
  },
}
