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
  require("plugins.catppuccin"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.neotree"),
  require("plugins.lualine"),
  require("plugins.lsp-config"),
  require("plugins.indent-blankline"),
  require("plugins.alpha"),
  require("plugins.completions"),
  require("plugins.gitsigns"),
  require("plugins.essentials"),
  -- require("plugins"),
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


-- local builtin = require("telescope.builtin")
-- vim.keymapset("n", "<C-p>", builtin.find_files, {})
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
-- vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
