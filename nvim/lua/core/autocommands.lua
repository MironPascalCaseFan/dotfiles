vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"help"},
  callback = function()
    vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = 0 })
  end
})

-- disable new line autocomment
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })

    end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  callback = function(ev)
    vim.cmd("wincmd =")
  end,
})


vim.opt.wildmode = "noselect"
vim.opt.wildoptions = "fuzzy"

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = ":",
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.keymap.set("c", "<Tab>", "<C-n>")
