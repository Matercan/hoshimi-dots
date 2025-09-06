-- This file will contain your nvim-dap configuration
local dap = require("dap")

local dotnet = require("configs.dap.nvim-dap-dotnet")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
-- local explicit_path = "$HOME/Documents/debuggers/netcoredbg/netcoredbg"


local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}


dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter    -- needed for unit test debugging


dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return dotnet.build_dll_path()
    end,
    args = {},
    cwd = function()
      return vim.fn.input('Working directory: ', vim.fn.getcwd(), 'file')
    end,
    console = 'integratedTerminal',
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

-- More configurations, keybindings etc.
-- For example:
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Dap Continue' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Dap Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Dap Step Into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Dap Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Dap Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  { desc = 'Dap Logpoint' })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Dap REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Dap Run Last' })
