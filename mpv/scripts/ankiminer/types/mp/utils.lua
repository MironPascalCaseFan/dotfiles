---@meta
local utils

-- This built-in module provides generic helper functions for Lua, and have
-- strictly speaking nothing to do with mpv or video/audio playback. They are
-- provided for convenience. Most compensate for Lua's scarce standard library.
--
-- Be warned that any of these functions might disappear any time. They are not
-- strictly part of the guaranteed API.

-- Returns the directory that mpv was launched from. On error, `nil, error`
-- is returned.
function utils.getcwd() end

-- Enumerate all entries at the given path on the filesystem, and return them
-- as array. Each entry is a directory entry (without the path).
-- The list is unsorted (in whatever order the operating system returns it).
--
-- If the `filter` argument is given, it must be one of the following
-- strings:
--
--     `files`
--         List regular files only. This excludes directories, special files
--         (like UNIX device files or FIFOs), and dead symlinks. It includes
--         UNIX symlinks to regular files.
--
--     `dirs`
--         List directories only, or symlinks to directories. `.` and `..`
--         are not included.
--
--     `normal`
--         Include the results of both `files` and `dirs`. (This is the
--         default.)
--
--     `all`
--         List all entries, even device files, dead symlinks, FIFOs, and the
--         `.` and `..` entries.
--
-- On error, `nil, error` is returned.
---@param filter? any
function utils.readdir(path, filter) end

-- Stats the given path for information and returns a table with the
-- following entries:
--
--     `mode`
--         protection bits (on Windows, always 755 (octal) for directories
--         and 644 (octal) for files)
--     `size`
--         size in bytes
--     `atime`
--         time of last access
--     `mtime`
--         time of last modification
--     `ctime`
--         time of last metadata change
--     `is_file`
--         Whether `path` is a regular file (boolean)
--     `is_dir`
--         Whether `path` is a directory (boolean)
--
-- `mode` and `size` are integers.
-- Timestamps (`atime`, `mtime` and `ctime`) are integer seconds since
-- the Unix epoch (Unix time).
-- The booleans `is_file` and `is_dir` are provided as a convenience;
-- they can be and are derived from `mode`.
--
-- On error (e.g. path does not exist), `nil, error` is returned.
function utils.file_info(path) end

-- Split a path into directory component and filename component, and return
-- them. The first return value is always the directory. The second return
-- value is the trailing part of the path, the directory entry.
function utils.split_path(path) end

-- Return the concatenation of the 2 paths. Tries to be clever. For example,
-- if `p2` is an absolute path, `p2` is returned without change.
function utils.join_path(p1, p2) end

-- Runs an external process and waits until it exits. Returns process status
-- and the captured output. This is a legacy wrapper around calling the
-- `subprocess` command with `mp.command_native`. It does the following
-- things:
--
-- - copy the table `t`
-- - rename `cancellable` field to `playback_only`
-- - rename `max_size` to `capture_size`
-- - set `capture_stdout` field to `true` if unset
-- - set `name` field to `subprocess`
-- - call `mp.command_native(copied_t)`
-- - if the command failed, create a dummy result table
-- - copy `error_string` to `error` field if the string is non-empty
-- - return the result table
--
-- It is recommended to use `mp.command_native` or `mp.command_native_async`
-- directly, instead of calling this legacy wrapper. It is for compatibility
-- only.
--
-- See the `subprocess` documentation for semantics and further parameters.
function utils.subprocess(t) end

-- Runs an external process and detaches it from mpv's control.
--
-- The parameter `t` is a table. The function reads the following entries:
--
--     `args`
--         Array of strings of the same semantics as the `args` used in the
--         `subprocess` function.
--
-- The function returns `nil`.
--
-- This is a legacy wrapper around calling the `run` command with
-- `mp.commandv` and other functions.
function utils.subprocess_detached(t) end

-- Returns the process ID of the running mpv process. This can be used to identify
-- the calling mpv when launching (detached) subprocesses.
function utils.getpid() end

-- Returns the C environment as a list of strings. (Do not confuse this with
-- the Lua "environment", which is an unrelated concept.)
function utils.get_env_list() end

-- Parses the given string argument as JSON, and returns it as a Lua table. On
-- error, returns `nil, error`. (Currently, `error` is just a string
-- reading `error`, because there is no fine-grained error reporting of any
-- kind.)
--
-- The returned value uses similar conventions as `mp.get_property_native()`
-- to distinguish empty objects and arrays.
--
-- If the `trail` parameter is `true` (or any value equal to `true`),
-- then trailing non-whitespace text is tolerated by the function, and the
-- trailing text is returned as 3rd return value. (The 3rd return value is
-- always there, but with `trail` set, no error is raised.)
---@param trail? any
function utils.parse_json(str, trail) end

-- Format the given Lua table (or value) as a JSON string and return it. On
-- error, returns `nil, error`. (Errors usually only happen on value types
-- incompatible with JSON.)
--
-- The argument value uses similar conventions as `mp.set_property_native()`
-- to distinguish empty objects and arrays.
function utils.format_json(v) end

-- Turn the given value into a string. Formats tables and their contents. This
-- doesn't do anything special; it is only needed because Lua is terrible.
function utils.to_string(v) end

return utils
