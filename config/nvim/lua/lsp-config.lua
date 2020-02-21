require 'util'
require 'window'
require 'nvim-lsp'

local validate = vim.validate
local api = vim.api
local protocol = require 'vim.lsp.protocol'
local util = require 'vim.lsp.util'

local lsps_actions = {}
local lsps_dirs = {}
local all_buffer_diagnostics = {}

local reference_ns = api.nvim_create_namespace("vim_lsp_references")

-- clear diagnostics namespace
-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L506
local function buf_clear_diagnostics(bufnr)
    validate { bufnr = {bufnr, 'n', true} }
    bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr

    -- clear signs
    vim.fn.sign_unplace('nvim-lsp', {buffer=bufnr})

    -- clear virtual text namespace
    api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

function buf_cache_diagnostics(bufnr, diagnostics)
    validate {
        bufnr = {bufnr, 'n', true};
        diagnostics = {diagnostics, 't', true};
    }
    if not diagnostics then return end

    buffer_diagnostics = {}

    for _, diagnostic in ipairs(diagnostics) do
        local start = diagnostic.range.start
        -- local mark_id = api.nvim_buf_set_extmark(bufnr, diagnostic_ns, 0, start.line, 0, {})
        -- buffer_diagnostics[mark_id] = diagnostic
        local line_diagnostics = buffer_diagnostics[start.line]
        if not line_diagnostics then line_diagnostics = {} end
        table.insert(line_diagnostics, diagnostic)
        buffer_diagnostics[start.line] = line_diagnostics
    end
    all_buffer_diagnostics[bufnr] = buffer_diagnostics

end

-- show diagnostics as virtual text
-- modified from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L606
function buf_diagnostics_virtual_text(bufnr, diagnostics)
    -- return if we are called from a window that is not showing bufnr
    if api.nvim_win_get_buf(0) ~= bufnr then return end

    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    local line_no = api.nvim_buf_line_count(bufnr)
    for _, line_diags in pairs(all_buffer_diagnostics[bufnr]) do

        line = line_diags[1].range.start.line
        if line+1 > line_no then goto continue end

        local virt_texts = {}

        -- window total width
        local win_width = api.nvim_win_get_width(0)

        -- line length
        local lines = api.nvim_buf_get_lines(bufnr, line, line+1, 0)
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
        api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
        ::continue::
    end
end

-- clear reference highlighting
function clear_references() 
    api.nvim_buf_clear_namespace(0, reference_ns, 0, -1)
end

-- highlight references for symbol under cursor
function highlight_references() 
    local bufnr = api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local callback = vim.schedule_wrap(function(_, _, result)
        if not result then return end
        for _, reference in ipairs(result) do
            local start_pos = {reference["range"]["start"]["line"], reference["range"]["start"]["character"]}
            local end_pos = {reference["range"]["end"]["line"], reference["range"]["end"]["character"]}
            local document_highlight_kind = {
                [protocol.DocumentHighlightKind.Text] = "LspReferenceText";
                [protocol.DocumentHighlightKind.Read] = "LspReferenceRead";
                [protocol.DocumentHighlightKind.Write] = "LspReferenceWrite";
            }
            highlight_range(bufnr, reference_ns, document_highlight_kind[reference["kind"]], start_pos, end_pos)
        end
    end)
    vim.lsp.buf_request(0, 'textDocument/documentHighlight', params, callback)
end

-- prepare range params
local function make_range_params()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  row = row - 1
  local line = api.nvim_buf_get_lines(0, row, row+1, true)[1]
  col = vim.str_utfindex(line, col)
  return {
    textDocument = { uri = vim.uri_from_bufnr(0) };
    range = { ["start"] = { line = row, character = col }, ["end"] = { line = row, character = (col + 1) } }
  }
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
        vim.lsp.buf_request(0, 'workspace/executeCommand', { command = command, arguments = arguments })
    elseif edit then
        -- TODO: not tested 
        local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
        apply_text_edits(edit, bufnr)
    end
end

-- send codeAction request. global to be called from mapping
function request_code_actions()
    local bufnr = api.nvim_get_current_buf()
    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        buf_diagnostics_save_positions(bufnr, diagnostics)
    end
    buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        return
    end
    local row, col = unpack(api.nvim_win_get_cursor(0))
    row = row - 1
    local line_diagnostics = buffer_line_diagnostics[row]
 
    local params = make_range_params()
    params.context = { diagnostics = line_diagnostics }
    local callback = vim.schedule_wrap(function(_, _, actions)
        if not actions then return end
        lsps_actions = actions
        vim.fn[vim.g.nvim_lsp_code_action_menu](lsps_actions, 'v:lua.apply_code_action')
    end)
    vim.lsp.buf_request(0, 'textDocument/codeAction', params, callback)
