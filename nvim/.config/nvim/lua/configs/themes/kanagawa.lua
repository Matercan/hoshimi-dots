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
