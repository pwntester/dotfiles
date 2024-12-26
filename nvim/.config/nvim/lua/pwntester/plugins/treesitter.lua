local g = require("pwntester.globals")

local textobjects = {
	move = {
		enable = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
		goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			ensure_installed = {
				"ql",
				"python",
				"lua",
				"java",
				"javascript",
				"typescript",
				"html",
				"markdown",
				"markdown_inline",
				"kdl",
				"ruby",
				-- "vim",
			},
			highlight = { enable = true },
			indent = { enable = true },
			matchup = { enable = true },
			markdown = { enable = true },
			incremental_selection = {
				enable = false,
				keymaps = {
					init_selection = "<Plug>(TsSelInit)", -- maps in normal mode to init the node/scope selection
					node_incremental = "<Plug>(TsSelNodeIncr)", -- increment to the upper named parent
					node_decremental = "<Plug>(TsSelNodeDecr)", -- decrement to the previous node
					scope_incremental = "<Plug>(TsSelScopeIncr)", -- increment to the upper scope (as defined in locals.scm)
					scope_decremental = "<Plug>(TsSelScopeDecr)", -- decrement to the upper scope (as defined in locals.scm)
				},
			},
			textobjects = textobjects,
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		enabled = true,
		config = function()
			-- If treesitter is already loaded, we need to run config again for textobjects
			if g.is_loaded("nvim-treesitter") then
				require("nvim-treesitter.configs").setup({ textobjects = textobjects })
			end

			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move")
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name]
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},
}
