severity_highlights = {}
severity_highlights[1] = 'LspDiagnosticsError'
severity_highlights[2] = 'LspDiagnosticsWarning'

underline_highlight_name = "LspDiagnosticsUnderline"

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L560
validate = vim.validate
all_buffer_diagnostics = {}
diagnostic_ns = vim.api.nvim_create_namespace("vim_lsp_diagnostics")

function buf_diagnostics_save_positions(bufnr, diagnostics)
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

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L425
function highlight_range(bufnr, ns, hiname, start, finish)
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
function open_floating_preview(contents, filetype, opts)
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
function show_line_diagnostics()
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

-- copied from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua
function set_lines(lines, A, B, new_lines)
    -- 0-indexing to 1-indexing
    local i_0 = A[1] + 1
    local i_n = B[1] + 1
    if not (i_0 >= 1 and i_0 <= #lines and i_n >= 1 and i_n <= #lines) then
        error("Invalid range: "..vim.inspect{A = A; B = B; #lines, new_lines})
    end
    local prefix = ""
    local suffix = lines[i_n]:sub(B[2]+1)
    if A[2] > 0 then
        prefix = lines[i_0]:sub(1, A[2])
    end
    local n = i_n - i_0 + 1
    if n ~= #new_lines then
        for _ = 1, n - #new_lines do table.remove(lines, i_0) end
        for _ = 1, #new_lines - n do table.insert(lines, i_0, '') end
    end
    for i = 1, #new_lines do
        lines[i - 1 + i_0] = new_lines[i]
    end
    if #suffix > 0 then
        local i = i_0 + #new_lines - 1
        lines[i] = lines[i]..suffix
    end
    if #prefix > 0 then
        lines[i_0] = prefix..lines[i_0]
    end
    return lines
end
local function sort_by_key(fn)
    return function(a,b)
        local ka, kb = fn(a), fn(b)
        assert(#ka == #kb)
        for i = 1, #ka do
            if ka[i] ~= kb[i] then
                return ka[i] < kb[i]
            end
        end
        -- every value must have been equal here, which means it's not less than.
        return false
    end
end
local edit_sort_key = sort_by_key(function(e)
    return {e.A[1], e.A[2], e.i}
end)
function apply_text_edits(text_edits, bufnr)
    if not next(text_edits) then return end
    local start_line, finish_line = math.huge, -1
    local cleaned = {}
    for i, e in ipairs(text_edits) do
        start_line = math.min(e.range.start.line, start_line)
        finish_line = math.max(e.range["end"].line, finish_line)
        -- TODO(ashkan) sanity check ranges for overlap.
        table.insert(cleaned, {
                i = i;
                A = {e.range.start.line; e.range.start.character};
                B = {e.range["end"].line; e.range["end"].character};
                lines = vim.split(e.newText, '\n', true);
            })
    end
    -- Reverse sort the orders so we can apply them without interfering with
    -- eachother. Also add i as a sort key to mimic a stable sort.
    table.sort(cleaned, edit_sort_key)
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, finish_line + 1, false)
    local fix_eol = vim.api.nvim_buf_get_option(bufnr, 'fixeol')
    local set_eol = fix_eol and vim.api.nvim_buf_line_count(bufnr) == finish_line + 1
    if set_eol and #lines[#lines] ~= 0 then
        table.insert(lines, '')
    end

    for i = #cleaned, 1, -1 do
        local e = cleaned[i]
        local A = {e.A[1] - start_line, e.A[2]}
        local B = {e.B[1] - start_line, e.B[2]}
        lines = set_lines(lines, A, B, e.lines)
    end
    if set_eol and #lines[#lines] == 0 then
        table.remove(lines)
    end
    vim.api.nvim_buf_set_lines(bufnr, start_line, finish_line + 1, false, lines)
end

