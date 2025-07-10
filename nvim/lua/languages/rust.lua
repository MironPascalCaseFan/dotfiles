vim.lsp.enable("rust_analyzer")

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode

vim.dap.adapters.lldb = {
  type = "executable",
  command = "/home/linuxbrew/.linuxbrew/bin/lldb-dap", -- adjust as needed, must be absolute path
  name = "lldb"
}

-- https://github.com/llvm/llvm-project/blob/main/lldb/tools/lldb-dap/README.md
vim.dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = vim.dap.utils.pick_file,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = true,
    initCommands = function()
      -- Find out where to look for the pretty printer Python module.
      local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")
      assert(
        vim.v.shell_error == 0,
        "failed to get rust sysroot using `rustc --print sysroot`: "
        .. rustc_sysroot
      )
      local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
      local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
      return {
        ([[!command script import '%s']]):format(script_file),
        ([[!command source '%s']]):format(commands_file),
        "process handle SIGWINCH -p true -s false -n false"
      }
    end,
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = "lldb", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = "attach",
    pid = vim.dap.utils.pick_process,
    args = {},
  },
}
