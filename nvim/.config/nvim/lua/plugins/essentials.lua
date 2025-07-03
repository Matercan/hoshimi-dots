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
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    'rcarriga/nvim-notify',
    event = "VeryLazy",
    config = function()
      require('notify').setup({
        -- You can add your configuration options here
        -- These are some common ones to get started:

        background_color = "#000000", -- Example: Set a black background for notifications
        timeout = 5000,               -- Notifications disappear after 5 seconds (5000ms)
        top_padding = 0,              -- No padding at the top of the screen
        stages = "fade_in_slide_out", -- Animation style
        max_height = function() return math.floor(vim.opt.columns:get() * 0.75) end, -- Max height based on screen size
        max_width = function() return math.floor(vim.opt.lines:get() * 0.75) end,   -- Max width based on screen size

        -- Render function for custom appearance (optional, this is the default basic one)
        -- render = "default",
      })
    end,
  }
}
