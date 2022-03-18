local create = vim.api.nvim_create_augroup
local define = vim.api.nvim_create_autocmd

create("bitacora", { clear = true })

-- au TermEnter,WinEnter,BufEnter * nested lua util.onEnter()
define({ "TermEnter", "WinEnter", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    g.onEnter()
  end,
})
-- au FileType * nested lua util.onFileType()
define({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    g.onFileType()
  end,
})
-- au FocusGained,BufEnter * checktime
define({ "FocusGained", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd [[checktime]]
  end,
})
-- au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500}
define({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank { on_visual = false, higroup = "IncSearch", timeout = 500 }
  end,
})
-- au TermOpen * set ft=terminal
define({ "TermOpen" }, {
  pattern = { "term://*" },
  callback = function()
    vim.bo.ft = "terminal"
  end,
})
-- au TermOpen term://* startinsert
define({ "TermOpen" }, {
  pattern = { "term://*" },
  callback = function()
    vim.fn.startinsert()
  end,
})
-- au TermLeave term://* stopinsert
define({ "TermLeave" }, {
  pattern = { "term://*" },
  callback = function()
    vim.fn.stopinsert()
  end,
})
-- au TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif
define({ "TermClose" }, {
  pattern = { "term://*" },
  callback = function()
    vim.api.nvim_input "<CR>"
  end,
})
-- au BufEnter *.txt if &buftype == 'help' | wincmd L | endif
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
