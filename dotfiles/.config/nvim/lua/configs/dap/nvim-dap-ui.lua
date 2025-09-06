-- This file will contain your nvim-dap-ui configuration
local dapui = require("dapui")

dapui.setup({
  -- Layout of the UI, windows, etc.
  layouts = {
    {
      elements = {
        -- Elements for the first layout
        { id = "scopes",      size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 40, -- Can be 'max' or a fixed number
      position = "right",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 0.25, -- Can be 'max' or a fixed number
      position = "bottom",
    },
  },
  controls = {
    element = "repl", -- Where to put the controls (e.g., "scopes", "watches", "stacks", "breakpoints", "repl", "console")
    enabled = true,
    icons = {
      -- ... customize icons ...
    },
  },
  floating = {
    max_height = nil, -- You can set these
    max_width = nil,
  },
  -- Customisation of highlight groups
  custom_hl = {
    -- ...
  },
  render = {
    max_value_length = nil, -- Optional max length for variable values
    max_table_rows = nil,   -- Optional max number of rows for tables
  },
})

-- Optional: Keybindings to toggle DAP UI
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Dap UI Toggle' })
vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'Dap UI Eval' })
vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'Dap UI Close' })
