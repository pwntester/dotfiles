-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/dockerls.lua

local workspace_folders = {}

return {
	cmd = {
		"codeql",
		"execute",
		"language-server",
		"--check-errors",
		"ON_CHANGE",
		"-q",
	},
	filetypes = {
		"ql",
	},
	root_markers = {
		"qlpack.yml",
	},
	settings = {
		-- List containing all search paths, eg: '~/codeql-home/codeql-repo'.
		search_path = vim.empty_dict(),
	},
	before_init = function(initialize_params)
		table.insert(workspace_folders, { name = "workspace", uri = initialize_params["rootUri"] })
		initialize_params["workspaceFolders"] = workspace_folders
	end,
	on_new_config = function(config)
		if type(config.settings.search_path) == "table" and not vim.tbl_isempty(config.settings.search_path) then
			local search_path = "--search-path="
			for _, path in ipairs(config.settings.search_path) do
				search_path = search_path .. vim.fn.expand(path) .. ":"
				table.insert(workspace_folders, {
					name = "workspace",
					uri = string.format("file://%s", path),
				})
			end
			config.cmd = { "codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q", search_path }
		else
			config.cmd = { "codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q" }
		end
	end,
	log_level = vim.lsp.protocol.MessageType.Warning,
	single_file_support = true,
}
