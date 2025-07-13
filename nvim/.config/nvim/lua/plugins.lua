return {
  {
    "elkowar/yuck.vim",
  },
  {
    "nvim-tree/nvim-web-devicons",
    priority = 100
  },
  {
    "echasnovski/mini.pairs",
  },
  {
    "pseewald/vim-anyfold",
    config = function()
      vim.keymap.set('n', '<leader>vf', '<CMD>AnyFoldActivate <CR>', { silent = true, desc = 'enables folding ' })
    end
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    config = function()
      require("easy-dotnet").setup()
    end
  },
  {
    "rachartier/tiny-glimmer.nvim"
  }
}
