local map = vim.keymap.set
local del = vim.keymap.del

-- Windows / Tabs Navigation
map("n", "[t", "<cmd>tabp<CR>", { desc = "Go to prev tab" })
map("n", "]t", "<cmd>tabn<CR>", { desc = "Go to next tab" })

map("n", "<leader>w", function() vim.cmd("silent! w") end, { desc = "Write buffer" })
map("n", "<leader>q", function() vim.cmd("silent! q") end, { desc = "Quit window" })
map("n", "ga", "<cmd>b#<CR>", { desc = "Go to last Accessed file (Ctrl + ^ synonim)" })
map("x", "R", ":s###g<left><left><left>", { desc = "Start replacement in selected range" })
map("n", "<C-n>", "<cmd>cnext<CR>")
map("n", "<C-p>", "<cmd>cprev<CR>")

-- Improved motions (Visual mode)
map('v', '<', '<gv', { noremap = true, silent = true })
map('v', '>', '>gv', { noremap = true, silent = true })

-- snippets stuff
del("s", "<")
del("s", ">")
vim.keymap.set({ "n", "i", "s" }, "<c-n>", function() vim.snippet.jump(1) end)
vim.keymap.set({ "n", "i", "s" }, "<c-p>", function() vim.snippet.jump(-1) end)

map('n', '<leader>ld', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle lsp inlay hints" })

map("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", '[e', function() vim.diagnostic.jump({ severity = "ERROR", count = -1, float = true }) end)
map("n", ']e', function() vim.diagnostic.jump({ severity = "ERROR", count = 1, float = true }) end)
map("n", '[w', function() vim.diagnostic.jump({ severity = "WARN", count = -1, float = true }) end)
map("n", ']w', function() vim.diagnostic.jump({ severity = "WARN", count = 1, float = true }) end)
map("n", ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
map("n", '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)

map("n", "cd", vim.lsp.buf.rename)
map("n", "M", vim.diagnostic.open_float)
map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Lsp format buffer" })
map("n", "<leader>;", "<CMD>:noh<CR>", { desc = "clear search hl", silent = true })

map("n", "<leader>f", function() require("plugins.fzf").files() end, { desc = "Find files" })
map("n", "<leader>'", function() require("plugins.fzf").resume() end, { desc = "Resume last find" })
map("n", "<leader>k", function() require("plugins.fzf").help_tags() end, { desc = "Find help tags" })
map("n", "<leader>.", function() require("plugins.fzf").oldfiles() end, { desc = "Find old files" })
map("n", "<leader>/", function() require("plugins.fzf").live_grep() end, { desc = "Find string (livegrep)" })
map("n", "<leader>g", function() require("plugins.fzf").git_status() end, { desc = "Find changed" })
map("n", "<leader>b", function() require("plugins.fzf").buffers() end, { desc = "Find buffers" })
map("n", "<leader>z", function() require("plugins.fzf").zoxide() end, { desc = "Find zoxide" })

-- LSP
map("n", "<leader>j", function() require("plugins.fzf").lsp_document_symbols() end, { desc = "Find lsp symbols (jump)" })
map("n", "<leader>J", function() require("plugins.fzf").lsp_live_workspace_symbols() end, { desc = "Find lsp workspace symbols (Jump)" })
map("n", "<leader>i", function() require("plugins.fzf").lsp_document_diagnostics() end, { desc = "Find diagnostics" })
map("n", "<leader>I", function() require("plugins.fzf").lsp_workspace_diagnostics() end, { desc = "Find workspace diagnostics" })
map("n", "gd", function() require("plugins.fzf").lsp_definitions() end, { desc = "Go to definition" })
map("n", "gr", function() require("plugins.fzf").lsp_references() end, { desc = "Go to references" })
map("n", "go", function() require("plugins.fzf").lsp_code_actions() end, { desc = "Code actions" })
map("n", "gi", function() require("plugins.fzf").lsp_implementations() end, { desc = "Go to implementations" })
map("n", "gy", function() require("plugins.fzf").lsp_typedefs() end, { desc = "Go to type definition" })

-- <leader>s namespace
map("n", "<leader>sc", function() require("plugins.fzf").git_bcommits() end, { desc = "Find buffer commits" })
map("n", "<leader>sb", function() require("plugins.fzf").git_branches() end, { desc = "Find git branches" })
map("n", "<leader>sC", function() require("plugins.fzf").git_commits() end, { desc = "Find commits" })

map("n", "<leader>e", function()
  require("plugins.neo-tree")
  vim.cmd("Neotree toggle reveal")
end, { desc = "Toggle file tree" })
