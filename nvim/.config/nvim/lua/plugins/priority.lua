return {
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    -- The snacks loading screen will take priority over this if opening a folder or if lazy installs plugins

    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.startify")

      dashboard.section.header.val = {
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
      }

      alpha.setup(dashboard.opts)
    end,
  },
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua", "python", "json", "javascript" }, -- Add other languages you need
        highlight = { enable = true },
        indent = { enable = true },
        folds = {enabled = true, }
      }
    end,
  }
}
