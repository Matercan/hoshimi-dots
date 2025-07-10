-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  -- Main Telescope plugin definition
  {
    "nvim-telescope/telescope.nvim",
    -- CHANGE THIS LINE:
    -- Instead of branch = "0.1.x", use a specific tag or the master branch
    tag = "0.1.5", -- <--- RECOMMENDED: Use the latest stable tag (as of this knowledge cut-off)
    -- OR, if 0.1.5 still gives issues (less likely), use the master branch for bleeding edge:
    -- branch = "master",

    dependencies = {
      "nvim-lua/plenary.nvim",
      { "folke/trouble.nvim", opts = {} },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("configs.telescope")
    end,
  },

  -- The telescope-ui-select.nvim plugin itself. Lazy.nvim manages its installation.
  -- Its configuration is handled within the main telescope.nvim config block above.
  {
    'nvim-telescope/telescope-ui-select.nvim',
    -- No 'config' key needed here since its setup is part of the main Telescope setup.
    -- If you had specific build steps for ui-select, they would go here.
  },
  {
    'jonarrien/telescope-cmdline.nvim'
  },
  -- Install and configure dressing.nvim
  {
    'stevearc/dressing.nvim',
    event = "VeryLazy", -- Load it lazily
    config = function()
      require('dressing').setup({
        input = {
          -- Set the backend for command-line inputs
          -- 'telescope' is the key here to make it look like Telescope
          backend = { 'telescope', 'builtin' }, -- Try telescope first, then builtin if unavailable
          -- You can customize Telescope-specific options for inputs here if needed
          -- telescope = {
          --   -- layout_strategy = 'vertical',
          --   -- layout_config = { width = 0.5, height = 0.4 },
          -- },
        },
        -- You can configure other prompt types here as well (select, confirm)
      })
    end,
  }
}
