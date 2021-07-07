-----------------------------------------------------------------------------//
-- GLOBALS
-----------------------------------------------------------------------------//
require'globals'

-----------------------------------------------------------------------------//
-- MODULES
-----------------------------------------------------------------------------//
require'markdown'

-----------------------------------------------------------------------------//
-- PLUGINS
-----------------------------------------------------------------------------//
require'plugins'

-----------------------------------------------------------------------------//
-- MAPPINGS
-----------------------------------------------------------------------------//
require'mappings'

-----------------------------------------------------------------------------//
-- AUTOCMDs
-----------------------------------------------------------------------------//
require'autocmds'

-----------------------------------------------------------------------------//
-- ALIASES
-----------------------------------------------------------------------------//
g.alias("bd", "lua require('bufdelete').bufdelete(0, true)")

-----------------------------------------------------------------------------//
-- COMMANDS
-----------------------------------------------------------------------------//
vim.cmd [[command! LabIssues :call v:lua.g.LabIssues()]]
vim.cmd [[command! HubberReports :call v:lua.g.HubberReports()]]
vim.cmd [[command! VulnReports :call v:lua.g.VulnReports()]]
vim.cmd [[command! BountySubmissions :call v:lua.g.BountySubmissions()]]
vim.cmd [[command! Bitacora :call v:lua.g.Bitacora()]]
vim.cmd [[command! TODO :call v:lua.g.TODO()]]

-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
vim.opt.shortmess = {
  t = true, -- truncate file messages at start
  a = true, -- abbreviate messages
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  I = true, -- don't give the intro message when starting :intro
  s = true,
  c = true,
  W = true, -- Dont show [w] or written when writing

  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
}
-----------------------------------------------------------------------------//
-- Timings {{{1
-----------------------------------------------------------------------------//
vim.opt.updatetime = 750
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
-----------------------------------------------------------------------------//
--Shada {{{1
-----------------------------------------------------------------------------//
vim.opt.shada = {
  "'1000",      -- previously edited files
  "/1000",      -- search history items
  ":1000",      -- command-line history items
  "<1000",      -- lines for each saved registry
  "s100",       -- max size of item in KiB
  "h"           -- no hlsearch when loading shada
}
-----------------------------------------------------------------------------//
--Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.eadirection = "hor"
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = "useopen,uselast" -- "uselast"
vim.opt.fillchars = {
  vert = "│",
  fold = "⠀",
  eob = " ", -- suppress ~ at EndOfBuffer
  --diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
vim.opt.diffopt = vim.opt.diffopt
  + {
    "vertical",
    "iwhite",
    "hiddenoff",
    "foldcolumn:0",
    "context:1000000",
    "algorithm:histogram", -- "algorithm:patience"
    "indent-heuristic",
  }
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
vim.opt.formatoptions = {
  ["1"] = false,
  ["2"] = false, -- Use indent from 2nd line of a paragraph
  a = false, -- Auto formatting is BAD.
  q = true, -- continue comments with gq"
  c = false, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = false,
  v = false,
}
vim.cmd [[set formatoptions=qrnj]]

---------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
--vim.opt.foldtext = "v:lua.folds()"
-- vim.opt.foldopen = vim.opt.foldopen + "search"
-- vim.opt.foldlevelstart = 10
-- vim.opt.foldmethod = "indent"
-----------------------------------------------------------------------------//
-- Grepprg {{{1
-----------------------------------------------------------------------------//
-- Use faster grep alternatives if possible
if g.executable "rg" then
  vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
elseif g.executable "ag" then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.opt.wildcharm = vim.fn.char2nr [[<C-Z>]]
vim.opt.wildmode = {"full", "longest"}
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 15 -- Make popup window translucent
vim.opt.pumheight = 15
vim.opt.pumwidth = 20
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
vim.opt.wildignore = {
  "*.aux",
  "*.out",
  "*.toc",
  "*.o",
  "*.obj",
  "*.dll",
  "*.jar",
  "*.pyc",
  "*.rbc",
  "*.class",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.wav",
  "*.webm",
  "*.eot",
  "*.otf",
  "*.ttf",
  "*.woff",
  "*.doc",
  "*.pdf",
  "*.zip",
  "*.tar.gz",
  "*.tar.bz2",
  "*.rar",
  "*.tar.xz",
  -- Cache
  ".sass-cache",
  "*/vendor/gems/*",
  "*/vendor/cache/*",
  "*/.bundle/*",
  "*.gem",
  -- Temp/System
  "*.*~",
  "*~ ",
  "*.swp",
  ".lock",
  ".DS_Store",
  "._*",
  "tags.lock",
}
-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
vim.opt.showtabline = 2
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.synmaxcol = 1024 -- don't syntax highlight long lines
vim.opt.signcolumn = "yes:2"
vim.opt.ruler = false
vim.opt.number = true
vim.opt.relativenumber = true
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
vim.opt.list = true -- invisible chars
vim.opt.listchars = {
  nbsp = "%",
  extends = "›", -- Alternatives: … »
  precedes = "‹", -- Alternatives: … «
  --trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.autoindent = false
vim.opt.cindent = false
vim.opt.smartindent = false
vim.opt.shiftround = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
 -----------------------------------------------------------------------------//
-- vim.o.debug = "msg"
vim.opt.joinspaces = false
vim.opt.gdefault = true
vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
vim.opt.completeopt = { "menuone", "noselect", "noselect" }
vim.opt.hlsearch = false
vim.opt.autowriteall = true -- automatically :write before running commands and changing files
--vim.opt.clipboard = { "unnamedplus" }
vim.opt.termguicolors = true
vim.opt.keywordprg = ":help"
-----------------------------------------------------------------------------//
-- Emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
vim.opt.emoji = false
-----------------------------------------------------------------------------//
vim.opt.inccommand = "nosplit"
-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
vim.opt.jumpoptions = {"stack"}
vim.opt.showmode = false
vim.opt.sessionoptions = {
  "globals",
  "buffers",
  "curdir",
  "help",
  "winpos",
  -- "tabpages",
}
vim.opt.viewoptions = { "cursor", "folds" } -- save/restore just these (with `:{mk,load}view`)
vim.opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
-------------------------------------------------------------------------------
-- BACKUP AND SWAPS {{{
-------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.writebackup = false
if vim.fn.isdirectory(vim.o.undodir) == 0 then
  vim.fn.mkdir(vim.o.undodir, "p")
end
vim.opt.undofile = true
vim.opt.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create the swap file.
-- This will ensure that swap file name is unique, so there are no collisions between files
-- with the same name from different directories.
vim.opt.directory = vim.fn.stdpath "data" .. "/swap//"
if vim.fn.isdirectory(vim.o.directory) == 0 then
  vim.fn.mkdir(vim.o.directory, "p")
end
--}}}
-----------------------------------------------------------------------------//
-- Match and search {{{1
-----------------------------------------------------------------------------//
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.opt.scrolloff = 9
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 5
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
vim.opt.spellsuggest:prepend { 12 }
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = "" -- don't check for capital letters at start of sentence
vim.opt.fileformats = { "unix", "mac", "dos" }

