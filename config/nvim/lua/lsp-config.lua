require 'util'
require 'nvim-lsp'

local lsps_actions = {}
local lsps_dirs = {}
local lsps_diagnostics = {}
local lsps_diagnostics_count = {}
local references_ns = vim.api.nvim_create_namespace("vim_lsp_references")

-- clear diagnostics namespace
-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L506
local function buf_clear_diagnostics(bufnr)
    validate { bufnr = {bufnr, 'n', true} }
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    -- clear signs
    vim.fn.sign_unplace('nvim-lsp', {buffer=bufnr})

    -- clear virtual text namespace
    vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

-- underline code with diagnostics
-- modified from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L593
local function buf_diagnostics_underline(bufnr, diagnostics)
    for _, diagnostic in ipairs(diagnostics) do
      local start = diagnostic.range.start
      local finish = diagnostic.range["end"]

      -- workaround for fls
      if start.character == 1 and finish.character == 100 then return end

      highlight_range(bufnr, diagnostic_ns, underline_highlight_name,
          {start.line, start.character},
          {finish.line, finish.character}
      )
    end
end

-- show diagnostics as virtual text
-- modified from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L606
function buf_diagnostics_virtual_text(bufnr, diagnostics)
    -- return if we are called from a window that is not showing bufnr
    if vim.api.nvim_win_get_buf(0) ~= bufnr then return end

    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        buf_diagnostics_save_positions(bufnr, diagnostics)
    end
    buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        return
    end
    local line_no = vim.api.nvim_buf_line_count(bufnr)
    for _, line_diags in pairs(buffer_line_diagnostics) do

        line = line_diags[1].range.start.line
        if line+1 > line_no then goto continue end

        local virt_texts = {}

        -- window total width
        local win_width = vim.api.nvim_win_get_width(0)

        -- line length
        local lines = vim.api.nvim_buf_get_lines(bufnr, line, line+1, 0)
        local line_width = 0
        if table.getn(lines) > 0 then
            local line_content = lines[1]
            if line_content == nil then goto continue end
            line_width = vim.fn.strdisplaywidth(line_content)
        end

        -- window decoration with (sign + fold + number)
        local decoration_width = window_decoration_columns()

        -- available space for virtual text
        local right_padding = 1
        local available_space = win_width - decoration_width - line_width - right_padding

        -- virtual text 
        local last = line_diags[#line_diags]
        local message = "■ "..last.message:gsub("\r", ""):gsub("\n", "  ") 

        -- more than one diagnostic in line
        if #line_diags > 1 then
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..'■', severity_highlights[line_diags[1].severity]})
            for i = 2, #line_diags - 1 do
                table.insert(virt_texts, {'■', severity_highlights[line_diags[i].severity]})
            end
            table.insert(virt_texts, {message, severity_highlights[last.severity]})
        -- 1 diagnostic in line
        else 
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..message, severity_highlights[last.severity]})
        end
        vim.api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
        ::continue::
    end
end

