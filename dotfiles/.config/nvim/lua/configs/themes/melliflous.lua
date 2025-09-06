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
