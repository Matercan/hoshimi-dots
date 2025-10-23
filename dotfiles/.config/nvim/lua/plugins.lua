return {
  {
    "nvim-tree/nvim-web-devicons",
    priority = 100
  },
  {
    "echasnovski/mini.pairs",
    config = function()
      require('mini.pairs').setup({
        modes = { insert = true, command = false, terminal = false },
        mappings = {
          ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
          ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
          ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

          [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
          [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
          ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

          ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
          ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
          ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
      })
    end
  },
  {
    "rachartier/tiny-glimmer.nvim"
  },
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    cmd = 'Nerdy',
    opts = {
      max_recents = 30,               -- Configure recent icons limit
      add_default_keybindings = true, -- Add default keybindings
      copy_to_clipboard = false,      -- Copy glyph to clipboard instead of inserting
    }
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
    },
  },
  {
    'nanotee/zoxide.vim'
  },
  {
    'wakatime/vim-wakatime'
  }
}
