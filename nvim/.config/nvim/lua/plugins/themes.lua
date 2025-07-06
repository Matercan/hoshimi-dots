-- nvim/lua/plugins/themes.lua
return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        -- add the config here
        themes = {"catppuccin", "gruvbox", "kanagawa"}, -- Put in your themes here
        -- Your themes will default to the theme during your last instance of neovim
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
          }
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
      -- vim.api.nvim_set_hl(0, "MsgArea", { bg = "#1a1aa" })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 999,
    config = function ()
      require('kanagawa').setup({
        compile = false,             -- enable compiling the colorscheme
        undercurl = true,            -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,         -- do not set background color
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
            dark = "dragon",           -- try "dragon" !
            light = "lotus"
        },
      })
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 998,
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
  }
}
