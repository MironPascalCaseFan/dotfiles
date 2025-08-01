local time_to_string2 = require("utils").time_to_string2
local util = require('mp.utils')

local M = {}

function M.generate_media_name()
  local name = mp.get_property('filename/no-ext')
  name = string.gsub(name, '[%[%]]', '')
  return name
end

-- Creates an audio fragment with @start_time and @end_time in @media_path.
-- Returns a string containing the name to the audio file
-- or an empty string on error
function M.create_audio(
    media_path,
    filename_prefix,
    start_time,
    end_time,
    bitrate)
  if (start_time < 0 or end_time < 0) or
      (start_time == end_time) then
    return ''
  end

  if start_time > end_time then
    local t = start_time
    start_time = end_time
    end_time = t
  end

  local filename = string.format(
    '%s_(%s-%s).mp3',
    filename_prefix,
    time_to_string2(start_time),
    time_to_string2(end_time))

  local encode_args = {
    'mpv', mp.get_property('path'),
    '--start=' .. start_time,
    '--end=' .. end_time,
    '--aid=' .. mp.get_property("aid"),
    '--vid=no',
    '--loop-file=no',
    '--oacopts=b=' .. bitrate,
    '-o=' .. media_path .. filename
  }

  local result = mp.command_native({
    name = 'subprocess',
    args = encode_args,
    capture_stdout = true,
    capture_stderr = true,
  })

  return filename
end

-- Takes a snapshot at @snapshot_time and writes it to @media_path
-- Returns a string containing the name to the snapshot
-- or an empty string on error
function M.create_snapshot(media_path, filename_prefix, snapshot_time, height)
  if (snapshot_time <= 0) then
    return ''
  end

  local filename = string.format(
    '%s_(%s).jpg',
    filename_prefix,
    time_to_string2(snapshot_time)
  )

  -- Sadly the screenshot command does not allow us to create screenshots on specific
  -- times nor resize images. So we have to encode to a single image instead
  local encode_args = {
    'mpv', mp.get_property('path'),
    '-start=' .. snapshot_time,
    '--frames=1',
    '--no-audio',
    '--no-sub',
    -- https://github.com/mpv-player/mpv/issues/9053
    ('-o=' .. media_path .. filename),
    "-vf",
    "scale=out_range=pc",
  }
  -- TODO: Error handling

  local result = mp.command_native({
    name = 'subprocess',
    args = encode_args,
    capture_stdout = true,
    capture_stderr = true,
  })
  print("snapshot result :", util.format_json(result))

  return filename
end

return M
