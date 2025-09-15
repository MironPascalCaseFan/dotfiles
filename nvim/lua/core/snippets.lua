-- https://www.reddit.com/r/neovim/comments/1g1x0v3/hacking_native_snippets_into_lsp_for_builtin/
local M = {}

local snippets_storage = {}

---@brief Process only one JSON encoded string
---@param snips string: JSON encoded string containing snippets
---@param desc string: Description for the snippets (optional)
---@return table: A table containing completion results formatted for LSP
function M.process_snippets(snips, desc)
  local snippets_table = {}
  local completion_results = {
    isIncomplete = false,
    items = {},
  }
  -- Decode the JSON input
  for _, v in pairs(vim.json.decode(snips)) do
    local prefixes = type(v.prefix) == "table" and v.prefix or { v.prefix }
    -- Handle v.body as a table or string
    local body
    if type(v.body) == "table" then
      -- Concatenate the table elements into a single string, separated by newlines
      body = table.concat(v.body, "\n")
    else
      -- If it's already a string, use it directly
      body = v.body
    end
    -- Add each prefix-body pair to the table
    for _, prefix in ipairs(prefixes) do
      snippets_table[prefix] = body
    end
  end

  -- Transform the snippets_table into completion_results
  for label, insertText in pairs(snippets_table) do
    table.insert(completion_results.items, {
      detail = desc or "User Snippet",
      label = label,
      kind = vim.lsp.protocol.CompletionItemKind["Snippet"],
      documentation = {
        value = insertText,
        kind = vim.lsp.protocol.MarkupKind.Markdown,
      },
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
      insertText = insertText,
      sortText = 1.02, -- Ensure a low score by setting a high sortText value, not sure
    })
  end
  return completion_results
end

---comment
---@param filetypes string[]
---@param snip {body: string, desc: string, trigger: string }[]
function M.add_lua_snippets(filetypes, snip)
end

---Add vs code style snippet
---@param body string vs code style snippet string
---@param opts {ft: string}
function M.add(trig, body, opts)
  if not snippets_storage[opts.ft] then
    snippets_storage[opts.ft] = {items = {}, isIncomplete = false}
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
              triggerCharacters = { "{", "(", "[", " ", "}", ")", "]" },
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
    vim.lsp.start({name = "snippets", cmd = server})
  end,
})

return M
