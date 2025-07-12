return {
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua", "python", "json", "javascript", "c_sharp" }, -- Add other languages you need
        highlight = { enable = true },
        indent = { enable = true },
        folds = {enabled = true, }
      }
    end,
  },
  {
    "elkowar/yuck.vim"
  }
}
