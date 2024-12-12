-- https://github.com/rachartier/tiny-inline-diagnostic.nvim
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  config = function()
    require("tiny-inline-diagnostic").setup {
      preset = "modern",
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine", -- Can be a highlight or a hexadecimal color (#RRGGBB)
        mixing_color = "None", -- Can be None or a hexadecimal color (#RRGGBB). Used to blend the background color with the diagnostic background color with another color.
      },
      options = {
        show_source = false,

        throttle = 20,

        -- The minimum length of the message, otherwise it will be on a new line.
        softwrap = 30,

        multiple_diag_under_cursor = false,

        multilines = false,

        show_all_diags_on_cursorline = false,

        enable_on_insert = false,

        --- When overflow="wrap", when the message is too long, it is then displayed on multiple lines.
        overflow = {
          mode = "wrap",
        },

        format = nil,
        --- Enable it if you want to always have message with `after` characters length.
        break_line = {
          enabled = false,
          after = 30,
        },

        virt_texts = {
          priority = 2048,
        },

        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },

        overwrite_events = nil,
      },
    }
  end,
}
