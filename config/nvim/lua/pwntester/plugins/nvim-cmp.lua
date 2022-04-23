local lspkind = require "lspkind"
local cmp = require "cmp"

local ok, luasnip = pcall(require, "luasnip", { silent = true })
if not ok then
  luasnip = nil
end

local function tab(fallback)
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
  elseif luasnip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function shift_tab(fallback)
  if luasnip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local function setup()
  cmp.setup {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "c",
      }),
      ["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "c",
      }),
      ["<C-e>"] = cmp.mapping.close(),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", keyword_pattern = [[\k\+]] },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
    formatting = {
      deprecated = true,
      fields = { "abbr", "menu" },
      format = function(entry, item)
        local lspkind_formatter = lspkind.cmp_format {
          with_text = true,
          maxwidth = 50,
          menu = {
            nvim_lsp = "[lsp]",
            luasnip = "[snip]",
            nvim_lua = "[lua]",
            buffer = "[buf]",
            path = "[path]",
            cmdline = "[cmd]",
            ["cmdline_history"] = "[history]",
          },
        }
        item = lspkind_formatter(entry, item)
        --item.abbr = item.abbr:gsub("~", "")
        return item
      end,
    },
  }

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

end

return {
  setup = setup,
}
