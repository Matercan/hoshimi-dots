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
  ---@diagnostic disable-next-line: different-requires
  require("plugins.telescope"),
  require("plugins.neotree"),
  require("plugins.lualine"),
  require("plugins.lsp-config"),
  require("plugins.completions"),
  require("plugins.gitsigns"),
  require("plugins.essentials"),
  require("plugins.git"),
  require("plugins.trouble"),
  require("plugins.testing"),
  require("plugins")
}

require("lazy").setup(plugins)


-- Global options after plugins are loaded (e.g., configurations that might depend on plugins)
require("lua.configs.options")

vim.cmd("Catppuccin latte")
