return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  version = "*",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  dependencies = {
    -- "fang2hou/blink-copilot",
    -- "Kaiser-Yang/blink-cmp-avante",
    -- "supermaven-inc/supermaven-nvim",
    -- "huijiro/blink-cmp-supermaven",
    "rafamadriz/friendly-snippets",
    {
      "saghen/blink.compat",
      version = "*",
      lazy = true,
      opts = {},
    },
  },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    cmdline = { enabled = false },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          -- Aligns the keyword you've typed to a component in the menu
          align_to = 'label', -- or 'none' to disable, or 'cursor' to align to the cursor
          -- Left and right padding, optionally { left, right } for different padding on each side
          padding = 1,
          -- Gap between columns
          gap = 1,
          -- Use treesitter to highlight the label text for the given list of sources
          treesitter = {}, -- { 'lsp' }
          -- Components to render, grouped by column
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          -- Definitions for possible components to render. Each defines:
          --   ellipsis: whether to add an ellipsis when truncating the text
          --   width: control the min, max and fill behavior of the component
          --   text function: will be called for each item
          --   highlight function: will be called only when the line appears on screen
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            }
          }
        }
      },
      -- menu = {
      --   draw = {
      --     treesitter = { "lsp" },
      --   },
      -- },
      -- documentation = {
      --   auto_show = true,
      --   auto_show_delay_ms = 200,
      -- },
      ghost_text = {
        enabled = true,
        -- Show the ghost text when an item has been selected
        show_with_selection = true,
        -- Show the ghost text when no item has been selected, defaulting to the first item
        show_without_selection = false,
        -- Show the ghost text when the menu is open
        show_with_menu = true,
        -- Show the ghost text when the menu is closed
        show_without_menu = true,
      },
    },
    sources = {
      default = function()
        return {
          "lsp",
          "path",
          -- "supermaven", -- "avante", "copilot"
          "buffer",
        }
      end,
      providers = {
        -- copilot = {
        --   name = "copilot",
        --   module = "blink-copilot",
        --   score_offset = 100,
        --   async = true
        -- },
        -- supermaven = {
        --   name = "supermaven",
        --   module = "blink-cmp-supermaven",
        --   async = true,
        -- },
        -- avante = {
        --   name = "avante",
        --   module = "blink-cmp-avante",
        --   opts = {},
        -- },
      },
    },
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-s>"] = { "show" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Right>"] = { "select_and_accept", "fallback" },
      ["<C-a>"] = {
        function(cmp)
          if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return require("copilot-lsp.nes").apply_pending_nes()
          end
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<Tab>"] = {
        -- { "snippet_forward" }, -- ai_accept
        "snippet_forward",
        -- "ai_accept",
        "fallback",
      }
    },
    enabled = function()
      return vim.bo.buftype ~= "prompt"
    end,
  },
}

-- keymap = {
-- 	preset = "enter",
--     preset = "super-tab",
--     ["<Tab>"] = {
--         function(cmp)
--             if vim.b[vim.api.nvim_get_current_buf()].nes_state then
--                 cmp.hide()
--                 return require("copilot-lsp.nes").apply_pending_nes()
--             end
--             if cmp.snippet_active() then
--                 return cmp.accept()
--             else
--                 return cmp.select_and_accept()
--             end
--         end,
--         "snippet_forward",
--         "fallback",
--     },
-- 	["<C-y>"] = { "accept", "select_and_accept" },
-- 	-- ["<C-y>"] = { "accept", "fallback" },
-- 	-- ["<Tab>"] = { "select_next", "fallback" }, -- snippets
-- 	["<S-Tab>"] = { "select_prev", "fallback" },
-- 	["<C-l>"] = { "show", "hide", "fallback" },
-- 	["<C-_>"] = { "cancel", "fallback" },
-- 	["<C-Space>"] = { "show_documentation", "hide_documentation", "fallback" },
-- 	["<C-f>"] = { "scroll_documentation_down", "fallback" },
-- 	["<C-b>"] = { "scroll_documentation_up", "fallback" },
-- },
