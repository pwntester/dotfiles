return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lua" },
  },
  config = function()
    local window_border_chars_thick = {
      { "▛", "CmpBorder" },
      { "▀", "CmpBorder" },
      { "▜", "CmpBorder" },
      { "▐", "CmpBorder" },
      { "▟", "CmpBorder" },
      { "▄", "CmpBorder" },
      { "▙", "CmpBorder" },
      { "▌", "CmpBorder" },
    }
    local icons = require "pwntester.icons"
    local kind_icons = icons.kind
    local cmp = require "cmp"

    cmp.setup {
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      end,
      window = {
        completion = {
          winhighlight = "Normal:CmpFloat,FloatBorder:CmpBorder,CursorLine:CursorLineNr,Search:ErroMsg",
          border = window_border_chars_thick,
          zindex = 1001,
        },
        documentation = {
          winhighlight = "Normal:CmpFloat,FloatBorder:CmpBorder,CursorLine:CursorLineNr,Search:ErroMsg",
          border = window_border_chars_thick,
          zindex = 1001,
        },
      },
      sources = {
        { name = "nvim_lsp", keyword_pattern = [[\k\+]] },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "emoji" },
        --{ name = "git" },
      },
      formatting = {
        deprecated = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          -- Kind icons
          item.kind = string.format("%s", kind_icons[item.kind])

          if entry.source.name == "emoji" then
            item.kind = icons.misc.Smiley
          end
          item.menu = ({
            nvim_lsp = "",
            nvim_lua = "",
            luasnip = "",
            buffer = "",
            path = "",
            emoji = "",
          })[entry.source.name]
          return item
        end,
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
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
        -- ["<C-l>"] = cmp.mapping(function(fallback)
        --   vim.api.nvim_feedkeys(
        --     vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
        --     "n",
        --     true
        --   )
        -- end),
        -- ["<Right>"] = cmp.mapping(function(fallback)
        --   vim.api.nvim_feedkeys(
        --     vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
        --     "n",
        --     true
        --   )
        -- end),
      },
    }
  end,
}
