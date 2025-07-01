-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  -- Main Telescope plugin definition
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x", -- Make sure you specify the branch if you are on 0.1.x
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Make sure trouble.nvim is a dependency if you're using it this way
      { "folke/trouble.nvim", opts = {} }, -- Ensure trouble is also defined as a plugin
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      -- REMOVE THIS LINE: require("plugins")

      local open_with_trouble = require("trouble.sources.telescope").open
      local add_to_trouble = require("trouble.sources.telescope").add

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
        },
      })

      telescope.load_extension('ui-select')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
    end,
  },

  -- The telescope-ui-select.nvim plugin itself. Lazy.nvim manages its installation.
  -- Its configuration is handled within the main telescope.nvim config block above.
  {
    'nvim-telescope/telescope-ui-select.nvim',
    -- No 'config' key needed here since its setup is part of the main Telescope setup.
    -- If you had specific build steps for ui-select, they would go here.
  },

  -- Add any other Telescope-related plugins here if you have them, e.g.:
  -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- { 'nvim-telescope/telescope-file-browser.nvim' },
}
