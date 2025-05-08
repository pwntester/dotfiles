return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  event = "VeryLazy",
  -- lazy = true,
  -- cmd = "ConformInfo",
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        kulala = {
          command = "kulala-fmt",
          args = { "format", "$FILENAME" },
          stdin = false,
        },
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        --yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        http = { "kulala" },
        sh = { "shfmt" },
      },
      -- format_on_save = {
      -- 	lsp_fallback = true,
      -- 	async = false,
      -- 	timeout_ms = 500,
      -- },
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}
