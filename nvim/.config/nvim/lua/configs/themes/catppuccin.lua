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

