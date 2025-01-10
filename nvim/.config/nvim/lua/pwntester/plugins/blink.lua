return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	-- dependencies = 'rafamadriz/friendly-snippets',

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		--
		-- keymap = { preset = "default" },
		keymap = {
			preset = "enter",
			["<C-y>"] = { "accept", "select_and_accept" },
			--["<C-y>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "fallback" }, -- snippets
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<C-l>"] = { "show", "hide", "fallback" },
			["<C-_>"] = { "cancel", "fallback" },
			["<C-Space>"] = { "show_documentation", "hide_documentation", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lsp", "path", "buffer" },
			cmdline = {},
		},
	},
	-- allows extending the providers array elsewhere in your config
	-- without having to redefine it
	opts_extend = { "sources.default" },
}
