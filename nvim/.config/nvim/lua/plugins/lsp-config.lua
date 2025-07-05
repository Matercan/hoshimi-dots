return {
  {
    "mason-org/mason.nvim",
    opts = {},
    config = function()
      require("mason").setup()
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls", "pylsp", "jsonls", "ts_ls"}
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              mccabe = {
                enabled = false,
              },
              pycodestyle = {
                enabled = true,
                maxLineLength = 200,
                ignore = {
                  'W291', 'E501', 'E303',
                  'W293', 'E261', 'E302',
                  'E701', 'E305', 'E252',
                  'E127', 'E401', 'E402'
                },
              },
            },
          },
        },
      })
      lspconfig.ts_ls.setup({})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})

      local BORDER_STYLE = "rounded"

      -- LSP Hover (documentation when hovering over symbols)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = BORDER_STYLE,
        -- Additional options can go here if desired
        -- e.g., `max_width`, `max_height`
      })

      -- LSP Signature Help (function/method signature as you type)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = BORDER_STYLE,
      })

      -- LSP Code Actions (if they appear as a floating wind:ow, though often they're command-line)
      vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers.code_action, {
        border = BORDER_STYLE,
      })

      -- Core Neovim Diagnostics Float (used by `:h vim.diagnostic.open_float()`)
      vim.diagnostic.config({
        float = {
          border = BORDER_STYLE,
          -- You can also set other float options here, like `source`, `severity`, etc.
          -- source = "always",
          -- severity_sort = true,
        },
      })
    end
  }
}
