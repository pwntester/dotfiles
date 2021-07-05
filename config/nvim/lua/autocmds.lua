as.augroup("VimRC", {
  -- au TermEnter,WinEnter,BufEnter * nested lua util.onEnter()
  {
    events = { "TermEnter", "WinEnter", "BufEnter" },
    targets = { "*" },
    command = function()
      util.onEnter()
    end,
  },
  -- au FileType * nested lua util.onFileType()
  {
    events = { "FileType" },
    targets = { "*" },
    command = function()
      util.onFileType()
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
      vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=500}
    end,
  },
  -- au TermOpen * set ft=terminal
  {
    events = { "TermOpen" },
    targets = { "term://*" },
    command = function()
      vim.opt.filetype = "terminal"
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
      vim.api.nvim_input('<CR>')
    end,
  },
  -- au BufEnter *.txt if &buftype == 'help' | wincmd L | endif
  {
    events = { "BufEnter" },
    targets = { "*.txt" },
    command = function()
      if vim.opt.buftype._value == 'help' then
        vim.cmd [[wincmd L]]
      end
    end,
  },
  -- au BufWritePost ~/bitacora/* lua require'markdown'.asyncPush()
  -- {
  --   events = { "BufWritePost" },
  --   targets = { "*/bitacora/*" },
  --   command = function()
  --     require"markdown".asyncPush()
  --   end,
  -- },
})
