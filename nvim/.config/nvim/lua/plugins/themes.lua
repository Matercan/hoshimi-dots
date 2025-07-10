-- nvim/lua/plugins/themes.lua
return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        -- add the config here
        themes = {
          -- Put in your themes here
          -- Make sure they are spelt correctly as they are written in the top definition)
          -- To make things use a curly font ( iScript ) make whatever you want to be curly italics
          "catppuccin", "gruvbox",
          "kanagawa", "tokyonight",
          "cyberdream", "night-owl",
          "mellifluous", "miasma",
          "moonlight", "citruszest",
          "aurora"
        },

        livePreview = true,
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- priority is which plugins load first, just in case one fails 
    config = function()
      require("configs.themes.catppuccin")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 998,
    config = function ()
      require('configs.themes.kanagawa')
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 997,
    config = function ()
      require("configs.themes.gruvbox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    opts = {},
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      require("configs.themes.cyberdream")
    end,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local nightOwl = require("night-owl")

      nightOwl.setup({
        italics = true,
        bold = true,
        underline = true,
        undercurl = true,
        transparent_background = false,
      })
      vim.cmd.colorscheme("night-owl")
    end,
  },
  {
    "ramojus/mellifluous.nvim",
    lazy = false,
    priority = 1000,

    config = function ()
      require("configs.themes.melliflous")
    end
  },
  {
    "xero/miasma.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme miasma")
    end,
  },
  {
    "shaunsingh/moonlight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      vim.cmd("colorscheme moonlight")
    end
  },
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      require("configs.themes.citruszest")
    end
  },
  {
    'ray-x/aurora',
    init = function()
      vim.g.aurora_italic = 1
      vim.g.aurora_transparent = 1
      vim.g.aurora_bold = 1
    end,
    config = function()
        vim.cmd.colorscheme "aurora"
        -- override defaults
        vim.api.nvim_set_hl(0, '@number', {fg='#e933e3'})
    end
  }
}

