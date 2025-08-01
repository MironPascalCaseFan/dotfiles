---@meta
mp = mp

-- # mp functions
-- The `mp` module is preloaded, although it can be loaded manually with
-- `require 'mp'`. It provides the core client API.

-- Run the given command. This is similar to the commands used in input.conf.
-- See [List of Input Commands].
--
-- By default, this will show something on the OSD (depending on the command),
-- as if it was used in `input.conf`. See [Input Command Prefixes] how
-- to influence OSD usage per command.
--
-- Returns `true` on success, or `nil, error` on error.
function mp.command(string) end

-- Similar to `mp.command`, but pass each command argument as separate
-- parameter. This has the advantage that you don't have to care about
-- quoting and escaping in some cases.
--
-- Example:
--
-- ```lua
--     mp.command("loadfile " .. filename .. " append")
--     mp.commandv("loadfile", filename, "append")
-- ````
--
-- These two commands are equivalent, except that the first version breaks
-- if the filename contains spaces or certain special characters.
--
-- Note that properties are *not* expanded.  You can use either `mp.command`,
-- the `expand-properties` prefix, or the `mp.get_property` family of
-- functions.
--
-- Unlike `mp.command`, this will not use OSD by default either (except
-- for some OSD-specific commands).
function mp.commandv(arg1, arg2, ...) end

-- Similar to `mp.commandv`, but pass the argument list as table. This has
-- the advantage that in at least some cases, arguments can be passed as
-- native types. It also allows you to use named argument.
--
-- If the table is an array, each array item is like an argument in
-- `mp.commandv()` (but can be a native type instead of a string).
--
-- If the table contains string keys, it's interpreted as command with named
-- arguments. This requires at least an entry with the key `name` to be
-- present, which must be a string, and contains the command name. The special
-- entry `_flags` is optional, and if present, must be an array of
-- [Input Command Prefixes] to apply. All other entries are interpreted as
-- arguments.
--
-- Returns a result table on success (usually empty), or `def, error` on
-- error. `def` is the second parameter provided to the function, and is
-- nil if it's missing.
---@param def? any
function mp.command_native(table, def) end

-- Like `mp.command_native()`, but the command is ran asynchronously (as far
-- as possible), and upon completion, fn is called. fn has three arguments:
-- `fn(success, result, error)`:
--
--      `success`
--         Always a Boolean and is true if the command was successful,
--         otherwise false.

--     `result`
--         The result value (can be nil) in case of success, nil otherwise (as
--         returned by `mp.command_native()`).

--     `error`
--         The error string in case of an error, nil otherwise.
--
-- Returns a table with undefined contents, which can be used as argument for
-- `mp.abort_async_command`.
--
-- If starting the command failed for some reason, `nil, error` is returned,
-- and `fn` is called indicating failure, using the same error value.
--
-- `fn` is always called asynchronously, even if the command failed to start.
---@param fn? any
function mp.command_native_async(table, fn) end

-- Abort a `mp.command_native_async` call. The argument is the return value
-- of that command (which starts asynchronous execution of the command).
-- Whether this works and how long it takes depends on the command and the
-- situation. The abort call itself is asynchronous. Does not return anything.
function mp.abort_async_command(t) end

-- Delete the given property. See `mp.get_property` and [Properties] for more
-- information about properties. Most properties cannot be deleted.
--
-- Returns true on success, or `nil, error` on error.
function mp.del_property(name) end

-- Return the value of the given property as string. These are the same
-- properties as used in input.conf. See [Properties] for a list of
-- properties. The returned string is formatted similar to `${=name}`
-- (see [Property Expansion]).
--
-- Returns the string on success, or `def, error` on error. `def` is the
-- second parameter provided to the function, and is nil if it's missing.
--- @param def? any
function mp.get_property(name, def) end

---@param def? any
function mp.get_property_osd(name, def) end
-- Similar to `mp.get_property`, but return the property value formatted for
-- OSD. This is the same string as printed with `${name}` when used in
-- input.conf.
--
-- Returns the string on success, or `def, error` on error. `def` is the
-- second parameter provided to the function, and is an empty string if it's
-- missing. Unlike `get_property()`, assigning the return value to a variable
-- will always result in a string.

-- Similar to `mp.get_property`, but return the property value as Boolean.
--
-- Returns a Boolean on success, or `def, error` on error.
---@param def? any
function mp.get_property_bool(name, def) end

-- Similar to `mp.get_property`, but return the property value as number.
--
-- Note that while Lua does not distinguish between integers and floats,
-- mpv internals do. This function simply request a double float from mpv,
-- and mpv will usually convert integer property values to float.
--
-- Returns a number on success, or `def, error` on error.
---@param def? any
function mp.get_property_number(name, def) end

-- Similar to `mp.get_property`, but return the property value using the best
-- Lua type for the property. Most time, this will return a string, Boolean,
-- or number. Some properties (for example `chapter-list`) are returned as
-- tables.
--
-- Returns a value on success, or `def, error` on error. Note that `nil`
-- might be a possible, valid value too in some corner cases.
---@param def? any
function mp.get_property_native(name, def) end

-- Set the given property to the given string value. See `mp.get_property`
-- and [Properties] for more information about properties.
--
-- Returns true on success, or `nil, error` on error.
function mp.set_property(name, value) end

-- Similar to `mp.set_property`, but set the given property to the given
-- Boolean value.
function mp.set_property_bool(name, value) end

-- Similar to `mp.set_property`, but set the given property to the given
-- numeric value.
--
-- Note that while Lua does not distinguish between integers and floats,
-- mpv internals do. This function will test whether the number can be
-- represented as integer, and if so, it will pass an integer value to mpv,
-- otherwise a double float.
function mp.set_property_number(name, value) end

-- Similar to `mp.set_property`, but set the given property using its native
-- type.
--
-- Since there are several data types which cannot represented natively in
-- Lua, this might not always work as expected. For example, while the Lua
-- wrapper can do some guesswork to decide whether a Lua table is an array
-- or a map, this would fail with empty tables. Also, there are not many
-- properties for which it makes sense to use this, instead of
-- `set_property`, `set_property_bool`, `set_property_number`.
-- For these reasons, this function should probably be avoided for now, except
-- for properties that use tables natively.
function mp.set_property_native(name, value) end

-- Return the current mpv internal time in seconds as a number. This is
-- basically the system time, with an arbitrary offset.
function mp.get_time() end

-- Register callback to be run on a key binding. The binding will be mapped to
-- the given `key`, which is a string describing the physical key. This uses
-- the same key names as in input.conf, and also allows combinations
-- (e.g. `ctrl+a`). If the key is empty or `nil`, no physical key is
-- registered, but the user still can create own bindings (see below).
--
-- After calling this function, key presses will cause the function `fn` to
-- be called (unless the user remapped the key with another binding).
--
-- The `name` argument should be a short symbolic string. It allows the user
-- to remap the key binding via input.conf using the `script-message`
-- command, and the name of the key binding (see below for
-- an example). The name should be unique across other bindings in the same
-- script - if not, the previous binding with the same name will be
-- overwritten. You can omit the name, in which case a random name is generated
-- internally. (Omitting works as follows: either pass `nil` for `name`,
-- or pass the `fn` argument in place of the name. The latter is not
-- recommended and is handled for compatibility only.)
--
-- The last argument is used for optional flags. This is a table, which can
-- have the following entries:
--
--     `repeatable`
--         If set to `true`, enables key repeat for this specific binding.
--         This option only makes sense when `complex` is not set to `true`.
--
--     `complex`
--         If set to `true`, then `fn` is called on key down, repeat and up
--         events, with the first argument being a table. This table has the
--         following entries (and may contain undocumented ones):
--
--             `event`
--                 Set to one of the strings `down`, `repeat`, `up` or
--                 `press` (the latter if key up/down/repeat can't be
--                 tracked).
--
--             `is_mouse`
--                 Boolean Whether the event was caused by a mouse button.
--
--             `key_name`
--                 The name of they key that triggered this, or `nil` if
--                 invoked artificially. If the key name is unknown, it's an
--                 empty string.
--
--             `key_text`
--                 Text if triggered by a text key, otherwise `nil`. See
--                 description of `script-binding` command for details (this
--                 field is equivalent to the 5th argument).
--
-- Internally, key bindings are dispatched via the `script-message-to` or
-- `script-binding` input commands and `mp.register_script_message`.
--
-- Trying to map multiple commands to a key will essentially prefer a random
-- binding, while the other bindings are not called. It is guaranteed that
-- user defined bindings in the central input.conf are preferred over bindings
-- added with this function (but see `mp.add_forced_key_binding`).
--
-- Example:
--
-- ```lua
--     function something_handler()
--         print("the key was pressed")
--     end
--     mp.add_key_binding("x", "something", something_handler)
-- ```
--
-- This will print the message `the key was pressed` when `x` was pressed.
--
-- The user can remap these key bindings. Then the user has to put the
-- following into their input.conf to remap the command to the `y` key:
--
-- ```lua
--     y script-binding something
-- ```
--
-- This will print the message when the key `y` is pressed. (`x` will
-- still work, unless the user remaps it.)
--
-- You can also explicitly send a message to a named script only. Assume the
-- above script was using the filename `fooscript.lua`:
--
-- ```lua
--     y script-binding fooscript/something
-- ```
---@param name string | function
---@param fn? any
---@param flags? any
function mp.add_key_binding(key, name, fn, flags) end

-- This works almost the same as `mp.add_key_binding`, but registers the
-- key binding in a way that will overwrite the user's custom bindings in their
-- input.conf. (`mp.add_key_binding` overwrites default key bindings only,
-- but not those by the user's input.conf.)
function mp.add_forced_key_binding(...) end

-- Remove a key binding added with `mp.add_key_binding` or
-- `mp.add_forced_key_binding`. Use the same name as you used when adding
-- the bindings. It's not possible to remove bindings for which you omitted
-- the name.
function mp.remove_key_binding(name) end

-- Call a specific function when an event happens. The event name is a string,
-- and the function fn is a Lua function value.
--
-- Some events have associated data. This is put into a Lua table and passed
-- as argument to fn. The Lua table by default contains a `name` field,
-- which is a string containing the event name. If the event has an error
-- associated, the `error` field is set to a string describing the error,
-- on success it's not set.
--
-- If multiple functions are registered for the same event, they are run in
-- registration order, which the first registered function running before all
-- the other ones.
--
-- Returns true if such an event exists, false otherwise.
--
-- See [Events] and [List of events] for details.
function mp.register_event(name, fn) end

-- Undo `mp.register_event(..., fn)`. This removes all event handlers that
-- are equal to the `fn` parameter. This uses normal Lua `==` comparison,
-- so be careful when dealing with closures.
function mp.unregister_event(fn) end

-- Watch a property for changes. If the property `name` is changed, then
-- the function `fn(name)` will be called. `type` can be `nil`, or be
-- set to one of `none`, `native`, `bool`, `string`, or `number`.
-- `none` is the same as `nil`. For all other values, the new value of
-- the property will be passed as second argument to `fn`, using
-- `mp.get_property_<type>` to retrieve it. This means if `type` is for
-- example `string`, `fn` is roughly called as in
-- `fn(name, mp.get_property_string(name))`.
--
-- If possible, change events are coalesced. If a property is changed a bunch
-- of times in a row, only the last change triggers the change function. (The
-- exact behavior depends on timing and other things.)
--
-- If a property is unavailable, or on error, the value argument to `fn` is
-- `nil`. (The `observe_property()` call always succeeds, even if a
-- property does not exist.)
--
-- In some cases the function is not called even if the property changes.
-- This depends on the property, and it's a valid feature request to ask for
-- better update handling of a specific property.
--
-- If the `type` is `none` or `nil`, the change function `fn` will be
-- called sporadically even if the property doesn't actually change. You should
-- therefore avoid using these types.
--
-- You always get an initial change notification. This is meant to initialize
-- the user's state to the current value of the property.
function mp.observe_property(name, type, fn) end

-- Undo `mp.observe_property(..., fn)`. This removes all property handlers
-- that are equal to the `fn` parameter. This uses normal Lua `==`
-- comparison, so be careful when dealing with closures.
function mp.unobserve_property(fn) end

-- Call the given function fn when the given number of seconds has elapsed.
-- Note that the number of seconds can be fractional. For now, the timer's
-- resolution may be as low as 50 ms, although this will be improved in the
-- future.
--
-- If the `disabled` argument is set to `true` or a truthy value, the
-- timer will wait to be manually started with a call to its `resume()`
-- method.
--
-- This is a one-shot timer: it will be removed when it's fired.
--
-- Returns a timer object. See `mp.add_periodic_timer` for details.
---@param disabled? any
function mp.add_timeout(seconds, fn, disabled) end

-- Call the given function periodically. This is like `mp.add_timeout`, but
-- the timer is re-added after the function fn is run.
--
-- Returns a timer object. The timer object provides the following methods:
--     `stop()`
--         Disable the timer. Does nothing if the timer is already disabled.
--         This will remember the current elapsed time when stopping, so that
--         `resume()` essentially unpauses the timer.
--
--     `kill()`
--         Disable the timer. Resets the elapsed time. `resume()` will
--         restart the timer.
--
--     `resume()`
--         Restart the timer. If the timer was disabled with `stop()`, this
--         will resume at the time it was stopped. If the timer was disabled
--         with `kill()`, or if it's a previously fired one-shot timer (added
--         with `add_timeout()`), this starts the timer from the beginning,
--         using the initially configured timeout.
--
--     `is_enabled()`
--         Whether the timer is currently enabled or was previously disabled
--         (e.g. by `stop()` or `kill()`).
--
--     `timeout` (RW)
--         This field contains the current timeout period. This value is not
--         updated as time progresses. It's only used to calculate when the
--         timer should fire next when the timer expires.
--
--         If you write this, you can call `t:kill() ; t:resume()` to reset
--         the current timeout to the new one. (`t:stop()` won't use the
--         new timeout.)
--
--     `oneshot` (RW)
--         Whether the timer is periodic (`false`) or fires just once
--         (`true`). This value is used when the timer expires (but before
--         the timer callback function fn is run).
--
-- Note that these are methods, and you have to call them using `:` instead
-- of `.` (Refer to https://www.lua.org/manual/5.2/manual.html#3.4.9 .)
--
-- Example:
--
-- ```lua
--     seconds = 0
--     timer = mp.add_periodic_timer(1, function()
--         print("called every second")
--         # stop it after 10 seconds
--         seconds = seconds + 1
--         if seconds >= 10 then
--             timer:kill()
--         end
--     end)
-- ```
---@param disabled? any
function mp.add_periodic_timer(seconds, fn, disabled) end

-- Return a setting from the `--script-opts` option. It's up to the user and
-- the script how this mechanism is used. Currently, all scripts can access
-- this equally, so you should be careful about collisions.
function mp.get_opt(key) end

-- Return the name of the current script. The name is usually made of the
-- filename of the script, with directory and file extension removed. If
-- there are several scripts which would have the same name, it's made unique
-- by appending a number. Any nonalphanumeric characters are replaced with `_`.
--
-- .. admonition:: Example
--
--     The script `/path/to/foo-script.lua` becomes `foo_script`.
function mp.get_script_name() end

-- Return the directory if this is a script packaged as directory (see
-- [Script location] for a description). Return nothing if this is a single
-- file script.
function mp.get_script_directory() end

-- Show an OSD message on the screen. `duration` is in seconds, and is
-- optional (uses `--osd-duration` by default).
---@param duration? any
function mp.osd_message(text, duration) end

-- # Advanced mp functions
-- These also live in the `mp` module, but are documented separately as they
-- are useful only in special situations.

-- Calls `mpv_get_wakeup_pipe()` and returns the read end of the wakeup
-- pipe. This is deprecated, but still works. (See `client.h` for details.)
function mp.get_wakeup_pipe() end

function mp.get_next_timeout() end
-- Return the relative time in seconds when the next timer (`mp.add_timeout`
-- and similar) expires. If there is no timer, return `nil`.

-- This can be used to run custom event loops. If you want to have direct
-- control what the Lua script does (instead of being called by the default
-- event loop), you can set the global variable `mp_event_loop` to your
-- own function running the event loop. From your event loop, you should call
-- `mp.dispatch_events()` to dequeue and dispatch mpv events.
--
-- If the `allow_wait` parameter is set to `true`, the function will block
-- until the next event is received or the next timer expires. Otherwise (and
-- this is the default behavior), it returns as soon as the event loop is
-- emptied. It's strongly recommended to use `mp.get_next_timeout()` and
-- `mp.get_wakeup_pipe()` if you're interested in properly working
-- notification of new events and working timers.
---@param allow_wait? any
function mp.dispatch_events(allow_wait) end

-- Register an event loop idle handler. Idle handlers are called before the
-- script goes to sleep after handling all new events. This can be used for
-- example to delay processing of property change events: if you're observing
-- multiple properties at once, you might not want to act on each property
-- change, but only when all change notifications have been received.
function mp.register_idle(fn) end

-- Undo `mp.register_idle(fn)`. This removes all idle handlers that
-- are equal to the `fn` parameter. This uses normal Lua `==` comparison,
-- so be careful when dealing with closures.
function mp.unregister_idle(fn) end

-- Set the minimum log level of which mpv message output to receive. These
-- messages are normally printed to the terminal. By calling this function,
-- you can set the minimum log level of messages which should be received with
-- the `log-message` event. See the description of this event for details.
-- The level is a string, see `msg.log` for allowed log levels.
function mp.enable_messages(level) end

-- This is a helper to dispatch `script-message` or `script-message-to`
-- invocations to Lua functions. `fn` is called if `script-message` or
-- `script-message-to` (with this script as destination) is run
-- with `name` as first parameter. The other parameters are passed to `fn`.
-- If a message with the given name is already registered, it's overwritten.
--
-- Used by `mp.add_key_binding`, so be careful about name collisions.
function mp.register_script_message(name, fn) end

-- Undo a previous registration with `mp.register_script_message`. Does
-- nothing if the `name` wasn't registered.
function mp.unregister_script_message(name) end

-- Create an OSD overlay. This is a very thin wrapper around the `osd-overlay`
-- command. The function returns a table, which mostly contains fields that
-- will be passed to `osd-overlay`. The `format` parameter is used to
-- initialize the `format` field. The `data` field contains the text to
-- be used as overlay. For details, see the `osd-overlay` command.
--
-- In addition, it provides the following methods:
--
-- `update()`
--     Commit the OSD overlay to the screen, or in other words, run the
--     `osd-overlay` command with the current fields of the overlay table.
--     Returns the result of the `osd-overlay` command itself.
--
-- `remove()`
--     Remove the overlay from the screen. A `update()` call will add it
--     again.
--
-- Example:
--
-- ```lua
--     ov = mp.create_osd_overlay("ass-events")
--     ov.data = "{\\an5}{\\b1}hello world!"
--     ov:update()
-- ```
--
-- The advantage of using this wrapper (as opposed to running `osd-overlay`
-- directly) is that the `id` field is allocated automatically.
function mp.create_osd_overlay(format) end

-- Returns a tuple of `osd_width, osd_height, osd_par`. The first two give
-- the size of the OSD in pixels (for video outputs like `--vo=xv`, this may
-- be "scaled" pixels). The third is the display pixel aspect ratio.
--
-- May return invalid/nonsense values if OSD is not initialized yet.
function mp.get_osd_size() end

-- # Extras
-- This documents experimental features, or features that are "too special" to
-- guarantee a stable interface.

-- Add a hook callback for `type` (a string identifying a certain kind of
-- hook). These hooks allow the player to call script functions and wait for
-- their result (normally, the Lua scripting interface is asynchronous from
-- the point of view of the player core). `priority` is an arbitrary integer
-- that allows ordering among hooks of the same kind. Using the value 50 is
-- recommended as neutral default value.
--
-- `fn(hook)` is the function that will be called during execution of the
-- hook. The parameter passed to it (`hook`) is a Lua object that can control
-- further aspects about the currently invoked hook. It provides the following
-- methods:
--
--     `defer()`
--         Returning from the hook function should not automatically continue
--         the hook. Instead, the API user wants to call `hook:cont()` on its
--         own at a later point in time (before or after the function has
--         returned).
--
--     `cont()`
--         Continue the hook. Doesn't need to be called unless `defer()` was
--         called.
--
-- See [Hooks] for currently existing hooks and what they do - only the hook
-- list is interesting; handling hook execution is done by the Lua script
-- function automatically.
function mp.add_hook(type, priority, fn) end

return mp
