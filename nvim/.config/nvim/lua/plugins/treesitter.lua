 return {
   'nvim-treesitter/nvim-treesitter', build = ":TSUpdate",
    
   config = function()
     require("nvim-treesitter.configs").setup {
       ensure_installed = { "lua", "python" }, -- Add other languages you need
       highlight = { enable = true },
       indent = { enable = true },
    }
  end,
}
