local vim = vim
local api = vim.api
local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
local util = require 'vim.lsp.util'


local function on_attach_callback(_, bufnr)

	bufnr = bufnr or api.nvim_get_current_buf()

	-- mappings
	local map = function(type, key, value)
		vim.fn.nvim_buf_set_keymap(bufnr,type,key,value,{noremap = true, silent = true});
	end

	map('n','<Plug>(LspGotoDecl)','<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n','<Plug>(LspShowDiagnostics)','<cmd>lua require"lsp_config".show_line_diagnostics()<CR>')
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
	map('n','<Plug>(LspCodeActions)','<cmd>lua vim.lsp.buf.code_action()<CR>')
end

local function setup()

	-- diagnostics signs
	vim.g.LspDiagnosticsErrorSign = 'x'
	vim.g.LspDiagnosticsWarningSign = 'w'
	vim.g.LspDiagnosticsInformationSign = 'i'
	vim.g.LspDiagnosticsHintSign = 'h'

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = false,
      update_in_insert = false,
      underline = true,
      --virtual_text = true,
      virtual_text = {
        spacing = 4,
        prefix = '~',
      },
    }
  )

	-- custom callbacks
	vim.lsp.callbacks['textDocument/hover'] = function(_, _, result)
    if not (result and result.contents) then return end
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then return end
    require("window").popup_window(markdown_lines, 'markdown', {}, true)
  end

  vim.lsp.callbacks['textDocument/references'] = function(_, _, result)
    if not result then return end
    util.set_qflist(util.locations_to_items(result))
    api.nvim_command("botright copen")
    api.nvim_command("wincmd p")
  end

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

	--- Go
	nvim_lsp.gopls.setup{
		on_attach = on_attach_callback;
	}

	--- CodeQL
	nvim_lsp.codeqlls.setup{
		on_attach = on_attach_callback;
		settings = {
			search_path = vim.g.codeql_search_path;
		};
	}

	--- Fortify Language Server
	if not configs.fortify_lsp then
		configs.fortify_lsp = {
			default_config = {
				cmd = {'fls'};
				filetypes = {'fortifyrulepack'};
				root_dir = function(fname)
					return nvim_lsp.util.path.dirname(fname)
				end;
			};
		}
	end
	nvim_lsp.fortify_lsp.setup{
		on_attach = on_attach_callback;
	}

	--- Java Eclipse JDT
	local lsp4j_status_callback = function(_, _, result)
		api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
	end
	local root_pattern = nvim_lsp.util.root_pattern('.git') --, '.project', 'pom.xml', 'project.xml', 'build.gradle');
	if not configs.java_lsp then
		configs.java_lsp = {
			default_config = {
				cmd = {"jdtls"};
				filetypes = {'java'};
				root_dir = function(fname)
					return root_pattern(fname) or vim.loop.os_homedir()
				end;
			};
		}
	end
	nvim_lsp.java_lsp.setup{
		on_attach = on_attach_callback;
		callbacks = {
			["language/status"] = lsp4j_status_callback,
		};
	}

end

local function show_line_diagnostics()
  local lines = {'Diagnostics:'}
  local highlights = {{0, "Bold"}}
  local line_diagnostics = vim.lsp.util.get_line_diagnostics()
  if vim.tbl_isempty(line_diagnostics) then return end
  for i, diagnostic in ipairs(line_diagnostics) do
    local prefix = string.format("%d. ", i)
    local hiname = vim.lsp.util.get_severity_highlight_name(diagnostic.severity)
    assert(hiname, 'unknown severity: ' .. tostring(diagnostic.severity))
    local message_lines = vim.split(diagnostic.message, '\n', true)
    table.insert(lines, prefix..message_lines[1])
    table.insert(highlights, {#prefix + 1, hiname})
    for j = 2, #message_lines do
      table.insert(lines, message_lines[j])
      table.insert(highlights, {0, hiname})
    end
  end
  local popup_bufnr, winnr = require("window").popup_window(lines, 'plaintext', {}, true)
  return popup_bufnr, winnr
end

return {
	setup = setup;
  show_line_diagnostics = show_line_diagnostics;
}
