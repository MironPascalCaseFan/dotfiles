-- https://github.com/luvit/luv
local function test_server()
  -- local async = require("core.async")
  local server = assert(vim.uv.new_tcp())
  assert(server:bind("127.0.0.1", 32222), true)
  server:listen(128, function(err)
    -- Make sure there was no problem setting up listen
    assert(not err, err)

    local client = assert(vim.uv.new_tcp())
    assert(server:accept(client))
    local info = assert(client:getpeername())
    print("connection with ", info.ip, ":", info.port, " established")
    client:read_start(function(err, data)
      assert(not err)
      print("data received:\n", data)
      print("data in bytes:\n", (data or ""):gsub(".", function(c) return string.byte(c) .. " " end))
      print(string.rep("-", 20))
    end)
  end)

  -- Ways to connect through CLI:
  -- 1. nc localhost 32222
  -- 2. telnet localhost 32222
  -- 3. curl http://localhost:32222

  -- Ways to display used sockets on your system:
  -- 3. sudo ss -tulnp
  -- 1. sudo netstat -tulnp
  -- 2. sudo lsof -i -P -n

  -- To activate not canonical terminal mode: stty -icanon
end

-- test_server()

local api = vim.api
package.loaded["core.ui"] = nil
local ui = require("core.ui")
local Canvas, Line = ui.Canvas, ui.Line
local canvas = Canvas.new(100, 100, ".")
local line1 = Line.new("some text heheheheh")
line1:render(canvas, {y = 2, x = 2, width = 200})

local buf = api.nvim_create_buf(false, true)
local win = api.nvim_open_win(buf, false, {split = "right"})
canvas:draw(buf)
