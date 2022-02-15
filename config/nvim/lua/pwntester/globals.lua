-- Heavily inspired by @akinsho dots
-- from: https://raw.githubusercontent.com/akinsho/dotfiles/58b2979f51b2f3e467e14e940b6a4aa63d1868f3/.config/nvim/lua/as/globals.lua

-----------------------------------------------------------------------------//
-- Global namespace
-----------------------------------------------------------------------------//
--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
--- store all callbacks in one global table so they are able to survive re-requiring this file
_G.__as_global_callbacks = __as_global_callbacks or {}

_G.g = {
  _store = __as_global_callbacks,
  special_buffers = {
    "help",
    "fortifytestpane",
    "fortifyauditpane",
    "qf",
    "goterm",
    "codeql_panel",
    "codeql_explorer",
    "terminal",
    "packer",
    "NvimTree",
    "octo",
    "octo_panel",
    "aerieal",
    "Trouble",
    "dashboard",
    "frecency",
    "TelescopePrompt",
    "TelescopeResults",
    "NeogitStatus",
    "notify",
    "Yanil",
  },
}

-----------------------------------------------------------------------------//
-- Global functions
-----------------------------------------------------------------------------//

function g.onFileType()
  if vim.tbl_contains({ "octo", "frecency", "TelescopePrompt", "TelescopeResults" }, vim.bo.filetype) then
  elseif vim.tbl_contains(g.special_buffers, vim.bo.filetype) then
    vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
  elseif vim.bo.filetype == "" then
    vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
  else
    vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
  end
  vim.cmd [[au FileType * set fo-=c fo-=r fo-=o]]
end

