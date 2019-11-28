require 'util'

-- vim.api.sign_define('vim-lsp-error', {text = 'x', texthl = 'lscSignDiagnosticError'})
-- vim.api.sign_define('vim-lsp-warning', {text = 'x', texthl = 'lscSignDiagnosticWarning'})
vim.api.nvim_command('sign define LspErrorSign text=x texthl=LspDiagnosticsError linehl= numhl=')
vim.api.nvim_command('sign define LspWarningSign text=x texthl=LspDiagnosticsWarning linehl= numhl=')
local sign_count = 1

local lsps_dirs = {}
local lsps_buffers = {}
local lsps_diagnostics = { }

-- debug
function debug_lsp()
print(dump(lsps_dirs))
print(dump(lsps_buffers))
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L560
local validate = vim.validate
local all_buffer_diagnostics = {}
local diagnostic_ns = vim.api.nvim_create_namespace("vim_lsp_diagnostics")
local function buf_diagnostics_save_positions(bufnr, diagnostics)
    validate {
        bufnr = {bufnr, 'n', true};
        diagnostics = {diagnostics, 't', true};
    }
    if not diagnostics then return end
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    if not all_buffer_diagnostics[bufnr] then
        -- Clean up our data when the buffer unloads.
        vim.api.nvim_buf_attach(bufnr, false, {
        on_detach = function(b)
            all_buffer_diagnostics[b] = nil
        end
        })
    end
    all_buffer_diagnostics[bufnr] = {}
    local buffer_diagnostics = all_buffer_diagnostics[bufnr]

    for _, diagnostic in ipairs(diagnostics) do
        local start = diagnostic.range.start
        -- local mark_id = api.nvim_buf_set_extmark(bufnr, diagnostic_ns, 0, start.line, 0, {})
        -- buffer_diagnostics[mark_id] = diagnostic
        local line_diagnostics = buffer_diagnostics[start.line]
        if not line_diagnostics then
        line_diagnostics = {}
        buffer_diagnostics[start.line] = line_diagnostics
        end
        table.insert(line_diagnostics, diagnostic)
    end
end
 
-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L506
local function buf_clear_diagnostics(bufnr)
    validate { bufnr = {bufnr, 'n', true} }
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
    vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L425
local function highlight_range(bufnr, ns, hiname, start, finish)
  if start[1] == finish[1] then
    vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2], finish[2])
  else
    vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2], -1)
    for line = start[1] + 1, finish[1] - 1 do
      vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, line, 0, -1)
    end
    vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, finish[1], 0, finish[2])
  end
end

