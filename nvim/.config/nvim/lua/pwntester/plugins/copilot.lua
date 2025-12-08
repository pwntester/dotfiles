return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	build = ":Copilot auth",
	opts = {
    panel = {
      enabled = false,
      auto_refresh = true,
    },
    suggestion = {
      enabled = false, -- handled by blink.nvim
      auto_trigger = true,
      accept = false, -- disable built-in keymapping
      hide_during_completion = false,
      keymap = {
        accept = "<Right>",
        accept_word = "<A-l>",
        accept_line = false,
        next = "<A-k>",
        prev = "<A-j>",
        dismiss = "<esc>",
      },
    },
  }
}
