local function match(value, expected)
  return getmetatable(value) == expected
end

local api = vim.api

-- generic params basically. but lua ls suck unfortunately
---@alias T any

---@class TreeModel
local TreeModel = {}
TreeModel.__index = TreeModel

-- such design is very flexible because you can use even numbers (ids) as node!
---@class TreeModel.providers
---@field render_node fun(node: T, ctx)
---@field get_children fun(node: T)
---@field handle_event fun(node: T, event)

-- Should decouple tree model from buffer actually
-- TreModel should only send events about commands what was applied to this model
-- like children changed etc
-- BufferAttachment1  --> 
-- ...                      TreeModel <- Modifications (Node updates)
-- BufferAttachmentN -->


---@param root T
---@param providers TreeModel.providers
---@return TreeModel
function TreeModel.new(root, providers)
  ---@class TreeModel
  local instance = {
    ---@type table<table, integer>
    node_to_mark_map = {},
    ---@type table<integer, table>
    mark_to_node_map = {},
    buf = api.nvim_create_buf(false, true),
    extmarks_ns = api.nvim_create_namespace(""),
    hl_ns = api.nvim_create_namespace(""),
    root = root,
    providers = providers,
  }

  return setmetatable(instance, TreeModel)
end

function TreeModel:update(node)
  local lines = {}
  local highlights = {} ---@type {line: number, hl: string, col_start: number, col_end: number}[]
  local marks = {} ---@type {node: table, row: number, end_row: number}[]

  local function render(node, depth)
    local start_line = #lines
    local line = self.providers.render_node(node, { depth = depth })
    table.insert(lines, line)
    local children = self.providers.get_children(node)
    if children then
      for _, node in ipairs(children) do
        render(node, depth + 1)
      end
    end
    local end_line = #lines
    table.insert(marks, { node = node, row = start_line, end_row = end_line })
  end

  render(node or self.root, 0 + 1)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)

  for _, mark in ipairs(marks) do
    local id = api.nvim_buf_set_extmark(self.buf, self.extmarks_ns, mark.row, 0, {
      end_row = mark.end_row,
      end_right_gravity = true, -- when we remove lines before this mark, end shouldn't shift backward. that is relevant only when end_row == mark.row
    })
    self.node_to_mark_map[mark.node] = id
    self.mark_to_node_map[id] = mark.node
  end
end

function TreeModel:get(line)
  local marks = api.nvim_buf_get_extmarks(self.buf, self.extmarks_ns, { line, 0 }, { line, 0 }, {
    limit = 100,
    overlap = true,
    details = true,
  })
  local nodes = {}
  for _, mark in ipairs(marks) do
    local id = mark[1]
    local node = self.mark_to_node_map[id]
    table.insert(nodes, node)
  end
  return nodes
end

function TreeModel:add_key_events(keymaps)
  for _, key in pairs(keymaps) do
    local mode = "n"
    api.nvim_buf_set_keymap(self.buf, mode, key, "", {
      nowait = true,
      callback = function()
        assert(self.buf == api.nvim_win_get_buf(0), "current window buf must match snapshot buf!")
        local line = api.nvim_win_get_cursor(0)[1] - 1
        local node = self:get(line)
        self.providers.handle_event(node, { key = "<CR>" }, self)
      end
    })
  end
end

return {
  tree = TreeModel,
  defaults = {
    providers = {
      render_node = function(node, ctx)
        return node.render and node:render() or ""
      end,
      get_children = function(node)
        return node.children
      end,
      handle_event = function(node, event)
      end
    }
  }
}

-- TreeModel
-- set_children(target, nodes)
-- add_adjacent_down(target, nodes)
-- add_adjacent_up(target, nodes)
-- update_node()
-- remove_node()ADTADT
