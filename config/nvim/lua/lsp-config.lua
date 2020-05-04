require 'nvim-lsp'

local vim = vim
local api = vim.api

-- configure buffer after LSP client is attached
local function on_attach_callback(_, bufnr)
    api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gF", "<Cmd>lua format_document()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "ga", "<Cmd>lua request_code_actions()<CR>", { silent = true; })
    api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.hover() ]]
    api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.hover() ]]
    --api.nvim_command [[autocmd Filetype lua setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
    local ft = api.nvim_buf_get_option(bufnr, 'filetype')
    -- disable LSP highlighted for TS enabled buffers (completion-treesitter)
    if ft ~= 'ql' and ft ~= 'lua' then
        api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
        api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
        api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]]
    end
end

local function setup()

    local nvim_lsp = require 'nvim_lsp'
    local configs = require'nvim_lsp/configs'

    nvim_lsp.sumneko_lua.setup{
        cmd = {
            "/Users/pwntester/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
            "-E",
            "/Users/pwntester/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua"
        };
        on_attach = on_attach_callback;
        callbacks = {
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback,
            ["textDocument/formatting"] = formatting_callback
        };
    }
    -- Go
    nvim_lsp.gopls.setup{
        on_attach = on_attach_callback;
        callbacks = {
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback,
            ["textDocument/formatting"] = formatting_callback
        };
    }

    -- Clangd
    nvim_lsp.clangd.setup{
        on_attach = on_attach_callback;
        callbacks = {
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback,
            ["textDocument/formatting"] = formatting_callback
        };
    }

    -- CodeQL
    nvim_lsp.codeqlls.setup{
        on_attach = on_attach_callback;
        callbacks = {
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback,
            ["textDocument/formatting"] = formatting_callback
        };
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
        callbacks = {
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback
        };
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
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback
        };
    }
end

return {
	setup = setup;
}
