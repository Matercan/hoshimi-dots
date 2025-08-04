local cyberdream = require("cyberdream")
cyberdream.setup({
  variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
  transparent = true,
  saturation = 1,      -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
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
      Comment = { fg = colors.teal, italic = true },
      ["@property"] = { fg = colors.blue },
      keyword = { fg = colors.orange, italic = true },
      ["@string"] = { fg = colors.green, italic = true },
    }
  end,

  -- Override colors
  colors = {
    -- For a list of colors see `lua/cyberdream/colours.lua`

    -- Override colors for both light and dark variants
    bg = "#0b1e2d",
    yellow = "#f3f396",
    blue = "#9eccfa",
    red = "#fa9eb1",
    orange = "#f7daa1",
    magenta = "#c19efa",
    green = "#9efac4",
    teal = "#a2fa9e",

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
