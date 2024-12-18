return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup {}
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("fzf-lua").files {
          file_icons = "mini",
          fzf_opts = { ["--layout"] = "reverse-list" },
          formatter = "path.filename_first",
        }
      end,
      desc = "Find files",
    },
    {
      "<leader>l",
      function()
        require("fzf-lua").live_grep { file_icons = "mini", formatter = "path.filename_first" }
      end,
      desc = "Live grep",
    },
    {
      "<leader>o",
      function()
        require("fzf-lua").buffers { file_icons = "mini", formatter = "path.filename_first" }
      end,
      desc = "Open buffers",
    },
    {
      "<leader>m",
      function()
        require("fzf-lua").oldfiles { file_icons = "mini", formatter = "path.filename_first" }
      end,
      desc = "Most Recently Used",
    },
  },
}
