vim.pack.add {
  "https://github.com/ibhagwan/fzf-lua"
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

vim.keymap.set("n", "<leader>f", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>'", fzf.resume, { desc = "Resume last find" })
vim.keymap.set("n", "<leader>k", fzf.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>.", fzf.oldfiles, { desc = "Find old files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Find string (livegrep)" })
vim.keymap.set("n", "<leader>g", fzf.git_status, { desc = "Find changed" })
vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>z", fzf.zoxide, { desc = "Find zoxide" })

-- LSP
vim.keymap.set("n", "<leader>j", fzf.lsp_document_symbols, { desc = "Find lsp symbols (jump)" })
vim.keymap.set("n", "<leader>J", fzf.lsp_live_workspace_symbols, { desc = "Find lsp workspace symbols (Jump)" })
vim.keymap.set("n", "<leader>i", fzf.lsp_document_diagnostics, { desc = "Find diagnostics" })
vim.keymap.set("n", "<leader>I", fzf.lsp_workspace_diagnostics, { desc = "Find workspace diagnostics" })
vim.keymap.set("n", "gd", fzf.lsp_definitions)
vim.keymap.set("n", "gr", fzf.lsp_references)
vim.keymap.set("n", "go", fzf.lsp_code_actions)
vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "lsp implementations" })
vim.keymap.set("n", "gy", fzf.lsp_typedefs, { desc = "lsp type definitions" })

-- <leader>s namespace
vim.keymap.set("n", "<leader>sc", fzf.git_bcommits, { desc = "Find buffer commits" })
vim.keymap.set("n", "<leader>sb", fzf.git_branches, { desc = "Find git branches" })
vim.keymap.set("n", "<leader>sC", fzf.git_commits, { desc = "Find commits" })
