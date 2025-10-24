local pid = vim.fn.getpid()

-- Modern approach: define capabilities once
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- If using nvim-cmp or similar, merge those capabilities
-- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, cmp_capabilities)

-- Modern on_attach using vim.lsp.buf directly
local on_attach = function(client, bufnr)
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

-- Configure border style for LSP floating windows
local BORDER_STYLE = "rounded"

-- Modern handlers configuration
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = BORDER_STYLE }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = BORDER_STYLE }
)

-- Modern diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = BORDER_STYLE,
    source = "always",
  },
})

-- Define diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Setup LSP servers with modern config
local servers = {
  lua_ls = {},
  jsonls = {},
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          mccabe = { enabled = false },
          pycodestyle = {
            enabled = true,
            maxLineLength = 200,
            ignore = {
              'W291', 'E501', 'E303', 'W293', 'E261',
              'E302', 'E701', 'E305', 'E252', 'E127',
              'E401', 'E402',
            },
          },
        },
      },
    },
  },
  ts_ls = {},
  cssls = {},
  postgres_lsp = {},
  omnisharp = {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
  },
  clangd = {},
  cmake = {},
  qmlls = {
  },
}

-- Setup all servers
for server, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  vim.lsp.enable(server); 
end