-- show diagnostics in a number of ways
local function buf_show_diagnostics(bufnr)
    if not lsps_diagnostics[bufnr] then return end
    buf_clear_diagnostics(bufnr)
    buf_diagnostics_save_positions(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_underline(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_virtual_text(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_statusline(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_signs(bufnr, lsps_diagnostics[bufnr])
end

-- prepare range params
local function make_range_params()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
  col = vim.str_utfindex(line, col)
  return {
    textDocument = { uri = vim.uri_from_bufnr(0) };
    range = { ["start"] = { line = row, character = col }, ["end"] = { line = row, character = (col + 1) } }
  }
end

-- unfortunately no way to make FZF to call back into lua code
-- function ApplyAction(arg)
--     print(dump(arg))
-- end
-- function FZF_menu(raw_options)
--     local fzf_options = {}
--     for idx, option in ipairs(raw_options) do
--         table.insert(fzf_options, string.format('%d::%s', idx, option.title))
--     end
--     local fzf_config = {
--         source = fzf_options,
--         sink = 'v:lua.ApplyAction',
--         options = "+m --with-nth 2.. -d ::"
--     }
--     vim.fn['fzf#run'](vim.fn['fzf#wrap'](fzf_config))
-- end

-- clear reference highlighting
function clear_references() 
    vim.api.nvim_buf_clear_namespace(0, references_ns, 0, -1)
end

-- highlight references for symbol under cursor
function highlight_references() 
    if not get_lsp_client_capability("documentHighlightProvider") then return end
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local callback = vim.schedule_wrap(function(_, _, result)
        if not result then return end
        for _, reference in ipairs(result) do
            local start_pos = {reference["range"]["start"]["line"], reference["range"]["start"]["character"]}
            local end_pos = {reference["range"]["end"]["line"], reference["range"]["end"]["character"]}
            if reference["kind"] == 1 then
                -- TEXT
                highlight_range(bufnr, references_ns, "LspReferenceText", start_pos, end_pos)
            elseif reference["kind"] == 2 then
                -- READ
                highlight_range(bufnr, references_ns, "LspReferenceRead", start_pos, end_pos)
            elseif reference["kind"] == 3 then
                -- WRITE
                highlight_range(bufnr, references_ns, "LspReferenceWrite", start_pos, end_pos)
            end
        end
    end)
    vim.lsp.buf_request(0, 'textDocument/documentHighlight', params, callback)
end

-- apply selected codeAction. global to be called from vimL
function apply_code_action(selection)
    local command = lsps_actions[selection]['command']['command']
    local arguments = lsps_actions[selection]['command']['arguments']
    local edit = lsps_actions[selection]['command']['edit']
    local title = lsps_actions[selection]['command']['title']

    if command == 'java.apply.workspaceEdit' then
        -- eclipse.jdt.ls does not follow spec here
        for _, argument in ipairs(arguments) do
            for _, change in ipairs(argument['documentChanges']) do
                local bufnr = vim.fn.bufadd((vim.uri_to_fname(change['textDocument']['uri'])))
                apply_text_edits(change['edits'], bufnr)
            end
        end
    elseif command then
        local callback = vim.schedule_wrap(function(_, _, result)
            if not result then return end
            vim.api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result))
        end)
        vim.lsp.buf_request(0, 'workspace/executeCommand', { command = command, arguments = arguments }, callback)
    elseif edit then
        -- TODO: not tested 
        local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
        apply_text_edits(edit, bufnr)
    end
end

-- send codeAction request. global to be called from mapping
function request_code_actions()
    -- JDT does not publish it
    -- if not get_lsp_client_capability("completionProvider") then return end
    local bufnr = vim.api.nvim_get_current_buf()
    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        buf_diagnostics_save_positions(bufnr, diagnostics)
    end
    buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        return
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    local line_diagnostics = buffer_line_diagnostics[row]
 
    local params = make_range_params()
    params.context = { diagnostics = line_diagnostics }
    local callback = vim.schedule_wrap(function(_, _, actions)
        if not actions then return end
        lsps_actions = actions
        -- FZF_menu(lsps_actions)
        vim.fn[vim.g.nvim_lsp_code_action_menu](lsps_actions, 'v:lua.apply_code_action')
    end)
    vim.lsp.buf_request(0, 'textDocument/codeAction', params, callback)
end

-- show diagnostics in sign column
function buf_diagnostics_signs(bufnr, diagnostics)
    for _, diagnostic in ipairs(diagnostics) do
        -- errors
        if diagnostic.severity == 1 then
            vim.fn.sign_place(0, 'nvim-lsp', 'LspErrorSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
        -- warnings
        elseif diagnostic.severity == 2 then
            vim.fn.sign_place(0, 'nvim-lsp', 'LspWarningSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
        -- info
        elseif diagnostic.severity == 3 then
            vim.fn.sign_place(0, 'nvim-lsp', 'LspInfoSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
        -- hint
        elseif diagnostic.severity == 4 then
            vim.fn.sign_place(0, 'nvim-lsp', 'LspHintSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
        end
    end
end

-- collect metrics for status line
function buf_diagnostics_statusline(bufnr, diagnostics)
    lsps_diagnostics_count[bufnr] = { errors=0, warnings=0 }
    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity == 2 then
            lsps_diagnostics_count[bufnr]['warnings'] = lsps_diagnostics_count[bufnr]['warnings'] + 1
        elseif diagnostic.severity == 1 then
            lsps_diagnostics_count[bufnr]['errors'] = lsps_diagnostics_count[bufnr]['errors'] + 1
        end
    end

    -- update statusline
    vim.api.nvim_command("call lightline#update()")
end

-- show popup with line diagnostics. global so can be called from mapping
function show_diagnostics_details()
    local _, winnr = show_line_diagnostics()
    if winnr ~= nil then
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
        vim.api.nvim_win_set_option(winnr, "winhl", "Normal:PMenu")
    end
end

-- returns number if diagnostics. global so can be called from lightline
function get_lsp_diagnostic_metrics()
    local bufnr = vim.api.nvim_get_current_buf()
    return lsps_diagnostics_count[bufnr]
end

-- returns true if LSP server is ready. global so can be called from lightline
function get_lsp_client_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local status, client_id = pcall(get_buf_var, bufnr, "lsp_client_id")
    if type(client_id) == "number" then
        local client = vim.lsp.get_client_by_id(client_id)
        if client ~= nil then
            if client.notify("window/progress", {}) then
                return true
            end
        end
    end
    return false
end

-- check if LSP server implements capability
function get_lsp_client_capability(capability)
    local bufnr = vim.api.nvim_get_current_buf()
    local status, client_id = pcall(get_buf_var, bufnr, "lsp_client_id")
    if type(client_id) == "number" then
        local client = vim.lsp.get_client_by_id(client_id)
        if client and client.server_capabilities[capability] == true then
            return true
        end
    end
    return false
end

-- configure client capabilities
local function config_client_callback(initialize_params, config)

    -- needed by qlls
    initialize_params['workspaceFolders'] = {{
        name = 'workspace',
        uri = initialize_params['rootUri']
    }}

    -- yes we can!
    initialize_params['capabilities']['workspace'] = {
        applyEdit = true,
        workspaceEdit = {
            documentChanges = true,
            resourceOperations = { "create", "rename", "delete" },
            failureHandling = "textOnlyTransactional",
        },
        didChangeConfiguration = {
            dynamicRegistration = true
        },
        didChangeWatchedFiles = {
            dynamicRegistration = true
        },
        symbol = {
            dynamicRegistration = true,
            symbolKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            }
        },
        executeCommand = {
            dynamicRegistration = true
        },
        configuration = true,
        workspaceFolders = true
    }
    initialize_params['capabilities']['textDocument'] = {
        publishDiagnostics = {
            relatedInformation = true
        },
        completion = {
            dynamicRegistration = true,
            contextSupport = true,
            completionItem = {
                snippetSupport = true,
                commitCharactersSupport = true,
                documentationFormat = { "markdown", "plaintext" },
                deprecatedSupport = true,
                preselectSupport = true
            },
            completionItemKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            }
        },
        hover = {
            dynamicRegistration = true,
            contentFormat = { "markdown", "plaintext" }
        },
        signatureHelp = {
            dynamicRegistration = true,
            signatureInformation = {
                documentationFormat = { "markdown", "plaintext" },
                parameterInformation = {
                    labelOffsetSupport = true
                }
            }
        },
        definition = {
            dynamicRegistration = true,
            linkSupport = true
        },
        references = {
            dynamicRegistration = true
        },
        documentHighlight = {
            dynamicRegistration = true
        },
        documentSymbol = {
            dynamicRegistration = true,
            symbolKind = {
                valueSet = {1 ,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}
            },
            hierarchicalDocumentSymbolSupport = true
        },
        codeAction = {
            dynamicRegistration = true,
            codeActionLiteralSupport = {
                codeActionKind = {
                    valueSet = { 
                        "",
                        "quickfix",
                        "refactor", 
                        "refactor.extract", 
                        "refactor.inline", 
                        "refactor.rewrite", 
                        "source", 
                        "source.organizeImports"
                    }
                }
            }
        },
        codeLens = {
            dynamicRegistration = true
        },
        formatting = {
            dynamicRegistration = true
        },
        rangeFormatting = {
            dynamicRegistration = true
        },
        onTypeFormatting = {
            dynamicRegistration = true
        },
        rename = {
            dynamicRegistration = true,
            prepareSupport = true
        },
        documentLink = {
            dynamicRegistration = true
        },
        typeDefinition = {
            dynamicRegistration = true,
            linkSupport = true
        },
        implementation = {
            dynamicRegistration = true,
            linkSupport = true
        },
        colorProvider = {
            dynamicRegistration = true
        },
        foldingRange = {
            dynamicRegistration = true,
            rangeLimit = 5000,
            lineFoldingOnly = true
        },
        declaration = {
            dynamicRegistration = true,
            linkSupport = true
        }
    }
end

-- debug initialization, show server capabilities
local function debug_init(client, result)
    print("INIT")
    print(dump(result))
end

-- configure buffer after LSP client is attached
local function on_attach_callback(client, bufnr)
    vim.api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)

    -- mappings and settings
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true; })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true; })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true; })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", "<Cmd>lua request_code_actions()<CR>", { silent = true; })
    vim.api.nvim_command [[autocmd CursorHold <buffer> lua highlight_references()]]
    vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua highlight_references()]]
    vim.api.nvim_command [[autocmd CursorMoved <buffer> lua clear_references()]]
