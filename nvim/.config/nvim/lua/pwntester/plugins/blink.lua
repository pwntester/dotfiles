return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  -- dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  version = "v0.*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    -- keymap = { preset = "default" },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "accept", "select_and_accept" },
      --["<C-y>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" }, -- snippets
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-l>"] = { "show", "hide", "fallback" },
      ["<C-_>"] = { "cancel", "fallback" },
      ["<C-Space>"] = { "show_documentation", "hide_documentation", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    completion = {
      list = {
        selection = "auto_insert",
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
      trigger = {
        show_on_insert_on_trigger_character = false,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      compat = {},
      default = { "lsp", "path", "snippets", "buffer" },
      cmdline = {},
    },

    -- experimental signature help support
    -- signature = { enabled = true }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