end

-- show diagnostics in sign column
function buf_diagnostics_signs(bufnr, diagnostics)
    for _, diagnostic in ipairs(diagnostics) do
      local diagnostic_severity_map = {
        [protocol.DiagnosticSeverity.Error] = "LspDiagnosticsErrorSign";
        [protocol.DiagnosticSeverity.Warning] = "LspDiagnosticsWarningSign";
        [protocol.DiagnosticSeverity.Information] = "LspDiagnosticsInformationSign";
        [protocol.DiagnosticSeverity.Hint] = "LspDiagnosticsHintSign";
      }
      vim.fn.sign_place(0, sign_ns, diagnostic_severity_map[diagnostic.severity], bufnr, {lnum=(diagnostic.range.start.line+1)})
    end
end

-- show popup with line diagnostics. global so can be called from mapping
function show_diagnostics_details()
    local bufnr = api.nvim_get_current_buf()
    local line = api.nvim_win_get_cursor(0)[1] - 1
    local lines = {}
    local highlights = {{0, "Bold"}}
    local buffer_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_diagnostics then return end
    local line_diagnostics = buffer_diagnostics[line]
    if not line_diagnostics then return end
    for i, diagnostic in ipairs(line_diagnostics) do
      local prefix = string.format("%d. ", i)
      local hiname = severity_highlights[diagnostic.severity]
      local message_lines = vim.split(diagnostic.message, '\n', true)
      table.insert(lines, prefix..message_lines[1])
      table.insert(highlights, {#prefix + 1, hiname})
      for j = 2, #message_lines do
        table.insert(lines, message_lines[j])
        table.insert(highlights, {0, hiname})
      end
    end
    require("window").popup_window(lines, 'plaintext', {}, true)
end

-- returns true if LSP server is ready. global so can be called from statusline
function server_ready()
    local bufnr = api.nvim_get_current_buf()
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

-- returns number of diagnostics. global so can be called from statusline
function buf_diagnostics_count(kind)
  local bufnr = api.nvim_get_current_buf()
  buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
  if not buffer_line_diagnostics then return '-' end
  local count = 0
  for _, line_diags in pairs(buffer_line_diagnostics) do
    for _, diag in ipairs(line_diags) do
      if protocol.DiagnosticSeverity[kind] == diag.severity then count = count + 1 end
    end
  end
  return count
end

local function hover_callback(_, method, result)
  if not (result and result.contents) then return end
  local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then return end
  require("window").popup_window(markdown_lines, 'markdown', {}, true)
end

-- debug initialization, show server capabilities
local function init_callback(client, result)
    -- print("INIT")
    -- print(dump(result))
end

-- configure buffer after LSP client is attached
local function on_attach_callback(client, bufnr)
    api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)

    -- mappings and settings
    api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n",  "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "ga", "<Cmd>lua request_code_actions()<CR>", { silent = true; })
    api.nvim_buf_set_keymap(bufnr, "n", "gF", "<Cmd>lua vim.lsp.buf.formatting()<CR>", { silent = true; })
    -- pre-PR version
    api.nvim_command [[autocmd CursorHold <buffer> lua highlight_references()]]
    api.nvim_command [[autocmd CursorHoldI <buffer> lua highlight_references()]]
    api.nvim_command [[autocmd CursorMoved <buffer> lua clear_references()]]
    -- PR version 
    -- api.nvim_command [[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]]
    -- api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    -- api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    
    -- peek_definition()
    -- declaration()
    -- type_definition()
    -- formatting(options)
    -- range_formatting(options, start_pos, end_pos)
    -- rename(new_name)
    -- references(context)

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

  -- clear hl and signcolumn namespaces
  buf_clear_diagnostics(bufnr)

  -- underline diagnosticed code
  local ft = api.nvim_buf_get_option(bufnr, "filetype")
  if ft ~= "fortifyrulepack" then
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
  end

  -- add marks to signcolumn
  buf_diagnostics_signs(bufnr, result.diagnostics)

  -- cache diagnostics so they are available for codeactions and statusline counts
  buf_cache_diagnostics(bufnr, result.diagnostics)

  --custom virtual text uses diagnostics cache so need to go after
  buf_diagnostics_virtual_text(bufnr, result.diagnostics)

  -- notify user we are done processing diagnostics
  api.nvim_command("doautocmd User LspDiagnosticsChanged")
