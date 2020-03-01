require 'nvim-lsp'

local api = vim.api

-- configure buffer after LSP client is attached
local function on_attach_callback(client, bufnr)
    api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gK", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gF", "<Cmd>lua vim.lsp.buf.formatting()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "ga", "<Cmd>lua request_code_actions()<CR>", { silent = true; })
    api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]] 
end

local function setup()

    local nvim_lsp = require 'nvim_lsp'
    local configs = require'nvim_lsp/configs'

    -- Go
    nvim_lsp.gopls.setup{}

    -- Clangd
    nvim_lsp.clangd.setup{}

    -- CodeQL 
    nvim_lsp.codeqlls.setup{
        on_attach = on_attach_callback;
        callbacks = { 
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback
        };
        settings = {
            search_path = {'~/codeql-home/codeql-repo', '~/codeql-home/pwntester-repo'};
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
    if not configs.java_lsp then
        configs.java_lsp = {
            default_config = {
                cmd = {"jdtls"};
                filetypes = {'java'};
                root_dir = function(fname)
                    return nvim_lsp.util.root_pattern('.project', 'pom.xml', 'project.xml', 'build.gradle', '.git');
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

--- @export
return {
	setup = setup;
}
