----UTILS
local function createGrid(width, height, fillChar)
  local grid = {}
  for y = 1, height do
    grid[y] = {}
    for x = 1, width do
      grid[y][x] = fillChar
    end
  end
  return grid
end
---


---@class dm.Rect
---@field x integer
---@field y integer
---@field height integer
---@field width integer

---@class dm.IRenderable
---@field render fun(self: any, canvas: dm.ICanvas, area: dm.Rect)

---@class dm.ICanvas
---@field put fun(self: any, x: integer, y: integer, char: string, hl: string) Indexing starts from 0


---@class dm.Canvas: dm.ICanvas
---@field grid table<table<string>>
local Canvas = {}
Canvas.__index = Canvas

function Canvas.new(width, height, char)
  return setmetatable({
    grid = createGrid(width, height, char or "")
  }, Canvas)
end

---comment
---@param buf integer
function Canvas:draw(buf)
  local lines = {}
  for _, line in ipairs(self.grid) do
    table.insert(lines, table.concat(line))
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

function Canvas:put(x, y, char, hl)
  self.grid[y + 1][x + 1] = char
end


---@class dm.Line: dm.IRenderable
---@field line string
local Line = {}
Line.__index = Line

function Line.new(line)
  return setmetatable({line = line}, Line)
end

function Line:render(canvas, area)
  local line_len = #self.line
  local start_x = area.x
  local end_x = math.min(area.x + area.width, area.x + line_len)
  for x = start_x, end_x - 1 do
    local pos = x - start_x + 1
    local char = assert(self.line:sub(pos, pos))
    canvas:put(x, area.y, char, "")
  end
end

return {
  Canvas = Canvas,
  Line = Line,
}
