return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  -- Remove the `opts = {}` line here, and use `config` instead
  config = function()
    require("trouble").setup({
      -- Your trouble.nvim setup options go here
      -- These were the default options that `opts = {}` would have applied.
      -- Now you put them inside the setup call.

      -- Example default options (you can customize these):
      icons = "nvim-web-devicons", -- Requires nvim-web-devicons if you want icons
      fold_open = "",
      fold_closed = "",
      -- Add your border setting here (if you haven't done it elsewhere)
      float = {
        border = "rounded", -- Or "single", "double", etc.
      },
      -- ... any othertrouble.nvim options you want ...
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    })
  end,
}
