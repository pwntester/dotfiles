-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/lua_ls.lua

return {
	cmd = {
		"lua-language-server",
	},
	filetypes = {
		"lua",
	},
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
	},
	settings = {
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
				disable = { "missing-parameters", "missing-fields" },
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},

	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
