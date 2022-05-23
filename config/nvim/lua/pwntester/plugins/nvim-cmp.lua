local cmp = require "cmp"
local status, luasnip = pcall(require, "luasnip")
if not status then
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

  require("cmp_git").setup({
    -- defaults
    filetypes = { "gitcommit", "octo" },
    trigger_actions = {
      {
        debug_name = "git_commits",
        trigger_character = ":",
        action = function(sources, trigger_char, callback, params)
          return sources.git:get_commits(callback, params, trigger_char)
        end,
      },
      {
        debug_name = "github_issues_and_pr",
        trigger_character = "#",
        action = function(sources, trigger_char, callback, _, git_info)
          return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
        end,
      },
      {
        debug_name = "github_mentions",
        trigger_character = "@",
        action = function(sources, trigger_char, callback, _, git_info)
          return sources.github:get_mentions(callback, git_info, trigger_char)
        end,
      },
    },
  })

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
        winhighlight = 'Normal:CmpFloat,FloatBorder:CmpBorder,CursorLine:CursorLineNr,Search:ErroMsg',
        border = window_border_chars_thick,
        zindex = 1001
      },
      documentation = {
        winhighlight = 'Normal:CmpFloat,FloatBorder:CmpBorder,CursorLine:CursorLineNr,Search:ErroMsg',
        border = window_border_chars_thick,
        zindex = 1001
      },
    },
    sources = {
      { name = "nvim_lsp", keyword_pattern = [[\k\+]] },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = 'emoji' },
      { name = "git" },
    },
    formatting = {
      deprecated = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)

        -- Kind icons
        item.kind = string.format("%s", kind_icons[item.kind])

        if entry.source.name == "cmp_tabnine" then
          -- if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          -- menu = entry.completion_item.data.detail .. " " .. menu
          -- end
          item.kind = icons.misc.Robot
        end
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        item.menu = ({
          -- nvim_lsp = "[lsp]",
          -- luasnip = "[snip]",
          -- nvim_lua = "[lua]",
          -- buffer = "[buf]",
          -- path = "[path]",
          -- cmdline = "[cmd]",
          -- cmdline_history = "[history]",
          nvim_lsp = "",
          luasnip = "",
          nvim_lua = "",
          buffer = "",
          path = "",
          cmdline = "",
          cmdline_history = "",
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
    },
  }

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'cmdline_history' },
      { name = 'path' },
    })
  })

  for _, cmd_type in ipairs({ '/', '?', '@' }) do
    cmp.setup.cmdline(cmd_type, {
      view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
      sources = cmp.config.sources({
        { name = 'nvim_lsp_document_symbol' },
      }, {
        { name = 'buffer' },
      }),
    })
  end

end

return {
  setup = setup,
}
