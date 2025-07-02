return {
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup({
        vim.keymap.set('n', '<leader>tj', ':TSJToggle <CR>', {})
        })
    end,
  },
  {
    'dstein64/nvim-scrollview',
    event = 'BufWinEnter', -- Load when entering a buffer/window
    config = function()
      require('scrollview').setup({
          -- Optional: You can configure colors and behavior here
          -- e.g., 'fg' for foreground color, 'bg' for background
          -- Or enable different styles
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "v1.6.1", -- Make sure to update this to something recent!
    opts = {
      -- options
    },
    config = function ()
      require("telescope").load_extension("fidget")
    end
  }
}
