vim.lsp.enable("ts_ls")

vim.snippet.add("at", "/** @type {${1:Type}} */\n$0", { ft = "javascript" })
vim.snippet.add("ai", "/** @implements {${1:Interface}} */\n$0", { ft = "javascript" })
vim.snippet.add("ad", "/** @typedef {${0:Typename}} */\n$0", { ft = "javascript" })
vim.snippet.add("lg", 'console.log($1)', { ft = "javascript" })
vim.snippet.add("la", [[(${1:params}) => {
  ${2:body}
}
]], { ft = "javascript" })

vim.snippet.add("fu", [[
function ${2:funcName}($3) {
  $4
}
]], { ft = "javascript" })

vim.snippet.add("fo", [[
for (let ${2:value} of ${3:collection}) {
  $4
}
]], { ft = "javascript" })

vim.dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.get_mason_bin("js-debug-adapter"),
    args = {
      "${port}",
    },
  }
}
vim.dap.adapters["pwa-chrome"] = vim.dap.adapters["pwa-node"]

vim.dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    outputCapture = "std",
  },
  {
    type = "pwa-chrome",
    name = "Launch project debug in chrome",
    request = "launch",
    url = "http://localhost:8080",
    webRoot = "${workspaceFolder}"
  }
}

-- https://github.com/tapio/live-server
