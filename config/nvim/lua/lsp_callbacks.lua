local lsp_util = require 'vim.lsp.util'
local protocol = require 'vim.lsp.protocol'
local vim = vim
local api = vim.api

local diagnostic_ns = vim.api.nvim_create_namespace("vim_lsp_diagnostics")

local function buf_diagnostics_virtual_text(bufnr, diagnostics)
  if not diagnostics then return end

  local buffer_line_diagnostics = vim.lsp.util.diagnostics_group_by_line(diagnostics)

  for line, line_diags in pairs(buffer_line_diagnostics) do
    local virt_texts = {}

    -- window total width
    local win_width = api.nvim_win_get_width(0)

    -- line length
    local lines = api.nvim_buf_get_lines(bufnr, line, line+1, 0)
    local line_width = 0
    if #lines > 0 then
      local line_content = lines[1]
      if line_content == nil then goto continue end
      line_width = vim.fn.strdisplaywidth(line_content)
    end

    -- window decoration with (sign + fold + number)
    local decoration_width = require'window'.window_decoration_columns()

    -- available space for virtual text
    local right_padding = 1
    local available_space = win_width - decoration_width - line_width - right_padding

    -- virtual text
    local last = line_diags[#line_diags]
    local message = "■ "..last.message:gsub("\r", ""):gsub("\n", "  ")

    if #line_diags > 1 then
      -- more than one diagnostic in line
      local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
      local prefix = string.rep(" ", leading_space)
      table.insert(virt_texts, {prefix..'■', vim.lsp.util.get_severity_highlight_name(line_diags[1].severity)})
      for i = 2, #line_diags - 1 do
        table.insert(virt_texts, {'■', vim.lsp.util.get_severity_highlight_name(line_diags[i].severity)})
      end
      table.insert(virt_texts, {message, vim.lsp.util.get_severity_highlight_name(last.severity)})
    else
      -- 1 diagnostic in line
      local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
      local prefix = string.rep(" ", leading_space)
      table.insert(virt_texts, {prefix..message, vim.lsp.util.get_severity_highlight_name(last.severity)})
    end
    api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
    ::continue::
  end
end

local function show_line_diagnostics()
  local lines = {'Diagnostics:'}
  local highlights = {{0, "Bold"}}
  local line_diagnostics = vim.lsp.util.get_line_diagnostics()
  if vim.tbl_isempty(line_diagnostics) then return end
  for i, diagnostic in ipairs(line_diagnostics) do
    local prefix = string.format("%d. ", i)
    local hiname = vim.lsp.util.get_severity_highlight_name(diagnostic.severity)
    assert(hiname, 'unknown severity: ' .. tostring(diagnostic.severity))
    local message_lines = vim.split(diagnostic.message, '\n', true)
    table.insert(lines, prefix..message_lines[1])
    table.insert(highlights, {#prefix + 1, hiname})
    for j = 2, #message_lines do
      table.insert(lines, message_lines[j])
      table.insert(highlights, {0, hiname})
    end
  end
  local popup_bufnr, winnr = require("window").popup_window(lines, 'plaintext', {}, true)
  return popup_bufnr, winnr
end

local function hover_callback(_, _, result)
  if not (result and result.contents) then return end
  local markdown_lines = lsp_util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = lsp_util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then return end
  require("window").popup_window(markdown_lines, 'markdown', {}, true)
end

local function diagnostics_callback(_, _, result)

  -- prevent creating/loading bufers for empty diagnostics
  if not result or not result.diagnostics or vim.tbl_isempty(result.diagnostics) then return end

  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr then
    api.nvim_err_writeln("LSP.publishDiagnostics: Couldn't find buffer for " .. uri)
    return
  end

  if not api.nvim_buf_is_loaded(bufnr) then
    vim.cmd(string.format('%dbw!', bufnr))
    return
  end

  lsp_util.buf_clear_diagnostics(bufnr)

  for _, diagnostic in ipairs(result.diagnostics) do
    if diagnostic.severity == nil then
      diagnostic.severity = protocol.DiagnosticSeverity.Error
    end
  end

  lsp_util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
  lsp_util.buf_diagnostics_underline(bufnr, result.diagnostics)
  lsp_util.buf_diagnostics_signs(bufnr, result.diagnostics)
  buf_diagnostics_virtual_text(bufnr, result.diagnostics)

  if result and result.diagnostics then
    for _, v in ipairs(result.diagnostics) do
      v.uri = v.uri or result.uri
    end
    lsp_util.set_loclist(result.diagnostics)
  end

  api.nvim_command("doautocmd User LspDiagnosticsChanged")
end

return {
  show_line_diagnostics = show_line_diagnostics;
  diagnostics_callback = diagnostics_callback;
  hover_callback = hover_callback;
}
