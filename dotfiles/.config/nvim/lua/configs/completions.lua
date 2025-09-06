local cmp = require("cmp")
local luasnip = require("luasnip") -- Make sure luasnip is loaded
require("luasnip.loaders.from_vscode").lazy_load()

-- Load nvim-web-devicons for completion kind icons
local kind_icons = require("nvim-web-devicons").get_icons()

-- You can also define custom icons for LSP kind (optional)
-- This maps LSP kinds to specific icons, overriding devicons if needed
local lsp_kind_icons = {
  Text = "",
  Method = "",
  Function = "󰊕", -- Changed from 'ू' to a more common function icon
  Constructor = "",
  Field = "", -- Common icon for Field
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "", -- Changed from 'ert' to a common property icon
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "", -- Common icon for TypeParameter
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use the loaded luasnip
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" }, -- For luasnip users.
  }, {
    { name = "buffer" },
  }),
  -- >>> ADD THIS SECTION FOR ICONS AND COLORIZATION <<<
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      -- Assign a custom icon and highlight group based on LSP kind
      vim_item.kind = (kind_icons[vim_item.kind] or lsp_kind_icons[vim_item.kind] or "?") .. " "
      -- This sets the highlight group for the 'kind' (icon)
      vim_item.menu = ({
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
    end,
  },
  -- For custom highlight groups for completion items (optional, but good for color)
  -- You might need to define these highlight groups in your colorscheme or init.lua
  -- E.g., `highlight CmpItemKindFunction guifg=#ABCDEF`
  -- The default behavior of nvim-cmp usually applies colors based on default highlight groups
  -- provided by your colorscheme.
})
