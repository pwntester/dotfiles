return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  enabled = false,

  opts = {
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    nerd_font_variant = "normal",
    accept = { auto_brackets = { enabled = true } },
    trigger = { signature_help = { enabled = true } },
    fuzzy = {
      prebuiltBinaries = {
        download = true,
        forceVersion = true,
      },
    },
  },
}