end

do
    -- define signs
    if not sign_defined then
        vim.fn.sign_define('LspDiagnosticsErrorSign', {text='x', texthl='LspDiagnosticsError', linehl='', numhl=''})
        vim.fn.sign_define('LspDiagnosticsWarningSign', {text='x', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
        vim.fn.sign_define('LspDiagnosticsInformationSign', {text='x', texthl='LspDiagnosticsInfo', linehl='', numhl=''})
        vim.fn.sign_define('LspDiagnosticsHintSign', {text='x', texthl='LspDiagnosticsHint', linehl='', numhl=''})
        sign_defined = true
    end
end

local function setup()

    function start_fls()
        -- prevent LSP on large files
        if api.nvim_buf_line_count(0) > 10000 then return end

        local root_dir = vim.fn.expand('%:p:h')
        local config = {
            name = "fortify-language-server";
            cmd = {"fls"};
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["textDocument/hover"] = hover_callback
            };
            on_attach = on_attach_callback;
            on_init = init_callback;
        }
        local bufnr = api.nvim_get_current_buf()
        local status, client_id = pcall(get_buf_var, bufnr, "lsp_client_id")
        if type(client_id) ~= "number" then
            client_id = vim.lsp.start_client(config)
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_gopls()
        local bufnr = api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "go.mod", ".git");
        if not root_dir then return end
        local config = {
            name = "gopls";
            cmd = {"gopls"};
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["textDocument/hover"] = hover_callback
            };
            on_attach = on_attach_callback;
            on_init = init_callback;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_jdt()
        local bufnr = api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "pom.xml", "build.gradle");
        if not root_dir then return end
        local lsp4j_status_callback = vim.schedule_wrap(function(_, _, result)
            api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
        end)
        local config = {
            name = "eclipse.jdt.ls";
            cmd = {"jdtls"};
            root_dir = root_dir;
            callbacks = { 
                ["language/status"] = lsp4j_status_callback,
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["textDocument/hover"] = hover_callback
            };
            on_attach = on_attach_callback;
            on_init = init_callback;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_clangd()
        local bufnr = api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "compile_commands.json", "compile_flags.txt", ".git");
        if not root_dir then return end
        local config = {
            name = {"clangd"};
            cmd = "/usr/local/opt/llvm/bin/clangd --background-index";
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["textDocument/hover"] = hover_callback
            };
            on_attach = on_attach_callback;
            on_init = init_callback;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_qlls()
        print("FOO")
        local search_path = vim.g.codeql_search_path
        local search_path_str="--search-path="
        for _, path in ipairs(search_path) do
            search_path_str=search_path_str..vim.fn.expand(path)..":"
        end
        if not search_path then return end
        local bufnr = api.nvim_get_current_buf()
        local root_dir = root_pattern(bufnr, "qlpack.yml")
        if not root_dir then 
            local root_dir = vim.fn.expand('%:p:h')
        end

        local config_workspacefolders = vim.schedule_wrap(function(initialize_params, config)
            initialize_params['workspaceFolders'] = {{
                name = 'workspace',
                uri = initialize_params['rootUri']
            }}
        end)

        local config = {
            name = "codeql-language-server";
            cmd = {"codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q", search_path_str};
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["textDocument/hover"] = hover_callback
            };
            on_attach = on_attach_callback;
            before_init = config_workspacefolders;
            on_init = init_callback;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    -- autocommands
    api.nvim_command("autocmd Filetype fortifyrulepack lua start_fls()")
    api.nvim_command("autocmd Filetype java lua start_jdt()")
    --api.nvim_command("autocmd Filetype codeql lua start_qlls()")
    api.nvim_command("autocmd Filetype go lua start_gopls()")
    api.nvim_command("autocmd Filetype c,cpp,objc lua start_clangd()")

    require'nvim_lsp'.codeqlls.setup{
        on_attach = on_attach_callback;
        callbacks = { 
            ["textDocument/publishDiagnostics"] = diagnostics_callback,
            ["textDocument/hover"] = hover_callback
        };
        settings = {
            search_path = {'~/codeql-home/codeql-repo', '~/codeql-home/pwntester-repo'};
        };
    }
end

--- @export
return {
	setup = setup;
}

