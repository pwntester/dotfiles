local vim = vim

local g = require "pwntester.globals"

-- require a lua module, but force reload it (RC files can be re-sourced)
local function _require(name)
  package.loaded[name] = nil
  return require(name)
end

-----------------------------------------------------------------------------//
-- PLUGINS
-----------------------------------------------------------------------------//
vim.g.mapleader = " "
vim.g.maplocalleader = " "

_require "pwntester.lazy"

-----------------------------------------------------------------------------//
-- MAPPINGS
-----------------------------------------------------------------------------//
local mappings = _require "pwntester.mappings"
g.map(mappings.all, { silent = true })

-----------------------------------------------------------------------------//
-- AUTOCMDs
-----------------------------------------------------------------------------//
_require "pwntester.autocmds"

-----------------------------------------------------------------------------//
-- ALIASES
-----------------------------------------------------------------------------//
-- g.alias("bd", "lua require('bufdelete').bufdelete(0, true)")
-- g.alias("bd", "lua require('close_buffers').delete({type = 'this'})")
-- g.alias("bd", "lua MiniBufremove.delete()")

-----------------------------------------------------------------------------//
-- COMMANDS
-----------------------------------------------------------------------------//
vim.cmd [[command! LabIssues :call v:lua.require'pwntester.globals'.LabIssues()]]
vim.cmd [[command! HubberReports :call v:lua.require'pwntester.globals'.HubberReports()]]
vim.cmd [[command! VulnReports :call v:lua.require'pwntester.globals'.VulnReports()]]
vim.cmd [[command! BountySubmissions :call v:lua.require'pwntester.globals'.BountySubmissions()]]
vim.cmd [[command! Bitacora :call v:lua.require'pwntester.globals'.Bitacora()]]
vim.cmd [[command! TODO :call v:lua.require'pwntester.globals'.TODO()]]
vim.cmd [[command! BufOnly execute '%bdelete|edit #|normal `"']]
vim.cmd [[command! W execute 'write']]
-----------------------------------------------------------------------------//
-- COLORS
-----------------------------------------------------------------------------//

--vim.cmd.colorscheme "nautilus-halcyon"
vim.cmd.colorscheme "catppuccin"

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
vim.opt.updatetime = 200 --750
vim.opt.timeout = true
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 10
vim.loader.enable()
-----------------------------------------------------------------------------//
--Shada {{{1
-----------------------------------------------------------------------------//
vim.opt.shada = {
  "'1000", -- previously edited files
  "/1000", -- search history items
  ":1000", -- command-line history items
  "<1000", -- lines for each saved registry
  "s100", -- max size of item in KiB
  "h", -- no hlsearch when loading shada
}
-----------------------------------------------------------------------------//
--Shell {{{1
-----------------------------------------------------------------------------//
vim.opt.shell = "/bin/sh"
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
  --stl = " ",
  --stlnc = " ",
  --vert = "│",
  --eob = " ", -- suppress ~ at EndOfBuffer
  --diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
  -- msgsep = "‾",
  fold = "⠀",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
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
  r = false, -- Continue comments when pressing Enter
  o = false, -- Automatically insert the current comment leader after hitting 'o' or 'O'
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = false,
  v = false,
}
-- vim.cmd [[set formatoptions=qnj]]
-----------------------------------------------------------------------------//
-- Grepprg {{{1
-----------------------------------------------------------------------------//
-- Use faster grep alternatives if possible
if vim.fn.executable "rg" > 0 then
  vim.o.grepprg = [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
elseif vim.fn.executable "ag" > 0 then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
end
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.opt.wildmode = { "full", "longest" }
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 0
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
vim.opt.cursorline = true
vim.go.laststatus = 3
vim.opt.showtabline = 0 -- 2
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.synmaxcol = 1024 -- don't syntax highlight long lines
vim.opt.ruler = false
vim.opt.mouse = ""
-- Number column
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
-- Sign column
vim.opt.signcolumn = "yes:1"
-- Status column
vim.opt.statuscolumn = [[%!v:lua.require'pwntester.statuscolumn'.statuscolumn()]]

-- Fold column
vim.opt.foldtext = ""
vim.opt.foldcolumn = "1" -- disable until we can disable numbers (https://github.com/neovim/neovim/pull/17446)
vim.opt.foldenable = true
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
vim.opt.list = false -- invisible chars
vim.opt.listchars = {
  nbsp = "%",
  extends = "›", -- Alternatives: … »
  precedes = "‹", -- Alternatives: … «
  --trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
vim.opt.autoindent = false
vim.opt.cindent = false
vim.opt.smartindent = false

vim.opt.wrap = true
vim.opt.linebreak = true
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
vim.opt.hlsearch = true
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
vim.opt.jumpoptions = { "stack" }
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
-- if vim.fn.isdirectory(vim.o.undodir) == 0 then
--   vim.fn.mkdir(vim.o.undodir, "p")
-- end
vim.opt.undofile = true
vim.opt.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create the swap file.
-- This will ensure that swap file name is unique, so there are no collisions between files
-- with the same name from different directories.
vim.opt.directory = vim.fn.stdpath "data" .. "/swap/"
-- if vim.fn.isdirectory(vim.o.directory) == 0 then
--   vim.fn.mkdir(vim.o.directory, "p")
-- end
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
vim.opt.guifont = "monospace:h17"
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
vim.opt.spellsuggest:prepend { 12 }
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = "" -- don't check for capital letters at start of sentence
vim.opt.fileformats = { "unix", "mac", "dos" }
