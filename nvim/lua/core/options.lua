-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better UX
vim.opt.autowriteall = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 20

-- Indents settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.showcmd = false
vim.o.winborder = "rounded"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes"
vim.opt.breakindent = true
vim.g.termguicolors = true
vim.opt.updatetime = 250
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.fillchars = { eob = " " }
vim.go.guicursor = "n-v-sm:block,i-t-ci-ve-c:ver25,r-cr-o:hor20"
-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- https://www.reddit.com/r/neovim/comments/1jmqd7t/sorry_ufo_these_7_lines_replaced_you/
-- Nice and simple folding:
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

-- Prefer LSP folding if client supports it. Allows to fold comments and more
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})

vim.cmd([[ :set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz ]])
