local lspkind = require('lspkind')
local autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require'cmp'

local function setup()
  cmp.setup({
    formatting = {
      format = function(entry, item)
        local lspkind_formatter = lspkind.cmp_format({
          with_text = true,
          maxwidth = 50,
          menu = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
          }
        })
        item = lspkind_formatter(entry, item)
        item.abbr = item.abbr:gsub('~', '')
        return item
      end
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    -- https://github.com/hrsh7th/nvim-cmp/issues/231
    mapping = {
      ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          cmp.mapping.confirm({ select = true })
        else
          require"nvim-autopairs".autopairs_cr()
          --fallback()
        end
      end
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
    }
  })
  autopairs.setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    auto_select = true, -- automatically select the first item
    insert = false, -- use insert confirm behavior instead of replace
    map_char = { -- modifies the function or method delimiter by filetypes
      all = '(',
      tex = '{'
    }
  })
end

return {
  setup = setup
}
