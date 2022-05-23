local create = vim.api.nvim_create_augroup
local define = vim.api.nvim_create_autocmd

create("bitacora", { clear = true })

define({ "TermEnter", "WinEnter", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.tbl_contains({ "octo", "frecency", "TelescopePrompt", "TelescopeResults" }, vim.bo.filetype) then
    elseif vim.tbl_contains(g.special_buffers, vim.bo.filetype) then
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
    elseif vim.bo.filetype == "" or vim.bo.buftype == "terminal" then
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
    else
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
    end
    vim.api.nvim_command [[au FileType * set fo-=c fo-=r fo-=o]]
    if vim.bo.buftype == "terminal" then
      vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
      vim.wo.cursorline = false
    end
  end,
})
-- define({ "FileType" }, {
--   pattern = { "*" },
--   callback = function()
--   end,
-- })
define({ "FocusGained", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    -- check if file was changed externally
    vim.cmd [[checktime]]
  end,
})
define({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank { on_visual = false, higroup = "IncSearch", timeout = 500 }
  end,
})
define({ "BufEnter" }, {
  pattern = { "*.txt" },
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "help" then
      vim.cmd [[wincmd L]]
    end
  end,
})
define({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.bo.ft == "markdown" then
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    else
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "»",
        },
      })
    end
  end,
})
define({ "BufWritePost" }, {
  pattern = { "plugins.lua" },
  callback = function()
    vim.cmd [[source <afile> | PackerCompile ]]
  end,
})
define({ "BufWritePost" }, {
  group = "bitacora",
  pattern = { "*/bitacora/*" },
  callback = function()
    require("pwntester.markdown").asyncPush()
  end,
})
-- winbar
define({ "CursorMoved", "BufWinEnter", "BufFilePost" }, {
  pattern = { "*" },
  callback = function()
    if vim.tbl_contains(g.special_buffers, vim.bo.filetype) or
        vim.tbl_contains({ "prompt", "nofile" }, vim.api.nvim_buf_get_option(0, "buftype")) then
      vim.opt_local.winbar = nil
      return
    end
    local value = require("pwntester.winbar").gps()
    if not value then
      value = "%f"
    end
    vim.opt_local.winbar = value
  end,
})
