vim.lsp.enable("gopls")

vim.dap.adapters.delve = function(callback, config)
  if config.mode == 'remote' and config.request == 'attach' then
    callback({
      type = 'server',
      host = config.host or '127.0.0.1',
      port = config.port or '38697'
    })
  else
    callback({
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
        detached = vim.fn.has("win32") == 0,
      }
    })
  end
end


-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
vim.dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    request = "attach",
    name = "go attach to the process",
    processId = vim.dap.utils.pick_process,
  },
}
