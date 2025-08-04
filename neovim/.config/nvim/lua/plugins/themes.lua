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
          "aurora", "nightfox",
<<<<<<< HEAD
          "onedark", "papercolor", -- Doesn't work, ignore it
          "github-nvim-theme"
=======
          "onedark", "papercolor" -- Doesn't work, ignore it
>>>>>>> 5632dc3 (nvim has become neovim)
        },

        livePreview = true,
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 999,
    config = function()
      require("configs.themes.catppuccin")
      -- If 'catppuccin' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme catppuccin-mocha") -- Or your preferred variant
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 998,
    config = function()
      require('configs.themes.kanagawa')
      -- If 'kanagawa' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme kanagawa")
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 997,
    config = function()
      require("configs.themes.gruvbox")
      -- If 'gruvbox' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    opts = {},
    config = function()
      -- If 'tokyonight' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme tokyonight-night") -- Or your preferred variant
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("configs.themes.cyberdream")
      -- If 'cyberdream' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme cyberdream")
    end,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local nightOwl = require("night-owl")
      nightOwl.setup({
        italics = true,
        bold = true,
        underline = true,
        undercurl = true,
        transparent_background = false,
      })
      -- If 'night-owl' is in 'themery's loaders, REMOVE this:
      -- vim.cmd.colorscheme("night-owl")
    end,
  },
  {
    "ramojus/mellifluous.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("configs.themes.melliflous")
      -- If 'mellifluous' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme mellifluous")
    end
  },
  {
    "xero/miasma.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- If 'miasma' is in 'themery's loaders, REMOVE this:
      vim.cmd("colorscheme miasma")
    end,
  },
  {
    "shaunsingh/moonlight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- If 'moonlight' is in 'themery's loaders, REMOVE this:
      vim.cmd("colorscheme moonlight")
    end
  },
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("configs.themes.citruszest")
      -- If 'citruszest' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme citruszest")
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
      -- If 'aurora' is in 'themery's loaders, REMOVE this:
      vim.cmd.colorscheme "aurora"
      vim.api.nvim_set_hl(0, '@number', { fg = '#e933e3' })
    end
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("configs.themes.nightfox")
      -- If 'nightfox' is in 'themery's loaders, REMOVE this:
      -- vim.cmd("colorscheme nightfox")
    end
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priorty = 999,
    config = function()
      require("onedarkpro").setup({})
      vim.cmd("colorscheme onedark_dark")
    end
  },
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    priority = 999,
    config = function()
      vim.cmd("colorscheme") -- The actual colorscheme name is typically 'papercolor'
    end,
  },
<<<<<<< HEAD
  {
    'projekt0n/github-nvim-theme',
    config = function()
      require('github-theme').setup({

      })

      vim.cmd('colorscheme github_dark')
    end
  }
=======
>>>>>>> 5632dc3 (nvim has become neovim)
}
