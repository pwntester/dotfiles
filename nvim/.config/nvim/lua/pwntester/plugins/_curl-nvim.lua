-- Opening any file with the ".curl" file extension will activate this plugins features.
-- JSON bodies do not have to be wrapped in quotes, making it easier to format JSON with JQ (va{:!jq)
-- You dont need a trailing \, but it won't matter if they are there, making it easier to copy-paste requests
-- Basic auth and bearer tokens work, and can be retrieved from environment variables
return {
	"oysandvik94/curl.nvim",
	cmd = { "CurlOpen" },
  enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	opts = {
		-- Table of strings to specify default headers to be included in each request, i.e. "-i"
		default_flags = {},
		-- Specify an alternative curl binary that will be used to run curl commands
		-- String of either full path, or binary in path
		curl_binary = nil,
		-- Specify how to open curl
		-- use "tab" to open in separate tab
		-- use "split" to open in horizontal split
		-- use "vsplit" to open in vertical split
		open_with = "tab",
		mappings = {
			execute_curl = "<CR>",
		},
	},
}
