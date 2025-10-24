local lspconfig = require('lspconfig')
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

-- Override vim.ui.select for code actions and other selections
local original_ui_select = vim.ui.select
vim.ui.select = function(items, opts, on_choice)
  opts = opts or {}
  opts.format_item = opts.format_item or function(item)
    return tostring(item)
  end
  
  -- Use telescope if available, otherwise use builtin with borders
  local has_telescope, telescope = pcall(require, 'telescope.themes')
  if has_telescope then
    return require('telescope.builtin').select(items, opts, on_choice)
  else
    -- Fallback to vim.ui.select with custom format
    opts.kind = opts.kind or 'generic'
    return original_ui_select(items, opts, on_choice)
  end
end

-- Configure floating window borders globally
vim.lsp.util.open_floating_preview = (function(original_fn)
  return function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or BORDER_STYLE
    return original_fn(contents, syntax, opts, ...)
  end
end)(vim.lsp.util.open_floating_preview)

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
    root_dir = lspconfig.util.root_pattern("*.sln", ".git", "*.csproj", "omnisharp.json"),
  },
  clangd = {},
  cmake = {},
  qmlls = {
    root_dir = lspconfig.util.root_pattern("shell.qml"),
  },
}

-- Setup all servers
for server, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  vim.lsp.enable(server, config)
end
