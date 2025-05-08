return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = "false",
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.icons",
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
  },
  opts = {
    provider = "claude",
    auto_suggestions_provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20240620",
      temperature = 0,
      max_tokens = 4096,
    },
    behaviour = {
      enable_claude_text_editor_tool_mode = false,
    },
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      diff = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle = {
        debug = "<leader>ad",
        hint = "<leader>ah",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
        remove_file = "d",
        add_file = "@",
        close = { "q" },
        close_from_input = nil,
      },
    },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = "right", -- the position of the sidebar
      wrap = true,      -- similar to vim.o.wrap
      width = 30,       -- default % based on available width
      sidebar_header = {
        enabled = true, -- true, false to enable/disable the header
        align = "center", -- left, center, right for title
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 8, -- Height of the input window in vertical layout
      },
      edit = {
        border = "rounded",
        start_insert = true, -- Start insert mode when opening the edit window
      },
      ask = {
        floating = false, -- Open the 'AvanteAsk' prompt in a floating window
        start_insert = true, -- Start insert mode when opening the ask window
        border = "rounded",
        ---@type "ours" | "theirs"
        focus_on_apply = "ours", -- which diff to focus after applying
      },
    },
  },
}
