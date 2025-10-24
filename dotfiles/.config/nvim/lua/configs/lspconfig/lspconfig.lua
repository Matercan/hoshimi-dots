-- Modern LSP configuration (Neovim 0.11+)

local pid = vim.fn.getpid()

--  Borders for floating windows
local BORDER_STYLE = "rounded"

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = BORDER_STYLE })

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = BORDER_STYLE })

--  Optional UI override (telescope integration)
local original_ui_select = vim.ui.select
vim.ui.select = function(items, opts, on_choice)
  opts = opts or {}
  opts.format_item = opts.format_item or function(item)
    return tostring(item)
  end

  local has_telescope, telescope_builtin = pcall(require, 'telescope.builtin')
  if has_telescope then
    return telescope_builtin.select(items, opts, on_choice)
  else
    return original_ui_select(items, opts, on_choice)
  end
end

--  Global border override for floating previews
vim.lsp.util.open_floating_preview = (function(original_fn)
  return function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or BORDER_STYLE
    return original_fn(contents, syntax, opts, ...)
  end
end)(vim.lsp.util.open_floating_preview)

--  Diagnostics configuration
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

--  Define diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--  Define all servers using the new vim.lsp.config API
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
    root_dir = vim.fs.root(0, { "*.sln", ".git", "*.csproj", "omnisharp.json" }),
  },
  clangd = {},
  cmake = {},
  qmlls = {
    root_dir = vim.fs.root(0, { "shell.qml" }),
  },
  neocmake = {}
}

local nvlsp = require('configs.lspconfig.nvlsp')

--  Register and enable all servers
for name, config in pairs(servers) do
  vim.lsp.config(name, vim.tbl_deep_extend("force", {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
  }, config))

  -- Automatically enable the LSP for its filetypes
  vim.lsp.enable(name)
end
