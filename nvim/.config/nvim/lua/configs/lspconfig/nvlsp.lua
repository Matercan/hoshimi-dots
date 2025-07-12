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

  -- Example: Set up default keymaps for LSP actions
  -- This is a common pattern for convenience
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
end

-- Define on_init function
local on_init = function(client)
  -- This function runs once when the LSP client is initialized.
  -- You can modify the client's capabilities before it's attached to any buffer.
  -- For example, disable specific capabilities if needed.
  -- client.server_capabilities.foldingRange = false -- Example to disable foldingRange
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
