return {
	"OXY2DEV/markview.nvim",
	lazy = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local markview = require("markview")
		local presets = require("markview.presets")
		markview.setup({
			preview = {
				modes = { "n", "i", "no", "c" },
				hybrid_modes = { "n", "i" },
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].conecalcursor = "nc"
					end,
				},
			},
			headings = presets.headings.glow_labels,
			markdown = {
				list_items = {
					enable = false,
				},
			},
			links = {
				inline_links = {
					icon = " ",
				},
				images = {
					icon = " ",
				},
			},
		})
	end,
}
