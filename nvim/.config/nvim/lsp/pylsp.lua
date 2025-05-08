-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/pylsp.lua

return {
	cmd = {
		"pylsp",
	},
	filetypes = {
		"python",
	},
	root_markers = {
		".git",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
	},

	single_file_support = true,
}
