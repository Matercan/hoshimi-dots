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
      require("catppuccin").setup({
        -- You can still choose a flavor, but we'll override the background
        flavour = "macchiato",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        term_colors = true,
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        integrations = {
          cmp = true,
          nvimtree = true,
          telescope = {
            enabled = true,
          },
          indent_blankline = {
            enabled = true,
          },
          gitsigns = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            Comment = { fg = "#6c7086" },
            ["@variable"] = { fg = "#cad3f5" },
          },
        },
        highlight_overrides = {
          all = {
            -- Normal = { bg = "#1A1826CC" }, -- Example: A dark background with 80% opacity
          }
        }
      })
      vim.cmd.colorscheme("catppuccin")

      -- *** Set your custom background color here ***
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1a1a" })

      -- If you want to change the background for the status line and command line too
       -- vim.api.nvim_set_hl(0, "End Of Buffer", { bg = "#1a1a1a" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1a1a" })

      -- you might need to adjust those too or configure lualine's theme to match.
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1a1a1a" })
      vim.api.nvim_set_hl(0, "CmdLine", { bg = "#1a1a1a" })
      vim.api.nvim_set_hl(0, "MsgArea", { bg = "#1a1a1a" })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 998,
    config = function ()
      require('kanagawa').setup({
        compile = false,             -- enable compiling the colorscheme
        undercurl = true,            -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,         -- do not set a background color 
        dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
        terminalColors = true,       -- define vim.g.terminal_color_{0,17}
        colors = {                   -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify colors
          local theme = colors.theme
          local makeDiagnosticColor = function (color)
            local c = require("kanagawa.lib.color")
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end

          return {
          -- Assign a static color to strings
          String = { fg = colors.palette.carpYellow, italic = true },
          -- theme colors will update dynamically when you change theme!
          SomePluginHl = { fg = colors.theme.syn.type, bold = true },

          -- Telescope colors
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          -- Uniform pop up menu colors
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          -- Diganostics style from tokyonight.nvim
          DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
          }
        end,

        theme = "wave",              -- Load "wave" theme
        background = {               -- map the value of 'background' option to a theme
            dark = "wave",           -- try "dragon" !
            light = "lotus"
        },
      })
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 997,
    config = function ()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
          keywords = true
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {
          -- Put in your custom colors here
        },
        overrides = {
          -- Change which attributes have different colors 
        },
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("colorscheme gruvbox")
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
      local cyberdream = require("cyberdream")
      cyberdream.setup({
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        transparent = true,
        saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
        italic_comments = true,
        hide_fillchars = false,
        borderless_pickers = false,
        terminal_colors = true,
        cache = false,
        -- Override highlight groups with your own colour values
        highlights = {
          -- Highlight groups to override, adding new groups is also possible
          -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

          -- Example:
          -- Comment = { fg = "#696969", bg = "NONE", italic = true },

          -- More examples can be found in `lua/cyberdream/extensions/*.lua`
        },

        -- Override a highlight group entirely using the built-in colour palette
        overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
          -- Example:
          return {
            Comment = { fg=colors.teal, italic = true },
            ["@property"] = { fg = colors.blue},
            keyword = {fg = colors.orange, italic = true },
            ["@string"] = {fg = colors.green, italic = true },
          }
        end,

        -- Override colors
        colors = {
          -- For a list of colors see `lua/cyberdream/colours.lua`

          -- Override colors for both light and dark variants
          bg = "#3b4154",
          teal = "#257b4b",
          orange = "#ff891a",
          blue = "#91d1ff",
          red = "#ea1e1e",
          green = "#257b76",

          -- If you want to override colors for light or dark variants only, use the following format:
          dark = {
            -- magenta = "#ff00ff",
            -- fg = "#eeeeee",
          },
          light = {
            -- red = "#ff5c57",
            -- cyan = "#5ef1ff",
          },
        },

      })
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
      local mellifluous = require("mellifluous")

      mellifluous.setup({
        color_over_rides = {
          dark = {
            colors = function (colors)
              return {
                bg = "#3b4154",
                teal = "#257b4b",
                orange = "#ff891a",
                blue = "#91d1ff",
                red = "#ea1e1e",
                green = "#257b76",
              }
            end,
          }
        }
      })

      vim.cmd("colorscheme mellifluous")
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
      local citruszest = require("citruszest")

      citruszest.setup({
        option = {
          transparent = false,
          bold = false,
          italic = true,
        },

        style = {
          Constant = { fg = "#FFFFFF", bold = true },
          Comment = { italic = true },
          keyword = { italic = true },
          ["@string"] = { italic = true },
        },
      })

      vim.cmd("colorscheme citruszest")
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

