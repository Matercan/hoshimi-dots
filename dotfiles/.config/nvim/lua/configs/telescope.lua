---@diagnostic disable-next-line: different-requires
local telescope = require("telescope")
local builtin = require("telescope.builtin")

local open_with_trouble = require("trouble.sources.telescope").open

-- Global Telescope setup
telescope.setup({
  defaults = {
    mappings = {
      i = { ["<C-t>"] = open_with_trouble },
      n = { ["<C-t>"] = open_with_trouble },
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
    cmdline = {
      -- Adjust telescope picker size and layout
      picker   = {
        layout_config = {
          width  = 120,
          height = 25,
        }
      },
      -- Adjust your mappings
      mappings = {
        complete      = '<Tab>',
        run_selection = '<C-CR>',
        run_input     = '<CR>',
      },
      -- Triggers any shell command using overseer.nvim (`:!`)
      overseer = {
        enabled = true,
      },
    },
  },
})

telescope.load_extension('ui-select')
telescope.load_extension('cmdline')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })

vim.api.nvim_set_keymap('n', 'Q', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
