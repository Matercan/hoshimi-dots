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
