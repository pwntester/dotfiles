require 'window'
require 'util'

local util = require 'vim.lsp.util'
local vim = vim
local validate = vim.validate
local api = vim.api

local lsps_actions = {}
local severity_highlights = {
    [1] = 'LspDiagnosticsError',
    [2] = 'LspDiagnosticsWarning'
}

local cursor_pos = {}
-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L560
local all_buffer_diagnostics = {}
local diagnostic_ns = vim.api.nvim_create_namespace("vim_lsp_diagnostics")

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

local function apply_text_edits(text_edits, bufnr)
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

-- my custom functions
local function buf_cache_diagnostics(bufnr, diagnostics)
    validate {
        bufnr = {bufnr, 'n', true};
        diagnostics = {diagnostics, 't', true};
    }
    if not diagnostics then return end

    local buffer_diagnostics = {}

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
local function buf_diagnostics_virtual_text(bufnr)
    -- return if we are called from a window that is not showing bufnr
    if api.nvim_win_get_buf(0) ~= bufnr then return end

    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    local line_no = api.nvim_buf_line_count(bufnr)
    for _, line_diags in pairs(all_buffer_diagnostics[bufnr]) do

        local line = line_diags[1].range.start.line
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

-- custom windows
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

function format_document()
  cursor_pos = vim.fn.getpos(".")
  vim.lsp.buf.formatting()
end

function formatting_callback(_, _, result)
  if not result then return end
  util.apply_text_edits(result)
  vim.fn.setpos(".", cursor_pos)
end

function hover_callback(_, method, result)
  if not (result and result.contents) then return end
  local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then return end
  require("window").popup_window(markdown_lines, 'markdown', {}, true)
end

-- custom replacement for publishDiagnostics callback
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
function diagnostics_callback(_, _, result)
  if not result then return end
  local uri = result.uri
  local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
  if not bufnr then
    api.nvim_err_writeln(string.format("LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
    return
  end

  -- clear hl and signcolumn namespaces
  util.buf_clear_diagnostics(bufnr)
  util.buf_diagnostics_save_positions(bufnr, result.diagnostics)

  -- underline diagnosticed code
  local ft = api.nvim_buf_get_option(bufnr, "filetype")
  if ft ~= "fortifyrulepack" then
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
  end

  -- signcolumn
  util.buf_diagnostics_signs(bufnr, result.diagnostics)

  -- cache diagnostics so they are available for virtual text and codeactions
  buf_cache_diagnostics(bufnr, result.diagnostics)

  --custom virtual text uses diagnostics cache so need to go after
  buf_diagnostics_virtual_text(bufnr)

  -- Location list
  if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.uri = v.uri or result.uri
      end
      util.set_loclist(result.diagnostics)
  end

  -- notify user we are done processing diagnostics
  api.nvim_command("doautocmd User LspDiagnosticsChanged")
end
