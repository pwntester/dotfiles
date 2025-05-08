return {
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<C-s>", desc = "Send request" },
			--{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>k", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			-- your configuration comes here
			global_keymaps = false,
		},
	},
}
