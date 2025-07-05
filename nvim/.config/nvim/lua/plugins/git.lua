return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional 
    },
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin will only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
        -- your configuration comes here
        -- for example
        enabled = true,  -- if you want to enable the plugin
        message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
        date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
        virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  {
    'akinsho/nvim-bufferline.lua',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function ()

      -- Keybinds (These are fine where they are, they are global keymaps)
      vim.keymap.set('n', '<leader>gt', ':tabnext<CR>', { desc = 'Go to next tab' })
      vim.keymap.set('n', '<leader>gT', ':tabprevious<CR>', { desc = 'Go to previous tab' })
      vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Create new tab' })
      vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close current tab' })

      vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', { silent = true })
      vim.keymap.set('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', { silent = true })
      vim.keymap.set('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', { silent = true })
      vim.keymap.set('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', { silent = true })
      vim.keymap.set('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', { silent = true })
      vim.keymap.set('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>', { silent = true })
      vim.keymap.set('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>', { silent = true })
      vim.keymap.set('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>', { silent = true })
      vim.keymap.set('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>', { silent = true })
      vim.keymap.set('n', '<leader>$', '<Cmd>BufferLineGoToBuffer -1<CR>', { silent = true })

      -- Styling
      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          -- Styling and display
          mode = "tabs", -- or "buffers"
          themable = true,
          separator_style = "solid", -- "slant", "padded_slant", "solid", "thin"
          show_buffer_close_icon = false,
          show_close_icon = false,
          show_tab_indicators = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
          indicator = {
            icon = '▎',
            style = 'icon', -- CORRECT: Choose one value, e.g., 'icon'
          },
          buffer_close_icon = '󰅖',
          modified_icon = '● ',
          close_icon = ' ',
          left_trunc_marker = ' ',
          right_trunc_marker = ' ',
          name_formatter = function(buf)
              -- You need to return a string here, otherwise it will be nil
              return buf.name or "" -- Example: Return buffer name
          end,
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          truncate_names = true, -- whether or not tab names should be truncated
          tab_size = 18,
          diagnostics = "nvim_lsp", -- This enables diagnostics from LSP. Keep it simple first.
          diagnostics_update_in_insert = false, -- only applies to coc
          diagnostics_update_on_event = true, -- use nvim's diagnostic handler

          -- Diagnostics 
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            -- This function needs to return a string, not perform a check with if context.buffer:current() then
            -- The context.buffer:current() check is likely for more advanced logic or specific diagnostic sources.
            -- For a basic indicator, just return based on count or level.
            if count > 0 then
              return ' (' .. count .. ') ' -- Example: returns (X) for diagnostics
            end
            return '' -- Return empty string if no diagnostics
          end,
        }, -- <-- End of options table.

        -- Custom highlights
        highlights = {
        } -- <-- End of highlights table

      } -- <-- End of bufferline.setup call.

  end -- <-- End of config function.
  }
}
