return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x", -- Make sure you are on a stable branch
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Required for icons
    "MunifTanjim/nui.nvim",
  },

  cmd = "Neotree", -- This tells Lazy.nvim to load the plugin when Neotree command is called
  -- Optional: Configuration for Neo-tree
  config = function()
    require("neo-tree").setup({
      -- Your Neo-tree configuration options here
      window = {
        position = "left",
        width = 45,
        mapping_options = {
          -- You can put specific mappings for Neo-tree here
          -- For example, to close with 'q':
          -- ["q"] = "close_window",
        },
      },

      filesystem = {
        -- Other filesystem options
        filtered_items = {
          hide_dotfiles = false,
          hide_hidden = false,
          hide_git_ignored = true,
          always_show_folders = false,     -- Important for some people
        },
      },
    })
  end
}
