local create = vim.api.nvim_create_augroup
local define = vim.api.nvim_create_autocmd

create("bitacora", { clear = true })

define({ "TermEnter", "WinEnter", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    g.onEnter()
  end,
})
define({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    g.onFileType()
  end,
})
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
-- define({ "TermOpen" }, {
--   pattern = { "term://*" },
--   callback = function()
--     vim.wo.winhl = "Normal:NormalAlt"
--     vim.cmd("startinsert")
--   end,
-- })
-- define({ "TermLeave" }, {
--   pattern = { "term://*" },
--   callback = function()
--     vim.cmd("stopinsert")
--   end,
-- })
-- define({ "TermClose" }, {
--   pattern = { "term://*" },
--   callback = function()
--     vim.api.nvim_input "<CR>"
--   end,
-- })
define({ "BufEnter" }, {
  pattern = { "*.txt" },
  callback = function()
    if vim.opt.buftype._value == "help" then
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
