require 'util'
require 'nvim-lsp'

vim.api.nvim_command('sign define LspErrorSign text=x texthl=LspDiagnosticsError linehl= numhl=')
vim.api.nvim_command('sign define LspWarningSign text=x texthl=LspDiagnosticsWarning linehl= numhl=')

local sign_count = 1
local lsps_dirs = {}
local lsps_buffers = {}
local lsps_diagnostics = { }

-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L593
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

-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L606
local function buf_diagnostics_virtual_text(bufnr, diagnostics)
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
        local available_space = win_width - decoration_width - line_width

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

-- show diagnostics in sign column
local function buf_diagnostics_signs(bufnr, diagnostics)

    -- clear previous signs
    vim.api.nvim_command(string.format("sign unplace * buffer=%d", bufnr))

    -- add signs
    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity == 2 then
            vim.api.nvim_command(string.format('sign place %d line=%d name=LspWarningSign buffer=%d', sign_count, diagnostic.range.start.line+1, bufnr))
        elseif diagnostic.severity == 1 then
            vim.api.nvim_command(string.format('sign place %d line=%d name=LspErrorSign buffer=%d', sign_count, diagnostic.range.start.line+1, bufnr))
        end
        sign_count = sign_count + 1
    end
end

-- global so can be called from mapping
function show_diagnostics_details()
    -- local diagnostic_popup = focusable_popup()
    --local _, winnr = vim.lsp.util.show_line_diagnostics()
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
return lsps_diagnostics[bufnr]
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

if vim.lsp then

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
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gd", "<Cmd>vim.lsp.buf.definition()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gD", "<Cmd>vim.lsp.buf.declaration()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";gi", "<Cmd>vim.lsp.buf.implementation()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";k", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";s", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true; })
        vim.api.nvim_buf_set_keymap(bufnr, "n", ";t", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", { silent = true; })
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

        -- custom virtual text display
        buf_clear_diagnostics(bufnr)
        buf_diagnostics_save_positions(bufnr, result.diagnostics)
        buf_diagnostics_underline(bufnr, result.diagnostics)
        buf_diagnostics_virtual_text(bufnr, result.diagnostics)

        -- collect metrics for status line
        lsps_diagnostics[bufnr] = { errors=0, warnings=0 }
        for _, diagnostic in ipairs(result.diagnostics) do
            if diagnostic.severity == 2 then
                lsps_diagnostics[bufnr]['warnings'] = lsps_diagnostics[bufnr]['warnings'] + 1
            elseif diagnostic.severity == 1 then
                lsps_diagnostics[bufnr]['errors'] = lsps_diagnostics[bufnr]['errors'] + 1
            end
        end

        -- update status bar
        vim.api.nvim_command("call lightline#update()")

        -- signs
        buf_diagnostics_signs(bufnr, result.diagnostics)

    end)

    local lsp4j_status_callback = vim.schedule_wrap(function(_, _, result)
        print(result.message)
    end)

    function start_fls()
        local root_dir = vim.api.nvim_command_output("echo expand('%:p:h')")
        --local root_dir = vim.loop.cwd()
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
        local root_dir = vim.api.nvim_command_output("echo expand('%:p:h')")
        --local root_dir = vim.loop.cwd()
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

    function start_jdt()
        local root_dir = buffer_find_root_dir(bufnr, function(dir)
            -- return is_dir(path_join(dir, '.git'))
            local result = vim.fn.filereadable(path_join(dir, 'pom.xml')) == 1 or vim.fn.filereadable(path_join(dir, 'build.gradle')) == 1
            return result
        end)
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
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.buf_attach_client(bufnr, client_id)
    end

    -- autocommands
    vim.api.nvim_command [[autocmd Filetype fortifyrulepack lua start_fls()]]
    vim.api.nvim_command [[autocmd Filetype java lua start_jdt()]]
    vim.api.nvim_command [[autocmd Filetype codeql lua start_qlls()]]

end
