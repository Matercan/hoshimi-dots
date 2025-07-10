return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "netcoredbg"
      }
    },
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
        ensure_installed = {
          "lua_ls",
          "pylsp",
          "jsonls",
          "ts_ls",
          "cssls",
          "ast_grep",
          "postgres_lsp",
          "csharp_ls",
          "omnisharp"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig.lspconfig")
    end
  }
}
