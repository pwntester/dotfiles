return {
	"nvim-neotest/neotest",
	dependencies = {
		{ "nvim-neotest/nvim-nio" },
		-- { "pwntester/neotest-codeql", dev = true },
		-- { "thenbe/neotest-consumers" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-codeql"),
			},
			log_level = 2,
			state = { enabled = true },
			status = { virtual_text = true },
			output = { open_on_run = true },
			quickfix = {
				open = function()
					require("trouble").open({ mode = "quickfix", focus = false })
				end,
			},
			running = {
				concurrent = false,
			},
			consumers = {
				trouble = function(client)
					client.listeners.results = function(adapter_id, results, partial)
						if partial then
							return
						end
						local tree = assert(client:get_position(nil, { adapter = adapter_id }))

						local failed = 0
						for pos_id, result in pairs(results) do
							if result.status == "failed" and tree:get_key(pos_id) then
								failed = failed + 1
							end
						end
						vim.schedule(function()
							local trouble = require("trouble")
							if trouble.is_open() then
								trouble.refresh()
								if failed == 0 then
									trouble.close()
								end
							end
						end)
						return {}
					end
				end,
				-- neotest_consumers = require("neotest-consumers").consumers,
				codeql_consumers = require("neotest-codeql.consumers"),
			},
			-- icons = {
			--   running_animated = {
			--     "󱑊",
			--     "󱑀",
			--     "󱑁",
			--     "󱑂",
			--     "󱑃",
			--     "󱑄",
			--     "󱑅",
			--     "󱑆",
			--     "󱑇",
			--     "󱑉",
			--   },
			--   running = "󱑁",
			--   passed = "",
			--   failed = "",
			--   skipped = "",
			--   watching = "󰈈",
			--   unknown = "",
			-- },
		})
		-- change summary background color
		vim.api.nvim_create_autocmd("WinEnter", {
			pattern = "*",
			callback = function()
				if not (vim.bo.filetype == "neotest-summary") then
					return
				end
				vim.wo.winhighlight = "Normal:NormalAlt"
			end,
		})
	end,
  -- stylua: ignore
  keys = {
    { "<leader>t", "", desc = "+test" },
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tD", function() require("neotest").run.run(vim.fn.expand("%:h")) end, desc = "Run Directory" },
    { "<leader>td", function() require("neotest").codeql_consumers.diff() end, desc = "Diff failed tests" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true, open_win = function() vim.cmd("split") end }) end, desc = "Show Output" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
  },
}
