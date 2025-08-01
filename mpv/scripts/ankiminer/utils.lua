local M = {}

function M.time_to_string(seconds)
  if seconds < 0 then
    return 'empty'
  end
  local time = string.format('.%03d', seconds * 1000 % 1000);
  time = string.format('%02d:%02d%s',
    seconds / 60 % 60,
    seconds % 60,
    time)

  if seconds > 3600 then
    time = string.format('%02d:%s', seconds / 3600, time)
  end

  return time
end

function M.time_to_string2(seconds)
  return string.format('%02dh%02dM%02ds%03dm',
    seconds / 3600,
    seconds / 60 % 60,
    seconds % 60,
    seconds * 1000 % 1000)
end

return M
