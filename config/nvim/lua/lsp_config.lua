local vim = vim
local api = vim.api
local nvim_lsp = require 'nvim_lsp'
-- local configs  = require'nvim_lsp/configs'


local function on_attach_callback(_, bufnr)

	bufnr = bufnr or api.nvim_get_current_buf()

	-- mappings
	local map = function(type, key, value)
		vim.fn.nvim_buf_set_keymap(bufnr,type,key,value,{noremap = true, silent = true});
	end

	map('n','<Plug>(LspGotoDecl)','<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n','<Plug>(LspShowDiagnostics)','<cmd>lua require"lsp_callbacks".show_line_diagnostics()<CR>')
	map('n','<Plug>(LspGotoDef)','<cmd>lua vim.lsp.buf.definition()<CR>')
	map('n','<Plug>(LspHover)','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','<Plug>(LspShowReferences)','<cmd>lua vim.lsp.buf.references()<CR>')
	map('n','<Plug>(LspShowSignatureHelp)','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	map('n','<Plug>(LspGotoImpl)','<cmd>lua vim.lsp.buf.implementation()<CR>')
	map('n','<Plug>(LspGotoTypeDef)','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	map('n','<Plug><LspDocumentSymbol)','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	map('n','<Plug><LspWorkspaceSymbol)','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	map('n','<Plug>(LspRename)','<cmd>lua vim.lsp.buf.rename()<CR>')
	map('n','<Plug>(LspFormat)', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	map('n','<Plug>(LspIncomingCalls)','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	map('n','<Plug>(LspOutgoingCalls)','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
	map('n','<Plug>(LspCodeActions)','<cmd>lua require("jdtls").code_action()<CR>')
	map('v','<Plug>(LspVisualCodeActions)','<esc><cmd>lua require("jdtls").code_action(true)<CR>')

	if vim.bo[bufnr].ft == 'java' then
		-- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
		-- use this mapping also with other language servers
		map('n','<Plug>(LspRefactor)','<cmd>lua require("jdtls").code_action(false, "refactor")<CR>')
		map('n','<Plug>(LspOrganizeImports)','<cmd>lua require("jdtls").organize_imports()<CR>')
		map('n','<Plug>(LspExtractVar)','<cmd>lua require("jdtls").extract_variable()<CR>')
		map('n','<Plug>(LspExtractMethod)','<cmd>lua require("jdtls").extract_method()<CR>')
		map('v','<Plug>(VisualLspExtractVar)','<esc><cmd>lua require("jdtls").extract_variable(true)<CR>')
		map('v','<Plug>(VisualLspExtractMethod)','<esc><cmd>lua require("jdtls").extract_method(true)<CR>')
	end

end

local function setup()

	-- diagnostics signs
	vim.g.LspDiagnosticsErrorSign = 'x'
	vim.g.LspDiagnosticsWarningSign = 'w'
	vim.g.LspDiagnosticsInformationSign = 'i'
	vim.g.LspDiagnosticsHintSign = 'h'

	-- custom callbacks
	vim.lsp.callbacks["textDocument/publishDiagnostics"] = require'lsp_callbacks'.diagnostics_callback
	vim.lsp.callbacks["textDocument/hover"] = require'lsp_callbacks'.hover_callback

	-- statusline
	vim.cmd [[ autocmd User LspDiagnosticsChanged lua statusline.active() ]]

	-- language servers

	--- Lua
	nvim_lsp.sumneko_lua.setup{
		cmd = {
			"/Users/pwntester/repos/lua-language-server/bin/macOS/lua-language-server",
			"-E",
			"/Users/pwntester/repos/lua-language-server/main.lua",
		};
		on_attach = on_attach_callback;
		settings = {
			Lua = {
				completion = { keywordSnippet = "Disable", },
				diagnostics = { enable = true, globals = {
					"vim", "describe", "it", "before_each", "after_each" },
				},
	      runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					}
				}
			}
		}
	}
	--vim.cmd [[ autocmd VimLeave * call system('killall lua-language-server') ]]

	--- Go
	nvim_lsp.gopls.setup{
		on_attach = on_attach_callback;
	}

	--- Clangd
	nvim_lsp.clangd.setup{
		on_attach = on_attach_callback;
	}

	--- CodeQL
	nvim_lsp.codeqlls.setup{
		on_attach = on_attach_callback;
		settings = {
			search_path = {'~/codeql-home/codeql-repo', '~/codeql-home/pwntester-repo', '~/codeql-home/codeql-go-repo'};
		};
	}

	--- Fortify Language Server
	-- if not configs.fortify_lsp then
	-- 	configs.fortify_lsp = {
	-- 		default_config = {
	-- 			cmd = {'fls'};
	-- 			filetypes = {'fortifyrulepack'};
	-- 			root_dir = function(fname)
	-- 				return nvim_lsp.util.path.dirname(fname)
	-- 			end;
	-- 		};
	-- 	}
	-- end
	-- nvim_lsp.fortify_lsp.setup{
	-- 	on_attach = on_attach_callback;
	-- }

	--- Java Eclipse JDT
	-- local lsp4j_status_callback = function(_, _, result)
	-- 	api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
	-- end
	-- local root_pattern = nvim_lsp.util.root_pattern('.project', 'pom.xml', 'project.xml', 'build.gradle', '.git');
	-- if not configs.java_lsp then
	-- 	configs.java_lsp = {
	-- 		default_config = {
	-- 			cmd = {"jdtls"};
	-- 			filetypes = {'java'};
	-- 			root_dir = function(fname)
	-- 				return root_pattern(fname) or vim.loop.os_homedir()
	-- 			end;
	-- 		};
	-- 	}
	-- end
	-- nvim_lsp.java_lsp.setup{
	-- 	on_attach = on_attach_callback;
	-- 	callbacks = {
	-- 		["language/status"] = lsp4j_status_callback,
	-- 	};
	-- }

	--vim.cmd [[ au FileType java lua require('lsp_config').jdtls() ]]
end

local function jdtls()
	local root_pattern = nvim_lsp.util.root_pattern('.project', 'pom.xml', 'project.xml', 'build.gradle', '.git');
	require('jdtls').start_or_attach({
			cmd={'jdtls'};
			filetypes = {'java'};
			root_dir = function(fname)
				return root_pattern(fname) or vim.loop.os_homedir()
			end;
			on_attach = on_attach_callback;
		})
end

return {
	setup = setup;
	jdtls = jdtls;
}