-- modified from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L593
local underline_highlight_name = "LspDiagnosticsUnderline"
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
local severity_highlights = {}
severity_highlights[1] = 'LspDiagnosticsError'
severity_highlights[2] = 'LspDiagnosticsWarning'
local function buf_diagnostics_virtual_text(bufnr, diagnostics)
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
        local last = line_diags[#line_diags]
        -- TODO: we may up using a differnt window but it doesnt 
        -- seem to be a straigth forward way to detect in which window
        -- the buffer is being rendered
        -- we can do nvim_win_get_buf(0) == bufnr
        local win_width = vim.api.nvim_win_get_width(0)
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line, line+1, 1)[1]
        -- java LS sends diagnostics with lines out of the buffer, ignore them
        if line_content == nil then goto continue end
        local line_width = vim.fn.strdisplaywidth(line_content)
        local message = "■ "..last.message:gsub("\r", ""):gsub("\n", "  ") 
        local gutter_width = 2 -- right padding
        local number_enabled = vim.api.nvim_win_get_option(0,"number") or nvim_win_get_option(0,"relativenumber")
        -- TODO: this always return 4, no matter the number column 
        --local number_width = vim.api.nvim_win_get_option(0,"numberwidth")
        local number_width = string.len(vim.api.nvim_buf_line_count(bufnr)) + 2 
        if number_enabled then gutter_width = gutter_width + number_width end
        local signcolumn = vim.api.nvim_win_get_option(0,"signcolumn")
        -- TODO: can I get this from anywhere?
        local signcolumn_width = 1 
        if starts_with(signcolumn, 'yes') or starts_with(signcolumn, 'auto') then gutter_width = gutter_width + signcolumn_width end
        local available_space = win_width - line_width - gutter_width
        if #line_diags > 1 then
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags + 1
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..'■', severity_highlights[line_diags[1].severity]})
            for i = 2, #line_diags - 1 do
                table.insert(virt_texts, {'■', severity_highlights[line_diags[i].severity]})
            end
            table.insert(virt_texts, {message, severity_highlights[last.severity]})
        else 
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..message, severity_highlights[last.severity]})
        end
        vim.api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
        ::continue::
    end
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L697
function trim_empty_lines(lines)
  local start = 1
  for i = 1, #lines do
    if #lines[i] > 0 then
      start = i
      break
    end
  end
  local finish = 1
  for i = #lines, 1, -1 do
    if #lines[i] > 0 then
      finish = i
      break
    end
  end
  return vim.list_extend({}, lines, start, finish)
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L273
function make_floating_popup_options(width, height, opts)
  validate {
    opts = { opts, 't', true };
  }
  opts = opts or {}
  validate {
    ["opts.offset_x"] = { opts.offset_x, 'n', true };
    ["opts.offset_y"] = { opts.offset_y, 'n', true };
  }

  local anchor = ''
  local row, col

  if vim.fn.winline() <= height then
    anchor = anchor..'N'
    row = 1
  else
    anchor = anchor..'S'
    row = 0
  end

  if vim.fn.wincol() + width <= vim.api.nvim_get_option('columns') then
    anchor = anchor..'W'
    col = 0
  else
    anchor = anchor..'E'
    col = 1
  end

  return {
    anchor = anchor,
    col = col + (opts.offset_x or 0),
    height = height,
    relative = 'cursor',
    row = row + (opts.offset_y or 0),
    style = 'minimal',
    width = width,
  }
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L357
local function open_floating_preview(contents, filetype, opts)
  validate {
    contents = { contents, 't' };
    filetype = { filetype, 's', true };
    opts = { opts, 't', true };
  }
  opts = opts or {}

  -- Trim empty lines from the end.
  contents = trim_empty_lines(contents)

  local width = opts.width
  local height = opts.height or #contents
  if not width then
    width = 0
    for i, line in ipairs(contents) do
      -- Clean up the input and add left pad.
      line = " "..line:gsub("\r", "")
      -- TODO(ashkan) use nvim_strdisplaywidth if/when that is introduced.
      local line_width = vim.fn.strdisplaywidth(line)
      width = math.max(line_width, width)
      contents[i] = line
    end
    -- Add right padding of 1 each.
    width = width + 1
        
    local floating_bufnr = vim.api.nvim_create_buf(false, true)
    if filetype then
        vim.api.nvim_buf_set_option(floating_bufnr, 'filetype', filetype)
    end
    local float_option = make_floating_popup_options(width, height, opts)
    local floating_winnr = vim.api.nvim_open_win(floating_bufnr, false, float_option)
    if filetype == 'markdown' then
        vim.api.nvim_win_set_option(floating_winnr, 'conceallevel', 2)
    end
    vim.api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
    vim.api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
    -- TODO make InsertCharPre disappearing optional?
    vim.api.nvim_command("autocmd CursorMoved,BufHidden,InsertCharPre <buffer> ++once lua pcall(vim.api.nvim_win_close, "..floating_winnr..", true)")
    return floating_bufnr, floating_winnr
  end
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L519
local function show_line_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local lines = {"Diagnostics:"}
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
    local popup_bufnr, winnr = open_floating_preview(lines, 'plaintext')
    for i, hi in ipairs(highlights) do
      local prefixlen, hiname = unpack(hi)
      -- start highlight after the prefix
      vim.api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i-1, prefixlen, -1)
    end
    return popup_bufnr, winnr
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
