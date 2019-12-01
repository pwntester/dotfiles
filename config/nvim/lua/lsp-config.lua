require 'util'
require 'nvim-lsp'

local lsps_dirs = {}
local lsps_buffers = {}
local lsps_diagnostics = { }
local lsps_diagnostics_count = { }

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

-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L506
local function buf_clear_diagnostics(bufnr)
    validate { bufnr = {bufnr, 'n', true} }
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    -- clear signs
    vim.fn.sign_unplace('nvim-lsp', {buffer=bufnr})

    -- clear virtual text namespace
    vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

function buf_diagnostics_show(bufnr)
    if not lsps_diagnostics[bufnr] then return end
    buf_clear_diagnostics(bufnr)
    buf_diagnostics_save_positions(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_underline(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_virtual_text(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_statusline(bufnr, lsps_diagnostics[bufnr])
    buf_diagnostics_signs(bufnr, lsps_diagnostics[bufnr])
end

-- modified from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L606
function buf_diagnostics_virtual_text(bufnr, diagnostics)
    -- return if we are called from a window that is not 
    -- showing bufnr
    if vim.api.nvim_win_get_buf(0) ~= bufnr then return end

    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        buf_diagnostics_save_positions(bufnr, diagnostics)
    end
    buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        return
    end
    for line, line_diags in pairs(buffer_line_diagnostics) do
        local virt_texts = {}

        -- window total width
        local win_width = vim.api.nvim_win_get_width(0)

        -- line length
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line, line+1, 1)[1]
        if line_content == nil then goto continue end
        local line_width = vim.fn.strdisplaywidth(line_content)

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

-- code action support
local lsps_actions = {}

function make_range_params()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
  col = vim.str_utfindex(line, col)
  return {
    textDocument = { uri = vim.uri_from_bufnr(0) };
    range = { ["start"] = { line = row, character = col }, ["end"] = { line = row, character = (col + 1) } }
  }
end

function fzf_code_action_callback(selection)
    local command = lsps_actions[selection]['command']
    local arguments = lsps_actions[selection]['arguments']
    local edit = lsps_actions[selection]['edit']
    local title = lsps_actions[selection]['title']

    if command == 'java.apply.workspaceEdit' then
        -- eclipse.jdt.ls does not follow spec here
        for _, argument in ipairs(arguments) do
            for uri, text_edit in pairs(argument['changes']) do
                local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
                apply_text_edits(text_edit, bufnr)
            end
        end
    if command then
        -- TODO: test with a LS that follows spect
        local callback = vim.schedule_wrap(function(_, _, result)
            print(dump(result))
            if not result then return end
            print('not implemented')
            print(dump(result))
        end)
        vim.lsp.buf_request(0, 'workspace/executeCommand', arguments, callback)
    elseif edit then
        -- TODO: implement
        print('not implemented')
    end
end

-- function FZF_menu(raw_options)
--     local fzf_options = {}
--     for idx, option in ipairs(raw_options) do
--         table.insert(fzf_options, string.format('%d::%s', idx, option.title))
--     end
--     local fzf_config = {
--         source = fzf_options,
--         sink = "ApplyAction",
--         options = "+m --with-nth 2.. -d ::"
--     }
--     vim.fn['fzf#run'](vim.fn['fzf#wrap'](fzf_config))
-- end

function request_code_actions()
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
        vim.fn.CodeActionMenu(lsps_actions)
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

-- global so can be called from mapping
function show_diagnostics_details()
    local _, winnr = show_line_diagnostics()
    if winnr ~= nil then
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
        vim.api.nvim_win_set_option(winnr, "winhl", "Normal:PMenu")
    end
end

-- global so can be called from lightline
function get_lsp_diagnostic_metrics()
    local bufnr = vim.api.nvim_get_current_buf()
    return lsps_diagnostics_count[bufnr]
end

-- global so can be called from lightline
function get_lsp_client_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local client_id = lsps_buffers[bufnr]
    local client = vim.lsp.get_client_by_id(client_id)
    if client ~= nil then
        if client.notify("window/progress", {}) then
                return true
        end
    end
    return false
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

    local function set_workspace_folder(initialize_params, config)
        initialize_params['workspaceFolders'] = {{
            name = 'workspace',
            uri = initialize_params['rootUri']
        }}
    end

    local function on_attach(client, bufnr)
        lsps_buffers[bufnr] = client.id

        -- mappings and settings
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";dd", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";k", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";s", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";t", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";ca", "<Cmd>lua request_code_actions()<CR>", { silent = true; })
    end

    -- custom replacement for publishDiagnostics callback
    -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
    local diagnostics_callback = vim.schedule_wrap(function(_, _, result)
        if not result then return end
        local uri = result.uri
        local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
        if not bufnr then
            api.nvim_err_writeln(string.format("LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
            return
        end
        lsps_diagnostics[bufnr] = result.diagnostics
        buf_diagnostics_show(bufnr)
    end)

    local lsp4j_status_callback = vim.schedule_wrap(function(_, _, result)
        vim.api.nvim_command(string.format(':echohl Function | echo "%s" | echohl None', result.message))
    end)

    function start_fls()
        local root_dir = vim.fn.expand('%:p:h')
        local config = {
            name = "fortify-language-server";
            cmd = "fls";
            root_dir = root_dir;
            callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
            on_attach = on_attach;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    function start_qlls()
        local root_dir = vim.fn.expand('%:p:h')
        local search_path = '/Users/pwntester/codeql-home/codeql-repo'
        local config = {
            name = "codeql-language-server";
            cmd = "codeql execute language-server --check-errors ON_CHANGE -q --search-path="..search_path;
            root_dir = root_dir;
            callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
            on_attach = on_attach;
            before_init = set_workspace_folder;
        }
        local client_id = lsps_dirs[root_dir]
        if not client_id then
            client_id = vim.lsp.start_client(config)
            lsps_dirs[root_dir] = client_id
        end
        local bufnr = vim.api.nvim_get_current_buf()
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
            on_attach = on_attach;
            before_init = set_workspace_folder;
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
        local config = {
            name = "eclipse.jdt.ls";
            cmd = "jdtls";
            root_dir = root_dir;
            callbacks = { 
                ["textDocument/publishDiagnostics"] = diagnostics_callback,
                ["language/status"] = lsp4j_status_callback,
            };
            on_attach = on_attach;
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

end

--- @export
return {
	setup = setup;
}