function g.onEnter()
  if vim.tbl_contains(g.special_buffers, vim.bo.filetype) then
    if not vim.tbl_contains({ "octo", "dashboard" }, vim.bo.filetype) then
      -- prevent changing buffer
      vim.cmd [[ nnoremap <silent><buffer><s-l> <nop> ]]
      vim.cmd [[ nnoremap <silent><buffer><s-h> <nop> ]]
      vim.cmd [[ nnoremap <silent><buffer><leader>m <nop> ]]
      vim.cmd [[ nnoremap <silent><buffer><leader>f <nop> ]]
      vim.cmd [[ cmap <silent><buffer><expr>e<Space> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "e<Space>") ]]
      vim.cmd [[ cmap <silent><buffer><expr>bd<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bd<Return>") ]]
      vim.cmd [[ cmap <silent><buffer><expr>bp<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bp<Return>") ]]
      vim.cmd [[ cmap <silent><buffer><expr>bn<Return> (getcmdtype()==':' && getcmdpos()==1? "<Space>": "bn<Return>") ]]
    end
  end
end

function g.setTimeout(delay, callback, ...)
  local timer = vim.loop.new_timer()
  local args = { ... }
  vim.loop.timer_start(timer, delay, 0, function()
    vim.loop.timer_stop(timer)
    vim.loop.close(timer)
    callback(unpack(args))
  end)
  return timer
end

function g.map(mappings, defaults, bufnr)
  for k, v in pairs(mappings) do
    local opts = vim.fn.deepcopy(defaults)
    local mode = k:sub(1, 1)
    if mode == "_" then
      mode = ""
    end
    local lhs = k:sub(2)
    local rhs = v[1]

    -- merge default options and individual ones
    for i, j in pairs(v) do
      if i ~= 1 then
        opts[i] = j
      end
    end

    -- for <expr> mappings, discard all options except `noremap`
    -- probably needed for <script> or other modifiers that need to be first
    if opts.expr then
      local noremap_opt = opts["noremap"]
      opts = { expr = true, noremap = noremap_opt }
    end

    if bufnr then
      if type(rhs) == "string" then
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
      elseif type(rhs) == "function" then
        print "Cannot use function as rhs for buffer only mappings"
        --vim.keymap.set(bufnr, { mode }, lhs, rhs, opts)
      end
    else
      if type(rhs) == "string" then
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
      elseif type(rhs) == "function" then
        vim.keymap.set({ mode }, lhs, rhs, opts)
      end
    end
  end
end

-- ALIASES
function g.alias(from, to, buffer)
  local cmd = string.format(
    'cnoreabbrev <expr> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))',
    from,
    from,
    to,
    from
  )
  if buffer then
    cmd = string.format(
      'cnoreabbrev <expr><buffer> %s ((getcmdtype() is# ":" && getcmdline() is# "%s")? ("%s") : ("%s"))',
      from,
      from,
      to,
      from
    )
  end
  vim.cmd(cmd)
end

-- FUNCTIONS
function g.openURL()
  local uri = vim.fn.matchstr(vim.fn.getline ".", "[a-z]*:\\/\\/[^ >,;()]*")
  uri = vim.fn.shellescape(uri, 1)
  print(uri)
  if uri ~= "" then
    vim.fn.execute(string.format("!/Applications/Firefox.app/Contents/MacOS/firefox '%s'", uri))
    vim.cmd [[:redraw!]]
  else
    print "No URI found in line."
  end
end

-- OCTO FUNCTIONS
function g.TODO()
  require("octo.utils").get_issue("pwntester/bitacora", 41)
end

function g.Bitacora()
  require("octo.telescope.menu").issues { repo = "pwntester/bitacora", states = "OPEN" }
end
function g.LabIssues()
  require("octo.telescope.menu").issues { repo = "github/pe-security-lab" }
end
function g.HubberReports()
  require("octo.telescope.menu").issues {
    repo = "github/pe-security-lab",
    labels = "Vulnerability report",
    states = "OPEN",
  }
end
function g.VulnReports()
  require("octo.telescope.menu").issues { repo = "github/securitylab_vulnerabilities" }
end
function g.BountySubmissions()
  require("octo.telescope.menu").issues { repo = "github/securitylab-bounties", states = "OPEN" }
end

--
-----------------------------------------------------------------------------//
-- Messaging
-----------------------------------------------------------------------------//

if vim.notify then
  ---Override of vim.notify to open floating window
  --@param message of the notification to show to the user
  --@param log_level Optional log level
  --@param opts Dictionary with optional options (timeout, etc)
  -- vim.notify = function(message, log_level, _)
  --   assert(message, "The message key of vim.notify should be a string")
  --   g.notify(message, { timeout = 5000, log_level = log_level })
  -- end
end

-----------------------------------------------------------------------------//
-- Debugging
-----------------------------------------------------------------------------//
if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function g.plugin_installed(plugin_name)
  if not installed then
    local dirs = vim.fn.expand(vim.fn.stdpath "data" .. "/site/pack/packer/start/*", true, true)
    local opt = vim.fn.expand(vim.fn.stdpath "data" .. "/site/pack/packer/opt/*", true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return vim.fn.fnamemodify(path, ":t")
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function _G.plugin_loaded(plugin_name)
  local plugins = _G.packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end
-----------------------------------------------------------------------------//
-- Utils
-----------------------------------------------------------------------------//
function g._create(f)
  table.insert(g._store, f)
  return #g._store
end

function g._execute(id, args)
  g._store[id](args)
end

---@class Autocmd
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---Create an autocommand
---@param name string
---@param commands Autocmd[]
function g.augroup(name, commands)
  vim.cmd("augroup " .. name)
  vim.cmd "autocmd!"
  for _, c in ipairs(commands) do
    local command = c.command
    if type(command) == "function" then
      local fn_id = g._create(command)
      command = string.format("lua g._execute(%s)", fn_id)
    end
    vim.cmd(
      string.format(
        "autocmd %s %s %s %s",
        table.concat(c.events, ","),
        table.concat(c.targets or {}, ","),
        table.concat(c.modifiers or {}, " "),
        command
      )
    )
  end
  vim.cmd "augroup END"
end

---Check if a cmd is executable
---@param e string
---@return boolean
function g.executable(e)
  return vim.fn.executable(e) > 0
end

function g.echomsg(msg, hl)
  hl = hl or "Title"
  local msg_type = type(msg)
  if msg_type ~= "string" or "table" then
    return
  end
  if msg_type == "string" then
    msg = { { msg, hl } }
  end
  vim.api.nvim_echo(msg, true, {})
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function g.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      g.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
function g.profile(filename)
  local base = "/tmp/config/profile/"
  vim.fn.mkdir(base, "p")
  local success, profile = pcall(require, "plenary.profile.lua_profiler")
  if not success then
    vim.api.nvim_echo({ "Plenary is not installed.", "Title" }, true, {})
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. ".log"
    profile.report(logfile)
    vim.defer_fn(function()
      vim.cmd("tabedit " .. logfile)
    end, 1000)
  end
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function g.has(feature)
  return vim.fn.has(feature) > 0
end

---Check if directory exists using vim's isdirectory function
---@param path string
---@return boolean
function g.is_dir(path)
  return vim.fn.isdirectory(path) > 0
end

---Check if a vim variable usually a number is truthy or not
---@param value integer
function g.truthy(value)
  assert(type(value) == "number", string.format("Value should be a number but you passed %s", value))
  return value > 0
end

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function g.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function g.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "string" then
    return item == ""
  elseif item_type == "table" then
    return vim.tbl_isempty(item)
  end
end

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function g.has_map(lhs, mode)
  mode = mode or "n"
  return vim.fn.maparg(lhs, mode) ~= ""
end

local function validate_opts(opts)
  if not opts then
    return true
  end

  if type(opts) ~= "table" then
    return false, "opts should be a table"
  end

  if opts.buffer and type(opts.buffer) ~= "number" then
    return false, "The buffer key should be a number"
  end

  return true
end

function g.command(args)
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == "table") and table.concat(args.types, " ") or ""

  if type(rhs) == "function" then
    local fn_id = g._create(rhs)
    rhs = string.format("lua g._execute(%d%s)", fn_id, nargs > 0 and ", <f-args>" or "")
  end

  vim.cmd(string.format("command! -nargs=%s %s %s %s", nargs, types, name, rhs))
end

function g.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= "_G" and value and vim.fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

local function get_last_notification()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "vim-notify" and vim.api.nvim_win_is_valid(win) then
      return vim.api.nvim_win_get_config(win)
    end
  end
end

local notification_hl = setmetatable({
  [2] = { "FloatBorder:NvimNotificationError", "NormalFloat:NvimNotificationError" },
  [1] = { "FloatBorder:NvimNotificationInfo", "NormalFloat:NvimNotificationInfo" },
}, {
  __index = function(t, _)
    return t[1]
  end,
})

---Utility function to create a notification message
---@param lines string[] | string
---@param opts table
function g.notify(lines, opts)
  lines = type(lines) == "string" and { lines } or lines
  lines = vim.tbl_flatten(vim.tbl_map(function(line)
    return vim.split(line, "\n")
  end, lines))
  opts = opts or {}
  local highlights = { "Normal:NormalAlt" }

  local level = opts.log_level or 1
  local timeout = opts.timeout or 5000

  local width
  for i, line in ipairs(lines) do
    line = "  " .. line .. "  "
    lines[i] = line
    local length = #line
    if not width or width < length then
      width = length
    end
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local height = #lines
  local prev = get_last_notification()
  local row = prev and prev.row[false] - prev.height - 2 or vim.o.lines - vim.o.cmdheight - 3
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width + 2,
    height = height,
    col = vim.o.columns - 2,
    row = row,
    anchor = "SE",
    style = "minimal",
    focusable = false,
    border = "rounded",
  })

  local level_hl = notification_hl[level]
  vim.list_extend(highlights, level_hl)
  vim.api.nvim_win_set_option(win, "winhighlight", table.concat(highlights, ","))
  vim.api.nvim_win_set_option(win, "cursorline", false)
  vim.api.nvim_win_set_option(win, "wrap", true)
  --vim.api.nvim_buf_set_option(buf, "filetype", "vim-notify")

  if timeout then
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, timeout)
  end
end

function g.replace_termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function g.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, 2, { title = string.format("Error requiring: %s", module) })
  end
  return ok, result
end
