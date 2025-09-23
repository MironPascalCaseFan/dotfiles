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
