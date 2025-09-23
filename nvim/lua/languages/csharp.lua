vim.dap.adapters.coreclr = {
  type = "executable",
  command = vim.get_mason_bin("netcoredbg"),
  args = { "--interpreter=vscode" }
}

vim.dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    console = "true",
    program = function()
      return vim.pick_file('find ./bin/Debug -type f -name "*.dll"')
    end,
  },
  -- https://github.com/Samsung/netcoredbg/issues/188
  -- https://github.com/Dynge/xunit-debugging-test
  -- need to use `VSTEST_HOST_DEBUG=1 dotnet test` and then attach to this process
  -- https://github.com/dotnet/sdk/issues/4994
  -- Fuck microsoft though, csharp is utter garbage and its semi proprietary ecosystem
  {
    type = "coreclr",
    name = "Attach",
    request = "attach",
    processId = vim.dap.utils.pick_process,
    console = "integratedTerminal",
  },
  {
    type = "coreclr",
    name = "Run tests",
    request = "attach",
    processId = function()
      local running = coroutine.running()
      local dm = require("debugmaster")
      local api = vim.api
      local buf = api.nvim_create_buf(true, true)
      api.nvim_buf_call(buf, function()
        local id = vim.fn.jobstart("VSTEST_HOST_DEBUG=1 dotnet test", {
          term = true,
          on_stdout = function(_, data, name)
            local out = table.concat(data, "\n")
            local pid = out:match("Process Id:%s*(%d+)")
            if pid and coroutine.status(running) == "suspended" then
              coroutine.resume(running, pid)
            end
          end
        })
      end)
      local pid = coroutine.yield()
      -- little hack because debugmaster can't attach if no active session yet
      -- TODO: this usecase must be tackled in debugmaster
      vim.schedule(function()
        local state = require("debugmaster.state")
        state.terminal:attach_terminal_to_current_session(buf)
        state.sidepanel:set_active(state.terminal)
      end)
      return pid
    end,
    console = "integratedTerminal",
  },
}

vim.lsp.config("roslyn_ls", {
  cmd = {
    "dotnet",
    "/home/miron/realhome/tools/roslyn/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel",              -- this property is required by the server
    "Information",
    "--extensionLogDirectory", -- this property is required by the server
    vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
    "--stdio",
  }
})
vim.lsp.enable("roslyn_ls")
