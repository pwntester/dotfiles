local lspkind = require "lspkind"
local api = vim.api
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
  local formatting = {
    deprecated = true,
    fields = { "abbr", "menu" },
    format = function(entry, item)
      local lspkind_formatter = lspkind.cmp_format {
        with_text = true,
        maxwidth = 50,
        menu = {
          --copilot = "[copilot]",
          nvim_lsp = "[lsp]",
          luasnip = "[snip]",
          nvim_lua = "[lua]",
          --spell = "[spell]",
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
    documentation = {
      border = "rounded",
    },
  }

  local mappings = {
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
  }

  cmp.setup {
    completion = {
      keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]], -- default one
      --autocomplete = false,
    },
    experimental = {
      ghost_text = false, -- disable whilst using copilot
      -- ghost_text = { hl_group = "CmpGhostText" }
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = mappings,
    formatting = formatting,
    sources = cmp.config.sources({
      --{ name = "copilot" },
      {
        name = "nvim_lsp",
        keyword_pattern = [[\k\+]],
      },
      { name = "luasnip" },
      { name = "nvim_lua" },
      --{ name = "spell" },
      { name = "path" },
    }, {
      { name = "buffer" },
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

  local search_sources = {
    sources = {
      { name = "buffer" },
      { name = "nvim_lsp_document_symbol" },
      { name = "cmdline_history" },
    },
  }
  local command_sources = {
    sources = {
      { name = "path" },
      { name = "cmdline" },
      { name = "cmdline_history" },
    },
  }
  --cmp.setup.cmdline("/", search_sources)
  --cmp.setup.cmdline("?", search_sources)
  --cmp.setup.cmdline(":", command_sources)
end

return {
  setup = setup,
}
