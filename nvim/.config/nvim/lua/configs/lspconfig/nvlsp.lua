-- Define a default on_attach function
-- This function is called every time an LSP client attaches to a buffer.
-- It's a common place to set up keymaps for LSP functionalities.
local on_attach = function(client, bufnr)
  -- Enable completion for LSP. Requires nvim-cmp to be set up.
  -- This might be redundant if nvim-cmp sets it globally via its setup.
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Basic keymaps (you might already have these in init.lua or a separate keymap file)
  -- It's common to define LSP-specific keymaps here
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  -- Diagnostics keymaps (optional, useful for quick navigation)
  buf_set_keymap(bufnr, 'n', '[d', '<cmd>vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ']d', '<cmd>vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>vd', '<cmd>vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ql', '<cmd>vim.diagnostic.setloclist()<CR>', opts)

  -- Other LSP keymaps (example, adjust as needed)
  buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  -- You may want to set up specific formatting on save for certain clients
  -- if client.name == "omnisharp" then
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.format({ bufnr = bufnr })
  --     end,
  --   })
  -- end
end

-- Define a default on_init function (often not strictly needed unless for specific server initialization)
-- This function is called once when the LSP client is initializing.
local on_init = function(client, initialize_result)
  -- You can log or inspect initialize_result here if needed
end

-- Define default capabilities (often handled by nvim-cmp for snippet support)
-- If you use nvim-cmp, you'd typically get capabilities from there.
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- If you're using nvim-cmp, you'd also include:
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

return {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