end

-- custom replacement for publishDiagnostics callback
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
local function diagnostics_callback(_, _, result)
    if not result then return end
    local uri = result.uri
    local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
    if not bufnr then
        api.nvim_err_writeln(string.format("LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
        return
    end
    lsps_diagnostics[bufnr] = result.diagnostics
    buf_show_diagnostics(bufnr)
end

local function setup()

    -- define signs
    if not sign_defined then
        vim.fn.sign_define('LspErrorSign', {text='x', texthl='LspDiagnosticsError', linehl='', numhl=''})
        vim.fn.sign_define('LspWarningSign', {text='x', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
        vim.fn.sign_define('LspInfoSign', {text='x', texthl='LspDiagnosticsInfo', linehl='', numhl=''})
        vim.fn.sign_define('LspHintSign', {text='x', texthl='LspDiagnosticsHint', linehl='', numhl=''})
        sign_defined = true
    end

    -- in case I'm reloading.
    vim.lsp.stop_all_clients()

    function start_fls()
        -- prevent LSP on large files
        if vim.api.nvim_buf_line_count(0) > 10000 then return end

        local root_dir = vim.fn.expand('%:p:h')
        local config = {
            name = "fortify-language-server";
            cmd = "fls";
            root_dir = root_dir;
            callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
            on_attach = on_attach_callback;
            before_init = config_client_callback;
            -- on_init = debug_init;
        }
        local bufnr = vim.api.nvim_get_current_buf()
        local status, client_id = pcall(get_buf_var, bufnr, "lsp_client_id")
        if type(client_id) ~= "number" then
            client_id = vim.lsp.start_client(config)
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_qlls()
        local search_path = vim.fn.expand(vim.g.LSP_qlls_search_path)
        if not search_path then return end
        local root_dir = root_pattern(bufnr, "qlpack.yml");
        if not root_dir then 
            local root_dir = vim.fn.expand('%:p:h')
        end
        local config = {
            name = "codeql-language-server";
            cmd = "codeql execute language-server --check-errors ON_CHANGE -q --search-path="..search_path;
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback
            };
            on_attach = on_attach_callback;
            before_init = config_client_callback;
            -- on_init = debug_init;
        }
        -- capabilities:
        --  definitionProvider - The server provides goto definition support.
        --  completionProvider - The server provides completion support.
        --  hoverProvider - The server provides hover support.
        --  documentSymbolProvider - The server provides document symbol support.
        --  documentHighlightProvider - The server provides document highlight support.
        --  documentFormattingProvider - The server provides document formatting.
        --      TODO: https://microsoft.github.io/language-server-protocol/specifications/specification-3-14/#textDocument_formatting
        --  referencesProvider - The server provides find references support.
        --      TODO: https://microsoft.github.io/language-server-protocol/specifications/specification-3-14/#textDocument_references
        --  experimental.guessLocationProvider 
        --  experimental.checkErrorsProvider  
        local bufnr = vim.api.nvim_get_current_buf()
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_gopls()
        local bufnr = vim.api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "go.mod", ".git");
        if not root_dir then return end
        local config = {
            name = "gopls";
            cmd = "gopls";
            root_dir = root_dir;
            callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
            on_attach = on_attach_callback;
            before_init = config_client_callback;
            -- on_init = debug_init;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_jdt()
        local bufnr = vim.api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "pom.xml", "build.gradle");
        if not root_dir then return end
        local lsp4j_status_callback = vim.schedule_wrap(function(_, _, result)
            vim.api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
        end)
        local config = {
            name = "eclipse.jdt.ls";
            cmd = "jdtls";
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["language/status"] = lsp4j_status_callback,
            };
            on_attach = on_attach_callback;
            before_init = config_client_callback;
            on_init = debug_init;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_clangd()
        local bufnr = vim.api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "compile_commands.json", "compile_flags.txt", ".git");
        if not root_dir then return end
        local config = {
            name = "clangd";
            cmd = "/usr/local/opt/llvm/bin/clangd --background-index";
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
            };
            on_attach = on_attach_callback;
            before_init = config_client_callback;
            -- on_init = debug_init;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    -- autocommands
    vim.api.nvim_command [[autocmd Filetype fortifyrulepack lua start_fls()]]
    vim.api.nvim_command [[autocmd Filetype java lua start_jdt()]]
    vim.api.nvim_command [[autocmd Filetype codeql lua start_qlls()]]
    vim.api.nvim_command [[autocmd Filetype go lua start_gopls()]]
    vim.api.nvim_command [[autocmd Filetype c,cpp,objc lua start_clangd()]]

end

--- @export
return {
	setup = setup;
}

