return {
	"greggh/claude-code.nvim",
  enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
			-- Terminal window settings
			window = {
				height_ratio = 0.3, -- Percentage of screen height for the terminal window
				position = "botright", -- Position of the window: "botright", "topleft", etc.
				enter_insert = true, -- Whether to enter insert mode when opening Claude Code
				hide_numbers = true, -- Hide line numbers in the terminal window
				hide_signcolumn = true, -- Hide the sign column in the terminal window
			},
			-- File refresh settings
			refresh = {
				enable = true, -- Enable file change detection
				updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
				timer_interval = 1000, -- How often to check for file changes (milliseconds)
				show_notifications = true, -- Show notification when files are reloaded
			},
			-- Git project settings
			git = {
				use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
			},
			-- Keymaps
			keymaps = {
				toggle = {
					normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
					terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
				},
				window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
				scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
			},
		})
	end,
}
