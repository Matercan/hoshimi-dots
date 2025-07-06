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
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      local open_with_trouble = require("trouble.sources.telescope").open

      -- Global Telescope setup
      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<C-t>"] = open_with_trouble },
            n = { ["<C-t>"] = open_with_trouble },
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
          cmdline = {
            -- Adjust telescope picker size and layout
            picker = {
              layout_config = {
                width  = 120,
                height = 25,
              }
            },
            -- Adjust your mappings 
            mappings    = {
              complete      = '<Tab>',
              run_selection = '<C-CR>',
              run_input     = '<CR>',
            },
            -- Triggers any shell command using overseer.nvim (`:!`)
            overseer    = {
              enabled = true,
            },
          },
        },
      })

      telescope.load_extension('ui-select')
      telescope.load_extension('cmdline')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })

      vim.api.nvim_set_keymap('n', 'Q', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
     vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
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
