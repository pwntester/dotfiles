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
    "codeql_mvra",
    "packer",
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
    "NvimTree",
    "Yanil",
    "neo-tree",
    "toggleterm"
  },
}

-----------------------------------------------------------------------------//
-- Global functions
-----------------------------------------------------------------------------//

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
  require("octo.pickers.telescope.provider").issues { repo = "pwntester/bitacora", states = "OPEN" }
end

function g.LabIssues()
  require("octo.pickers.telescope.provider").issues { repo = "github/pe-security-lab" }
end

function g.HubberReports()
  require("octo.pickers.telescope.provider").issues {
    repo = "github/pe-security-lab",
    labels = "Vulnerability report",
    states = "OPEN",
  }
end

function g.VulnReports()
  require("octo.pickers.telescope.provider").issues { repo = "github/securitylab_vulnerabilities" }
end

function g.BountySubmissions()
  require("octo.pickers.telescope.provider").issues { repo = "github/securitylab-bounties", states = "OPEN" }
end

---Reload lua modules
function g.R(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= '_G' and value and vim.fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end
