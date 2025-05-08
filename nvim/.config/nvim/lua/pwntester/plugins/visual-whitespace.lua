return {
	"mcauley-penney/visual-whitespace.nvim",
	keys = { "v", "V", "<C-v>" },
	config = true,
	opts = {
		highlight = { link = "Visual" },
		space_char = "·",
		tab_char = "→",
		nl_char = "↲",
		cr_char = "←",
		enabled = true,
		excluded = {
			filetypes = {},
			buftypes = {},
		},
	},
}
