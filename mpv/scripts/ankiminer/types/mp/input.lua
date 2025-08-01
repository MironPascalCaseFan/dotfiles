---@meta
local input

-- This module lets scripts get textual input from the user using the console
-- REPL.

-- Show the console to let the user enter text.
--
-- The following entries of `table` are read:
--
-- `prompt`
--     The string to be displayed before the input field.
--
-- `submit`
--     A callback invoked when the user presses Enter. The first argument is
--     the text in the console. You can close the console from within the
--     callback by calling `input.terminate()`. If you don't, the console
--     stays open and the user can input more text.
--
-- `opened`
--     A callback invoked when the console is shown. This can be used to
--     present a list of options with `input.set_log()`.
--
-- `edited`
--     A callback invoked when the text changes. This can be used to filter a
--     list of options based on what the user typed with `input.set_log()`,
--     like dmenu does. The first argument is the text in the console.
--
-- `complete`
--     A callback invoked when the user presses TAB. The first argument is the
--     text before the cursor. The callback should return a table of the string
--     candidate completion values and the 1-based cursor position from which
--     the completion starts. console.lua will filter the suggestions beginning
--     with the the text between this position and the cursor, sort them
--     alphabetically, insert their longest common prefix, and show them when
--     there are multiple ones.
--
-- `closed`
--     A callback invoked when the console is hidden, either because
--     `input.terminate()` was invoked from the other callbacks, or because
--     the user closed it with a key binding. The first argument is the text in
--     the console, and the second argument is the cursor position.
--
-- `default_text`
--     A string to pre-fill the input field with.
--
-- `cursor_position`
--     The initial cursor position, starting from 1.
--
-- `id`
--     An identifier that determines which input history and log buffer to use
--     among the ones stored for `input.get()` calls. The input histories
--     and logs are stored in memory and do not persist across different mpv
--     invocations. Defaults to the calling script name with `prompt`
--     appended.
function input.get(table) end

-- Close the console.
function input.terminate() end

-- Add a line to the log buffer. `style` can contain additional ASS tags to
-- apply to `message`, and `terminal_style` can contain escape sequences
-- that are used when the console is displayed in the terminal.
function input.log(message, style, terminal_style) end

-- Helper to add a line to the log buffer with the same color as the one the
-- console uses for errors. Useful when the user submits invalid input.
function input.log_error(message) end

-- Replace the entire log buffer.
--
-- `log` is a table of strings, or tables with `text`, `style` and
-- `terminal_style` keys.
--
-- Example:
--
-- ```lua
--     input.set_log({
--         "regular text",
--         {
--             text = "error text",
--             style = "{\\c&H7a77f2&}",
--             terminal_style = "\027[31m",
--         }
--     })
-- ```
function input.set_log(log) end

return input
