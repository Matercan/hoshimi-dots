-- ~/.config/nvim/lua/configs/lspconfig/nvlsp.lua

-- Define on_attach function
--  Common on_attach
local on_attach = function(client, bufnr)
   -- Example: enable formatting on save if the client supports it
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting.buffer" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end


  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

--  Capabilities (add cmp_nvim_lsp if you use it)
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, cmp_capabilities)


return {
  on_attach = on_attach,
  capabilities = capabilities,
}
