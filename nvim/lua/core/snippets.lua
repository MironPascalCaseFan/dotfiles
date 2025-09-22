-- https://www.reddit.com/r/neovim/comments/1g1x0v3/hacking_native_snippets_into_lsp_for_builtin/
local M = {}

local snippets_storage = {}

---Add vs code style snippet
---@param body string vs code style snippet string
---@param opts {ft: string, desc: string?}
function M.add(trig, body, opts)
  if not snippets_storage[opts.ft] then
    snippets_storage[opts.ft] = { items = {}, isIncomplete = false }
  end
  table.insert(snippets_storage[opts.ft].items, {
    detail = opts.desc or "User Snippet",
    label = trig,
    kind = vim.lsp.protocol.CompletionItemKind["Snippet"],
    documentation = {
      value = body,
      kind = vim.lsp.protocol.MarkupKind.Markdown,
    },
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    insertText = body,
    sortText = 1.02, -- Ensure a low score by setting a high sortText value, not sure
  })
end

---@param snippets_storage table: The completion result to be returned by the server
---@return function: A function that creates a new server instance
local function new_server(snippets_storage)
  local function server(dispatchers)
    local closing = false
    local srv = {}
    function srv.request(method, params, handler)
      if method == "initialize" then
        handler(nil, {
          capabilities = {
            completionProvider = {
              triggerCharacters = {},
            },
          },
        })
      elseif method == "textDocument/completion" then
        local snippets = snippets_storage[vim.bo.filetype] or {}
        handler(nil, snippets)
      elseif method == "shutdown" then
        handler(nil, nil)
      end
    end
    function srv.notify(method, _)
      if method == "exit" then
        dispatchers.on_exit(0, 15)
      end
    end
    function srv.is_closing()
      return closing
    end
    function srv.terminate()
      closing = true
    end
    return srv
  end
  return server
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    local server = new_server(snippets_storage)
    vim.lsp.start { name = "snippets", cmd = server }
  end,
})

return M
