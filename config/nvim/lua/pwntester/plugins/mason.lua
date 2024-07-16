return {
  "williamboman/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require "mason"
    local mason_tool_installer = require "mason-tool-installer"
    local mason_lspconfig = require "mason-lspconfig"

    mason.setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    mason_lspconfig.setup {
      ensure_installed = require("pwntester.lsp").servers,
    }

    mason_tool_installer.setup {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "shfmt", -- sh formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
        "mypy", -- python linter
        "flake8", -- python linter
        "shellcheck", -- sh linter
        "luacheck", -- lua linter
        "write-good", -- markdown linter
      },
    }
  end,
}
