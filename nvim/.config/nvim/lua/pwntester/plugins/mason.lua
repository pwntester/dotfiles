return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
        -- LSP
        "lua-language-server",
        "dockerfile-language-server",
        "json-lsp",
        "yaml-language-server",
        "typescript-language-server",
        "codeql",
        "python-lsp-server", -- instead of "pyright" since it has no formatter
        "bash-language-server",
        "marksman",
        
        -- FORMATTERS
				"stylua", -- lua formatter
				"isort",  -- python formatter
				"black",  -- python formatter
				"kulala-fmt", -- REST formatter
				"shfmt",  -- sh formatter

        -- LINTERS
				"pylint", -- python linter
				"mypy",   -- python linter
				"flake8", -- python linter
				"shellcheck", -- sh linter
			},
		})
	end,
}
