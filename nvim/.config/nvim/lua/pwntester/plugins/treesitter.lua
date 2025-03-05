local g = require("pwntester.globals")

local textobjects = {
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = { query = "@class.outer", desc = "Next class start" },
			--
			-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
			["]o"] = "@loop.*",
			-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
			--
			-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
			-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
			["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
		-- Below will go to either the start or the end, whichever is closer.
		-- Use if you want more granular movements
		-- Make it even more gradual by adding multiple queries and regex.
		goto_next = {
			["]d"] = "@conditional.outer",
		},
		goto_previous = {
			["[d"] = "@conditional.outer",
		},
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
