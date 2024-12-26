return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      require("smart-splits").setup {
        -- Ignored filetypes (only while resizing)
        ignored_buftypes = require("pwntester.globals").special_buffers,
        -- Ignored buffer types (only while resizing)
        ignored_filetypes = {
          "nofile",
          "quickfix",
          "prompt",
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to window to the left", },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to window to the down", },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to window to the up", },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to window to the right", },
      { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left", },
      { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down", },
      { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up", },
      { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right", },
    }
  },
  {
    "willothy/wezterm.nvim",
    config = true,
  },
}
