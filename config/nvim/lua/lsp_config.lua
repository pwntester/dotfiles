local vim = vim
local api = vim.api

local function on_attach_callback(_, bufnr)

    bufnr = bufnr or api.nvim_get_current_buf()

	-- filetype
	local ft = api.nvim_buf_get_option(bufnr, 'filetype')

    -- mappings
    local map = function(type, key, value)
	    vim.fn.nvim_buf_set_keymap(bufnr,type,key,value,{noremap = true, silent = true});
    end

    --map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n','gD','<cmd>lua require"lsp_callbacks".show_line_diagnostics()<CR>')
	map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	map('n','gh','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	map('n','ga','<cmd>lua vim.lsp.buf.code_action()<CR>')
	map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
	map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

    -- completion-nvim
    require'completion'.on_attach()
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
    local nvim_lsp = require 'nvim_lsp'
    local configs = require'nvim_lsp/configs'

    -- Lua
    nvim_lsp.sumneko_lua.setup{
        cmd = {
            "/Users/pwntester/repos/lua-language-server/bin/macOS/lua-language-server",
            "-E",
            "/Users/pwntester/repos/lua-language-server/main.lua",
        };
        on_attach = on_attach_callback;
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
                completion = { keywordSnippet = "Disable", },
                diagnostics = { enable = true, globals = {
                    "vim", "describe", "it", "before_each", "after_each" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    }
                }
            }
        }
    }

    -- Go
    nvim_lsp.gopls.setup{
        on_attach = on_attach_callback;
    }

    -- Clangd
    nvim_lsp.clangd.setup{
        on_attach = on_attach_callback;
    }

    -- CodeQL
    nvim_lsp.codeqlls.setup{
        on_attach = on_attach_callback;
        settings = {
            search_path = {'~/codeql-home/codeql-repo', '~/codeql-home/pwntester-repo', '~/codeql-home/codeql-go-repo'};
        };
    }

    -- Fortify Language Server
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

    -- Java Eclipse JDT
    local lsp4j_status_callback = function(_, _, result)
        api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
    end
    local root_pattern = nvim_lsp.util.root_pattern('.project', 'pom.xml', 'project.xml', 'build.gradle', '.git');
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

return {
	setup = setup;
}
