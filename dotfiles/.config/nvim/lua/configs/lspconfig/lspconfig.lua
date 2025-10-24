local pid = vim.fn.getpid()

-- Modern approach: define capabilities once
local capabilities = vim.lsp.protocol.make_client_capabilities()

local vimlsp = require("configs.lspconfig.nvlsp")

local on_attach = vimlsp.on_attach

-- Configure border style for LSP floating windows
local BORDER_STYLE = "rounded"

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
  vim.lsp.enable(server, config)
end
