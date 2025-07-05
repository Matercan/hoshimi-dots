require("vim-options")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Lazy.nvim and define plugins


local plugins = {
  require("plugins.themes"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.neotree"),
  require("plugins.lualine"),
  require("plugins.lsp-config"),
  require("plugins.alpha"),
  require("plugins.completions"),
  require("plugins.gitsigns"),
  require("plugins.essentials"),
  require("plugins.git"),
  require("plugins.trouble")
}

require("lazy").setup(plugins)


-- Global options after plugins are loaded (e.g., configurations that might depend on plugins)
-- Ensure treesitter is configured after it's loaded by Lazy


-- Keymaps (always good to put these at the end, after plugins are loaded)

vim.keymap.set('n', '<C-n>', function() vim.cmd('Neotree filesystem reveal left') end, {desc = "Toggle Neotree"})
vim.keymap.set('n', '<leader>s', '<Esc> :w <CR>', {})
vim.keymap.set('n', '<leader>e', '<Esc> :q <CR>', {})
vim.keymap.set('n', '<C-x>', '<Esc> :wqa <CR>', {})


vim.keymap.set('n', '<leader>rh', function()
  -- Prompt for the pattern to find
  vim.ui.input({ prompt = 'Find: ' }, function(find_pattern)
    if not find_pattern then return end -- User cancelled

    -- Prompt for the replacement string
    vim.ui.input({ prompt = 'Replace with: ' }, function(replace_string)
      -- If replace_string is nil, user cancelled, or they want to replace with nothing
      replace_string = replace_string or ''

      -- Execute the substitute command globally on the file with confirmation
      vim.cmd(string.format('%%s/%s/%s/gc', find_pattern, replace_string))
    end)
  end)
end, { desc = 'Find and Replace (File)' })
