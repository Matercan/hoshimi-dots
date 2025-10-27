---@diagnostic disable: undefined-doc-name
return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua", "python", "json", "javascript", "c_sharp", "cpp", "c" }, -- Add other languages you need
        highlight = { enable = true },
        indent = { enable = true },
        folds = { enabled = true, }
      }
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },

    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require('ufo')

      vim.keymap.set('n', 'zR', ufo.openAllFolds)
      vim.keymap.set('n', 'zM', ufo.closeAllFolds)

      ufo.setup({
        provider_selecter = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end,
  },
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>dp' },
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
    "folke/snacks.nvim",
    priority = 1000,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = require("configs.snacks.dashboard"),
      explorer = { enabled = false }, -- Already managed by neotree
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = false }, -- Already managed by telescope
      notifier = require("configs.snacks.notifier"),
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      animate = require("configs.snacks.animate"),
      image = { enabled = true },
    },
    keys = require("configs.snacks.keys"),
  },
}
