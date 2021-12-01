g.augroup("VimRC", {
  -- au TermEnter,WinEnter,BufEnter * nested lua util.onEnter()
  {
    events = { "TermEnter", "WinEnter", "BufEnter" },
    targets = { "*" },
    command = function()
      g.onEnter()
    end,
  },
  -- au FileType * nested lua util.onFileType()
  {
    events = { "FileType" },
    targets = { "*" },
    command = function()
      g.onFileType()
    end,
  },
  -- au FocusGained,BufEnter * checktime
  {
    events = { "FocusGained", "BufEnter" },
    targets = { "*" },
    command = function()
      vim.cmd [[checktime]]
    end,
  },
  -- au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500}
  {
    events = { "TextYankPost" },
    targets = { "*" },
    command = function()
      vim.highlight.on_yank { on_visual = false, higroup = "IncSearch", timeout = 500 }
    end,
  },
  -- au TermOpen * set ft=terminal
  {
    events = { "TermOpen" },
    targets = { "term://*" },
    command = function()
      vim.bo.ft = "terminal"
    end,
  },
  -- au TermOpen term://* startinsert
  {
    events = { "TermOpen" },
    targets = { "term://*" },
    command = function()
      vim.fn.startinsert()
    end,
  },
  -- au TermLeave term://* stopinsert
  {
    events = { "TermLeave" },
    targets = { "term://*" },
    command = function()
      vim.fn.stopinsert()
    end,
  },
  -- au TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif
  {
    events = { "TermClose" },
    targets = { "term://*" },
    command = function()
      vim.api.nvim_input "<CR>"
    end,
  },
  -- au BufEnter *.txt if &buftype == 'help' | wincmd L | endif
  {
    events = { "BufEnter" },
    targets = { "*.txt" },
    command = function()
      if vim.opt.buftype._value == "help" then
        vim.cmd [[wincmd L]]
      end
    end,
  },

  {
    events = { "BufEnter" },
    targets = { "*" },
    command = function()
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
  },
  {
    events = { "BufWritePost" },
    targets = { "*/bitacora/*" },
    command = function()
      require("pwntester.markdown").asyncPush()
    end,
  },
})
