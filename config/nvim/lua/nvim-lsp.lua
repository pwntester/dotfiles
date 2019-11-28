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
 
-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L506
function buf_clear_diagnostics(bufnr)
    validate { bufnr = {bufnr, 'n', true} }
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
    vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
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
