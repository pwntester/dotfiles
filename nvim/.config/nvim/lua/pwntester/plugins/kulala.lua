return {
	{
		"mistweaverco/kulala.nvim",
		branch = "develop",
		keys = {
			{
				"<C-s>",
				function()
					require("kulala").run()
				end,
				mode = { "n" },
				ft = "http",
				desc = "Send request",
			},
			{
				"<C-a>",
				function()
					require("kulala").run_all()
				end,
				mode = { "n" },
				ft = "http",
				desc = "Send all request",
			},
		},
		ft = { "http", "rest" },
		config = function()
			require("kulala").setup({
				global_keymaps = false,
				curl_path = "curl",
				additional_curl_options = { "--insecure", "-A", "Mozilla/5.0", "-L" },
				grpcurl_path = "grpcurl",
				websocat_path = "websocat",
				openssl_path = "openssl",
				ui = {
					-- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
					default_view = "verbose",
				},
			})
			vim.filetype.add({
				extension = {
					["http"] = "http",
				},
			})
		end,
	},
}
