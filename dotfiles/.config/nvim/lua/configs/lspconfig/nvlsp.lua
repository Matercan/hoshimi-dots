-- ~/.config/nvim/lua/configs/lspconfig/nvlsp.lua

-- Define on_attach function
local on_attach = function(client, bufnr)
  -- This function runs when an LSP client attaches to a buffer.
  -- You can set up keymaps, autocommands, etc., here.

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


  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Modern buffer-local keymaps using vim.keymap.set
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

-- Define on_init function
local on_init = function(client)
  -- For example, disable specific capabilities if needed.
  -- client.server_capabilities.foldingRange = false -- Example to disable foldingRange 

  client.server_capabilities.foldingRange = true
end


local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
