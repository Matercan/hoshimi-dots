-- Keybinds (These are fine where they are, they are global keymaps)
vim.keymap.set('n', '<leader>gt', ':BufferLineCycleNext<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<leader>gT', ':BufferlineCyclePrev<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', '<leader>tc', ':BufferLineCloseLeft<CR>', { desc = 'Closes the left tab' })

vim.keymap.set('n', '<leader>S', ':BufferLineSortByExtension<CR>',
  { desc = 'Sorts the buffers by extention and then alpha order' })

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
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true       -- use a "true" to enable the default, or set your own character
      }
    },                         -- Makes bufferline start to the right of neotree
    -- Styling and display
    mode = "buffers",          -- or "tabs"
    themable = true,
    separator_style = "slant", -- "slant", "padded_slant", "solid", "thin"
    show_buffer_close_icon = true,
    show_close_icon = true,
    show_tab_indicators = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' }
    },
    indicator = {
      icon = '▎',
      style = 'icon',
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
    max_prefix_length = 15,               -- prefix used when a buffer is de-duplicated
    truncate_names = true,                -- whether or not tab names should be truncated
    tab_size = 18,
    diagnostics = "nvim_lsp",             -- This enables diagnostics from LSP. Keep it simple first.
    diagnostics_update_in_insert = false, -- only applies to coc
    diagnostics_update_on_event = true,   -- use nvim's diagnostic handler

    -- Diagnostics
    diagnostics_indicator = function(count)
      -- This function needs to return a string, not perform a check with if context.buffer:current() then
      -- The context.buffer:current() check is likely for more advanced logic or specific diagnostic sources.
      -- For a basic indicator, just return based on count or level.
      if count > 0 then
        return ' (' .. count .. ') ' -- Example: returns (X) for diagnostics
      end
      return ''                      -- Return empty string if no diagnostics
    end,
  },                                 -- <-- End of options table.

  -- Custom highlights
  highlights = {
  } -- <-- End of highlights table

}   -- <-- End of bufferline.setup call.
