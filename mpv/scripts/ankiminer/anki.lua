local util = require('mp.utils')
local media = require("media")
local time_to_string = require("utils").time_to_string

local M = {}

-- All anki requests are of the form:
-- {
--  "action" : @action
--  "version" : 6
--  "params" : @t_params (optional)
-- }
-- and return a lua table with 2 keys, "result" and "error"
function M.anki_connect(action, t_params, url)
  local url = url or 'localhost:8765'

  local request = {
    action = action,
    version = 6,
  }

  if t_params ~= nil then
    request.params = t_params
  end

  local json = util.format_json(request)

  local command = {
    'curl', url, '-X', 'POST', '-d', json
  }

  local result = mp.command_native({
    name = 'subprocess',
    args = command,
    capture_stdout = true,
    capture_stderr = true,
  })

  result = util.parse_json(result.stdout)

  return result.result, result.error
end


function M.create_anki_note(gui, options, ctx)
  local filename_prefix = media.generate_media_name()

  local filename_audio = media.create_audio(
    options.media_path,
    filename_prefix,
    ctx.start_time,
    ctx.end_time,
    options.audio_bitrate)

  local filename_snapshot = media.create_snapshot(
    options.media_path,
    filename_prefix,
    ctx.snapshot_time,
    options.snapshot_height
  )
  print("filename_snapshot: ", filename_snapshot)

  -- Start filling the fields
  local fields = {}

  if #filename_audio > 0 then
    fields[options.field_audio] = '[sound:' .. filename_audio .. ']'
  end

  if #filename_snapshot > 0 then
    fields[options.field_snapshot] = '<img src="' .. filename_snapshot .. '">'
  end

  fields[options.field_subtitle1] = table.concat(ctx.subtitles.main, "\n")
  fields[options.field_subtitle2] = table.concat(ctx.subtitles.secondary, "\n")
  fields[options.field_title] = ctx.word

  local param = {
    note = {
      deckName = options.deckname,
      modelName = options.modelName,
      fields = fields,
      tags = {
        'mpv2anki'
      }
    }
  }

  local action;

  if gui then
    action = 'guiAddCards'
  else
    action = 'addNote'
  end

  inspect(param)

  M.anki_connect(action, param, options.anki_url)
end


return M
