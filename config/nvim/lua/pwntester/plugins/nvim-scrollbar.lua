return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy",
  config = function()
    --local c = require("nautilus.theme").colors
    require("scrollbar").setup {
      excluded_filetypes = require("pwntester.globals").special_buffers,
      handle = {
        text = " ",
        color = "#333b4c",
        --color = c.cobalt,
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = { text = { "-", "=" }, priority = 0, color = "orange" },
        Error = { text = { "-", "=" }, priority = 1, color = "red" },
        Warn = { text = { "-", "=" }, priority = 2, color = "yellow" },
        Info = { text = { "-", "=" }, priority = 3, color = "blue" },
        Hint = { text = { "-", "=" }, priority = 4, color = "green" },
        Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
      },
    }
    vim.cmd [[
          augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
        ]]
  end,
}
