local cmp = require("cmp")

cmp.setup({
  completion = {
    autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
    completeopt = "menu,menuone,noselect",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  formatting = {
    format = function(_, item)
      local icons = {
        Text = "Txt",
        Method = "Mth",
        Function = "Fn",
        Constructor = "New",
        Field = "Fld",
        Variable = "Var",
        Class = "Cls",
        Interface = "Ifs",
        Module = "Mod",
        Property = "Prop",
        Unit = "Unt",
        Value = "Val",
        Enum = "Enm",
        Keyword = "Key",
        Snippet = "Snp",
        Color = "Clr",
        File = "Fil",
        Reference = "Ref",
        Folder = "Dir",
        EnumMember = "Mem",
        Constant = "Cst",
        Struct = "Str",
        Event = "Evt",
        Operator = "Op",
        TypeParameter = "Typ",
      }

      item.kind = icons[item.kind] or item.kind
      return item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.filetype("rust", {
  completion = {
    keyword_length = 1,
  },
})
