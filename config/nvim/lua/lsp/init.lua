if vim.lsp then

  local util = require 'vim.lsp.util'
  
  local function map_cmd(...)
    return { ("<Cmd>%s<CR>"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
  end

  -- in case I'm reloading.
  vim.lsp.stop_all_clients()


  -- mappings and settings
  local function lsp_setup(_)
    local function focusable_popup()
      local popup_win
      return function(winnr)
        if popup_win and nvim.win_is_valid(popup_win) then
          if nvim.get_current_win() == popup_win then
            nvim.ex.wincmd "p"
          else
            nvim.set_current_win(popup_win)
          end
          return
        end
        popup_win = winnr
      end
    end

    local diagnostic_popup = focusable_popup()

    --  ["nK"]    = map_cmd [[call lsp#text_document_hover()]];
    --  ["ngd"]   = map_cmd [[call lsp#text_document_definition()]];
    -- ["ngD"]   = { function()
    --   local _, winnr = vim.lsp.util.show_line_diagnostics()
    --   diagnostic_popup(winnr)
    -- end };
    -- ["ngp"]   = { function()
    --   local params = vim.lsp.protocol.make_text_document_position_params()
    --   local callback = vim.lsp.builtin_callbacks["textDocument/peekDefinition"]
    --   vim.lsp.buf_request(0, 'textDocument/definition', params, callback)
    -- end };
    --
    function show_diagnostics_details()
      local _, winnr = vim.lsp.util.show_line_diagnostics()
      -- TODO: improve color contrast
      -- TODO: hide virtual text while showing window
      if winnr ~= nil then
        vim.api.nvim_win_set_option(winnr, "winhl", "Normal:PMenu")
        diagnostic_popup(winnr)
      end
    end
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true; })

    -- use omnifunc for completion
    nvim.bo.omnifunc = "lsp#omnifunc"
  end

  -- custom replacement for publishDiagnostics callback
  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/builtin_callbacks.lua#L69
  local diagnostics_callback = vim.schedule_wrap(function(_, _, result)
    if not result then return end
    local uri = result.uri
    -- local bufnr = uri_to_bufnr(uri)
    local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
    if not bufnr then
      api.nvim_err_writeln(string.format("LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
      return
    end
    util.buf_clear_diagnostics(bufnr)
    util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
    util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
    util.buf_loclist(bufnr, result.diagnostics)
  end)


  -- server configuration
  vim.lsp.add_filetype_config {
    name = "fortify-language-server";
    filetype = "fortifyrulepack";
    cmd = "fls";
    callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
    on_attach = lsp_setup;
  }

  vim.lsp.add_filetype_config {
    name = "eclipse.jdt.ls";
    filetype = "java";
    cmd = "jdtls";
    callbacks = { ["textDocument/publishDiagnostics"] = diagnostics_callback };
    on_attach = lsp_setup;
  }

end
