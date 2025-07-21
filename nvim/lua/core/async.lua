-- @async anotation means callable function has path to coroutine.yield()

---cb must be called on done
---multiple result not supported, it will complicate things significantly
---in js Promise.all also don't support multiple result
---@alias Future async fun(cb: fun(result: any))


---@async
---@param future Future
---@return any Future Future result. No good generics support, hence any :(
local function await(future)
  local thread = assert(coroutine.running())
  local future_finished = false
  local future_result

  -- we need to handle two cases:
  -- 1. future callback will be executed right now
  -- 2. future callback will be executed later on event loop

  future(function(result)
    future_finished = true
    future_result = result
    if coroutine.status(thread) == "suspended" then
      coroutine.resume(thread)
    end
  end)

  -- Handles case 2
  if not future_finished then
    coroutine.yield()
  end

  return future_result
end

---@param futures Future[]
---@return Future
local function join(futures)
  return function(cb)
    local pending_count = #futures
    local results = {}
    for index, future in ipairs(futures) do
      future(function(result)
        results[index] = result
        pending_count = pending_count - 1
        if pending_count == 0 then
          cb(results)
        end
      end)
    end
  end
end

---@return Future
local function wait(ms)
  return function(cb)
    vim.defer_fn(cb, ms)
  end
end

coroutine.wrap(function()
  -- first example
  local future1 = await(wait(1000))
  local future2 = await(wait(1000))
  print("all futures done")

  --second example
  -- https://doc.rust-lang.org/book/ch17-02-concurrency-with-async.html
  local task1 = function(cb)
    for i = 1, 10 do
      print(string.format("hi number {%s} from the first task", i))
      await(wait(500))
    end
    cb()
  end

  local task2 = function(cb)
    for i = 1, 5 do
      print(string.format("hi number {%s} from the second task", i))
      await(wait(500))
    end
    cb()
  end
  await(join { task1, task2 })
  print("program finished")
  -- well, that kind of doesn't work as I thought XD :)
  -- need to figure out how to fix it. Each future in separate coroutine or what???
end)()
