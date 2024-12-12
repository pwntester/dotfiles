return {
  "gcmt/cmdfix.nvim",
  lazy = true,
  config = function()
    require("cmdfix").setup {
      enabled = true, -- enable or disable plugin
      threshold = 2, -- minimum characters to consider before fixing the command
      ignore = { "Next" }, -- won't be fixed (default value)
      aliases = { ["Snacks.bufdelete()"] = "bd" }, -- custom aliases
    }
  end,
}
