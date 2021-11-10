local lspkind = require "lspkind"
local api = vim.api
local t = g.replace_termcodes
local cmp = require "cmp"

local ok, luasnip = g.safe_require("luasnip", { silent = true })
if not ok then
  luasnip = nil
end

local function tab(fallback)
  if cmp.visible() then
    --cmp.select_next_item()
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
  elseif luasnip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif api.nvim_get_mode().mode == "c" then
    fallback()
  else
    local copilot_keys = vim.fn["copilot#Accept"](t "<Plug>(Tabout)")
    if copilot_keys ~= "" then
      api.nvim_feedkeys(copilot_keys, "i", true)
    else
      local tc = api.nvim_replace_termcodes("<Plug>(Tabout)", true, true, true)
      api.nvim_feedkeys(tc, "i", true)
    end
  end
end

-- local function shift_tab(fallback)
--   if cmp.visible() then
--     cmp.select_prev_item()
--   elseif luasnip and luasnip.jumpable(-1) then
--     luasnip.jump(-1)
--   elseif api.nvim_get_mode().mode == "c" then
--     fallback()
--   else
--     local copilot_keys = vim.fn["copilot#Accept"]()
--     if copilot_keys ~= "" then
--       feed(copilot_keys, "i")
--     else
--       feed "<Plug>(Tabout)"
--     end
--   end
-- end

local function setup()
  cmp.setup {
    experimental = {
      ghost_text = false, -- disable whilst using copilot
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(tab, { "i", "c" }),
      -- ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-e>"] = cmp.mapping.close(),
      ["<C-q>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      -- ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      -- ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      -- ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      -- ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    },
    formatting = {
      deprecated = true,
      fields = { "abbr", "menu", "kind" },
      format = function(entry, item)
        local lspkind_formatter = lspkind.cmp_format {
          with_text = true,
          maxwidth = 50,
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[lsp]",
            path = "[path]",
            nvim_lua = "[lua]",
            luasnip = "[snip]",
            -- fuzzy_path = "[path]",
            -- fzy_buffer = "[buf]",
          },
        }
        item = lspkind_formatter(entry, item)
        item.abbr = item.abbr:gsub("~", "")
        return item
      end,
      documentation = {
        border = "rounded",
      },
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "spell" },
      { name = "fuzzy_path" },
    }, {
      { name = "fuzzy_buffer" },
    }),
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,

        -- copied from cmp-under, but I don't think I need the plugin for this.
        -- I might add some more of my own.
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find "^_+"
          local _, entry2_under = entry2.completion_item.label:find "^_+"
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          if entry1_under > entry2_under then
            return false
          elseif entry1_under < entry2_under then
            return true
          end
        end,

        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  -- local search_sources = {
  --   sources = cmp.config.sources({
  --     { name = "nvim_lsp_document_symbol" },
  --   }, {
  --     { name = "fuzzy_buffer" },
  --   }),
  -- }
  -- cmp.setup.cmdline("/", search_sources)
  -- cmp.setup.cmdline("?", search_sources)
  -- cmp.setup.cmdline(":", {
  --   sources = cmp.config.sources({
  --     { name = "fuzzy_path" },
  --   }, {
  --     { name = "cmdline" },
  --   }),
  -- })
end

return {
  setup = setup,
}
