return {
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "nvim-tree/nvim-web-devicons", -- Add this line
    config = function()
      require("nvim-web-devicons").setup({
        -- Your custom options here, if any
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("configs.completions")
    end,
  },
}
