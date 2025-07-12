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
  require("plugins.neotree"),
  require("plugins.lualine"),
  require("plugins.lsp-config"),
  require("plugins.priority"),
  require("plugins.completions"),
  require("plugins.gitsigns"),
  require("plugins.essentials"),
  require("plugins.git"),
  require("plugins.trouble"),
  require("plugins.testing")
}

require("lazy").setup(plugins)


-- Global options after plugins are loaded (e.g., configurations that might depend on plugins)
-- Ensure treesitter is configured after it's loaded by Lazy

require("configs.options")
