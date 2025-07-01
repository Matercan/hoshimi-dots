-- ~/.config/nvim/lua/plugins/lualine.lua

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({ -- <--- Corrected: `.` instead of `'`.` and added missing `(`
      options = {
        theme = 'everforest'
      }
    }) -- <--- Make sure the outer parenthesis for setup() is closed here
  end
}
