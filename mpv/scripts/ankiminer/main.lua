local util = require('mp.utils')
local msg = require('mp.msg')
local mpopt = require('mp.options')

local options = require("config")
local time_to_string = require("utils").time_to_string
mpopt.read_options(options)
local create_anki_note = require("anki").create_anki_note

function inspect(value)
  print(util.format_json(value))
end

local overlay = mp.create_osd_overlay('ass-events')

---@class am.Ctx
local ctx = {
  -- starting time of recording
  start_time = -1,
  end_time = -1,
  snapshot_time = -1,
  subtitles = {
    main = {},
    secondary = {},
  },
}

------------------------------------------------------------
-- creating media and anki note
function get_current_subtitles()
  local subs = mp.get_property('sub-text')
  local secondary = mp.get_property("secondary-sub-text")
  secondary = secondary and secondary:gsub("\n", " ") or nil
  if not subs or subs == "" then
    return
  end
  subs = subs:gsub("\n", " ")
  return subs, secondary
end

------------------------------------------------------------
-- main menu

local menu_keybinds = {
  start_recording = { key = '1', fn = function() start_recording() end },
  set_screenshot = { key = 's', fn = function() menu_set_time('snapshot_time', 'time-pos') end },
  create_anki_card = { key = 'e', fn = function() create_anki_note(true, options, ctx) end },
  create_anki_card_gui = { key = 'shift+e', fn = function() create_anki_note(false, options, ctx) end },
  close_menu = { key = 'ESC', fn = function() menu_close() end },
}

function start_recording()
  reset_recording()
  local time = mp.get_property_number("time-pos")
  ctx.start_time = time
  ctx.snapshot_time = time
  local subs = get_current_subtitles()
  table.insert(ctx.subtitles.main, subs)
  menu_update()
end

function reset_recording()
  ctx.start_time = -1
  ctx.end_time = -1
  ctx.subtitles.main = {}
  ctx.subtitles.secondary = {}
end

function menu_clear_all()
  ctx.start_time = -1
  ctx.end_time = -1
  ctx.snapshot_time = -1
  ctx.sub[1] = ''
  ctx.sub[2] = ''

  menu_update()
end

function menu_update()
  local ass = ASS.new():s(options.font_size):b('MPV2Anki'):nl():nl()

  ass:b("KEYMAPS:"):nl()
  ass:a(menu_keybinds.start_recording.key .. " - Start recording"):nl()
  ass:a("screenshot"):nl()
  ass:a('e: Create card'):nl()
  ass:a("E: creeate card without gui"):nl()
  ass:a("ESC: Close overlay"):nl():nl()

  local recording_status = "RECORDING NOT STARTED"
  if ctx.start_time ~= -1 then
    local start = time_to_string(ctx.start_time)
    local end_ = time_to_string(ctx.end_time)
    local elapsed = tostring(math.floor(ctx.end_time - ctx.start_time))
    recording_status = string.format("Recording... %s - %s (%ss)", start, end_, elapsed)
  end

  ass:b("STATUS"):nl()
  ass:a(recording_status):nl()
  ass:b('SUBTITLES'):nl()
  local start_key = 4
  for i, sub in ipairs(ctx.subtitles.main) do
    ass:a(sub):nl()
  end
  ass:nl():nl()


  ass:draw()
end

function menu_close()
  for _, val in pairs(menu_keybinds) do
    mp.remove_key_binding(val.key)
  end
  overlay:remove()
end

function menu_open()
  for _, val in pairs(menu_keybinds) do
    mp.add_forced_key_binding(val.key, val.key, val.fn)
  end
  menu_update()
end

------------------------------------------------------------
-- Helper functions for styling ASS messages

ASS = {}
ASS.__index = ASS

function ASS.new()
  return setmetatable({ text = '' }, ASS)
end

-- append
function ASS:a(s)
  self.text = self.text .. s
  return self
end

-- bold
function ASS:b(s)
  return self:a('{\\b1}' .. s .. '{\\b0}')
end

-- new line
function ASS:nl()
  return self:a('\\N')
end

-- 4 space tab
function ASS:tab()
  return self:a('\\h\\h\\h\\h')
end

-- size
function ASS:s(size)
  return self:a('{\\fs' .. size .. '}')
end

function ASS:draw()
  overlay.data = self.text
  overlay:update()
end

------------------------------------------------------------
-- Finally, set an 'entry point' in mpv

mp.add_key_binding(options.shortcut, options.shortcut, menu_open)
mp.add_key_binding("G", "abob", function()
  local input = require("mp.input")
  input.get({
    prompt = "Enter word for dictionary lookup and export: ",
    submit = function(value)
      print(value)
      ctx.word = value
      input.terminate()
    end
  })
end)

mp.observe_property("sub-text", "string", function()
  if ctx.start_time ~= -1 then
    ---@type string?
    local subs, secondary = get_current_subtitles()
    table.insert(ctx.subtitles.main, subs)
    table.insert(ctx.subtitles.secondary, secondary)
    menu_update()
    inspect(ctx.subtitles.main)
  end
end)

mp.observe_property("time-pos", "number", function()
  if ctx.start_time == -1 then
    return
  end
  local time = mp.get_property_number("time-pos")
  ctx.end_time = time
  menu_update()
end)

mp.register_event("seek", function()
  reset_recording()
  print("RECORDING ABORTED")
  menu_update()
end)
