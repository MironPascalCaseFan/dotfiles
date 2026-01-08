package.loaded["core.tree"] = nil
local api = vim.api
local tree = require("core.tree")


local function indent_decorator(wrapped)
  return function(node, ctx)
    return string.rep("  ", ctx.depth) .. wrapped(node, ctx)
  end
end


local function new_fs_tree()
  local expanded = {}
  local function render(node, ctx)
    if node.dir then
      return "DIRECTORY: " .. node.dir
    elseif node.file then
      return "FILE: " .. node.file
    end
    return "WHAT THE FUCK"
  end

  local render_node = indent_decorator(render)

  local function toggle_node(node)
    if node.dir then
      if node.children then
        node.children = nil
        return
      end
      node.children = {}
      for name, type in vim.fs.dir(node.dir) do
        if type == "directory" then
          table.insert(node.children, { dir = vim.fs.joinpath(node.dir, name) })
        elseif type == "file" then
          table.insert(node.children, { file = vim.fs.joinpath(node.dir, name) })
        end
      end
    end
  end
  local root = { dir = "/home/miron/.local/share/Anki2/User 1/", children = {} }
  local providers = {
    render_node = render_node,
    get_children = function(node)
      return node.children
    end,
    handle_event = function(nodes, event, model)
      local node = nodes[#nodes]
      if event.key == "<CR>" then
        toggle_node(node)
      end
      model:update()
    end
  }
  local model = tree.tree.new(root, providers)
  model:add_key_events { "<CR>" }
  model:update()
  local win = api.nvim_open_win(model.buf, false, { split = "right", width = 100 })
end

new_fs_tree()
