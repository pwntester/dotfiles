return {
  "saghen/blink.cmp",
  version = '1.*', -- use a release tag to download pre-built binaries
  dependencies = {
    "fang2hou/blink-copilot",
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = {},
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
          -- Use treesitter to highlight the label text for the given list of sources
          treesitter = { 'lsp' }
        }
      },
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      default = function()
        return {
          "lsp",
          "path",
          "buffer",
          "copilot" -- "supermaven", -- "avante", 
        }
      end,
      providers = {
        copilot = {
            name = "copilot",
            module = "blink-copilot",
            opts = {
              max_completions = 3,
              max_attempts = 4,
            },
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
        },
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
      --["<C-s>"] = { "show" },
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
