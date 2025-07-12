-- Keymaps 

vim.keymap.set('n', '<C-n>', function() vim.cmd('Neotree filesystem reveal left') end, {desc = "Toggle Neotree"})
vim.keymap.set('n', '<leader>s', '<Esc> :w <CR>', {})
vim.keymap.set('n', '<leader>e', '<Esc> :q <CR>', {})
vim.keymap.set('n', '<C-x>', '<Esc> :wqa <CR>', {})

-- Replacing patterns

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

-- Property colorings

vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#F8BD96" }) -- Example Catppuccin color for Classes (orange-ish)
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#A6DA95" }) -- Example Catppuccin color for Methods (green-ish)
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#7DC4E4" }) -- Example Catppuccin color for Functions (blue-ish)
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#EED49F" }) -- Example Catppuccin color for Variables (yellow-ish)
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#F28C8C" }) -- Example Catppuccin color for Properties (red-ish)
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C6A0F6" })     -- Example Catppuccin color for Enums (purple-ish)

-- Foldings

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs", -- Apply these settings only for C# files
  callback = function()
    vim.opt_local.foldenable = true
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldlevel = 0 -- Start with all folds open (or 0 for all closed)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "py", -- Apply these settings only for Py files
  callback = function ()
    vim.opt_local.foldenable = true
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldlevel = 99
  end
})
