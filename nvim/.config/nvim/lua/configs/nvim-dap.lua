-- This file will contain your nvim-dap configuration
local dap = require("dap")

-- Example configuration (you'll need to add your specific DAP clients here)
-- For C#, you'll need a debug adapter like netcoredbg or OmniSharp's debugger.
-- Assuming you have netcoredbg installed and its path is available
dap.adapters.coreclr = {
  type = 'executable',
  command = '/path/to/netcoredbg/netcoredbg', -- Replace with your actual path
  args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to .NET executable: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/', 'file')
    end,
    args = {},
    cwd = function()
      return vim.fn.input('Working directory: ', vim.fn.getcwd(), 'file')
    end,
    console = 'integratedTerminal',
  },
}

-- More configurations, keybindings etc.
-- For example:
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Dap Continue' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Dap Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Dap Step Into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Dap Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Dap Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = 'Dap Logpoint' })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Dap REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Dap Run Last' })
