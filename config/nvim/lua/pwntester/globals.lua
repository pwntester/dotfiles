local vim = vim

-----------------------------------------------------------------------------//
-- Global namespace
-----------------------------------------------------------------------------//

local M = {}

M.special_buffers = {
  "help",
  "fortifytestpane",
  "fortifyauditpane",
  "qf",
  "goterm",
  "codeql_panel",
  "codeql_explorer",
  "codeql_mrva",
  "packer",
  "octo",
  "octo_panel",
  "aerieal",
  "Trouble",
  --"frecency",
  --"TelescopePrompt",
  --"TelescopeResults",
  "NeogitStatus",
  "notify",
  "NvimTree",
  "Yanil",
  "neo-tree",
  "toggleterm",
  "noice",
  "fidget",
  "lazy",
  --"dashboard",
  --"dashboardpreview",
  --"alpha",
  "neotest-output",
  "neotest-summary",
  "neotest-output-panel",
}

-----------------------------------------------------------------------------//
-- Global functions
-----------------------------------------------------------------------------//
function M.is_loaded(name)
  local Config = require "lazy.core.config"
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.setTimeout(delay, callback, ...)
  local timer = vim.loop.new_timer()
  local args = { ... }
  vim.loop.timer_start(timer, delay, 0, function()
    vim.loop.timer_stop(timer)
    vim.loop.close(timer)
    callback(unpack(args))
  end)
  return timer
end

function M.map(mappings, defaults, bufnr)
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
      local noremap_opt = opts.noremap
      opts = { expr = true, noremap = noremap_opt }
    end
    if bufnr then
      opts.buffer = bufnr
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- ALIASES
function M.alias(from, to, buffer)
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
function M.openURL()
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
function M.TODO()
  require("octo.utils").get_issue("pwntester/bitacora", 41)
end

function M.Bitacora()
  require("octo.pickers.telescope.provider").issues { repo = "pwntester/bitacora", states = "OPEN" }
end

function M.LabIssues()
  require("octo.pickers.telescope.provider").issues { repo = "github/pe-security-lab" }
end

function M.HubberReports()
  require("octo.pickers.telescope.provider").issues {
    repo = "github/pe-security-lab",
    labels = "Vulnerability report",
    states = "OPEN",
  }
end

function M.VulnReports()
  require("octo.pickers.telescope.provider").issues { repo = "github/securitylab_vulnerabilities" }
end

function M.BountySubmissions()
  require("octo.pickers.telescope.provider").issues { repo = "github/securitylab-bounties", states = "OPEN" }
end

return M
