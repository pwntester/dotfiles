-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/pwntester/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/pwntester/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/pwntester/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/pwntester/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/pwntester/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/Comment.nvim"
  },
  ["TrueZen.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17integrations\1\0\0\1\0\14\14limelight\1\20nvim_bufferline\2\ttmux\2\15galaxyline\2\18vim_gitgutter\1\16vim_signify\1\vfeline\1\14lightline\1\flualine\1\17express_line\1\rgitsigns\2\18vim_powerline\1\16vim_airline\1\rtwilight\1\nsetup\rtrue-zen\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/TrueZen.nvim"
  },
  ["better-escape.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/better-escape.vim"
  },
  ["close-buffers.nvim"] = {
    config = { "\27LJ\2\n�\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6�6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5�K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequire�\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\2\0\0\tthis\20filetype_ignore\1\0\0\nsetup\18close_buffers\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/close-buffers.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-vsnip"
  },
  ["codeql.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\4\0\0(/Users/pwntester/codeql-home/codeql+/Users/pwntester/codeql-home/codeql-go-/Users/pwntester/codeql-home/codeql-ruby\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/codeql.nvim"
  },
  ["completion-treesitter"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/completion-treesitter"
  },
  ["crane.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ncrane\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/crane.nvim"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n�\20\0\0\4\0\29\0)6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\n\0005\2\b\0005\3\a\0=\3\t\2=\2\v\0015\2\r\0005\3\f\0=\3\t\2=\2\14\0015\2\16\0005\3\15\0=\3\t\2=\2\17\0015\2\19\0005\3\18\0=\3\t\2=\2\20\0015\2\22\0005\3\21\0=\3\t\2=\2\23\0015\2\25\0005\3\24\0=\3\t\2=\2\26\0015\2\28\0005\3\27\0=\3\t\2=\2\1\1=\1\6\0K\0\1\0\1\0\1\fcommand&:e ~/.config/nvim/lua/plugins.lua\1\2\0\0\30  Config              \6f\1\0\1\fcommand\24Telescope live_grep\1\2\0\0\30  CWD Grep            \6e\1\0\1\fcommand\16SessionLoad\1\2\0\0\30  Load Last Session   \6d\1\0\1\fcommand\23Telescope frecency\1\2\0\0\30  Recently Used Files \6c\1\0\1\fcommand\25Telescope find_files\1\2\0\0\30  Find File           \6b\1\0\1\fcommand\nInbox\1\2\0\0\30  GitHub Notifications\6a\1\0\0\16description\1\0\1\fcommand\tTODO\1\2\0\0\30  ToDo                \29dashboard_custom_section\1\b\0\0\5\5�\2███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  �\3██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ �\3███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  �\3     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    �\3███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    \28dashboard_custom_header\14telescope dashboard_default_executive\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["dial.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/dial.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/diffview.nvim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\23plugins.galaxyline\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["gitlinker.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14gitlinker\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n:\0\0\1\0\4\0\b6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\2�+\0\1\0L\0\2\0K\0\1\0\rmarkdown\aft\abo\bvim�\3\1\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\0025\3\18\0=\3\19\0023\3\20\0=\3\21\2B\0\2\1K\0\1\0\14on_attach\0\16watch_index\1\0\1\rinterval\3�\a\fkeymaps\1\0\2\vbuffer\2\fnoremap\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ttext\6~\ahl\19GitSignsChange\14topdelete\1\0\2\ttext\b‾\ahl\19GitSignsDelete\vdelete\1\0\2\ttext\6_\ahl\19GitSignsDelete\vchange\1\0\2\ttext\6~\ahl\19GitSignsChange\badd\1\0\0\1\0\2\ttext\6+\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goto-preview"] = {
    config = { "\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\21default_mappings\1\vheight\3\15\ndebug\1\nwidth\3x\nsetup\17goto-preview\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/goto-preview"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\n\0\0186\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0006\1\0\0009\1\5\0016\3\0\0009\3\6\0039\3\a\0036\5\1\0009\5\b\5B\3\2\0025\4\t\0B\1\3\2=\1\4\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend&indent_blankline_filetype_exclude\a¦\26indent_blankline_char\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  mkdx = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17plugins.mkdx\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/mkdx"
  },
  ["nautilus.nvim"] = {
    config = { "\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tmode\tgrey\nsetup\rnautilus\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nautilus.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n�\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\rmappings\vstatus\1\0\0\1\0\1\6>\vToggle\17integrations\1\0\1 disable_commit_confirmation\2\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n-\0\1\4\0\2\0\0039\1\0\0'\3\1\0D\1\2\0\16stylua.toml\18root_has_file�\2\1\0\b\0\18\1!6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0004\3\3\0006\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\4\0049\4\5\0049\4\6\0045\6\b\0003\a\a\0=\a\t\6B\4\2\0?\4\0\0=\3\v\2B\0\2\0016\0\0\0'\2\f\0B\0\2\0029\0\1\0009\0\r\0005\2\16\0006\3\0\0'\5\14\0B\3\2\0029\3\15\3=\3\17\2B\0\2\1K\0\1\0\14on_attach\1\0\0\23on_attach_callback\15lsp_config\nsetup\14lspconfig\fsources\1\0\0\14condition\1\0\0\0\twith\vstylua\15formatting\rbuiltins\vconfig\fnull-ls\frequire\3����\4\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n�\1\0\0\t\0\v\0\0196\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3B\1\2\0016\1\0\0'\3\6\0B\1\2\0029\2\a\0\18\4\1\0'\6\b\0'\a\t\0'\b\n\0B\4\4\0A\2\0\1K\0\1\0\aql\5\6|\radd_rule\24nvim-autopairs.rule\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21plugins.nvim-cmp\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-jdtls"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14setup_jdt\15lsp_config\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-jdtls"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lsp_config\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\n2\0\0\4\0\3\0\0066\0\0\0006\1\2\0'\3\1\0B\1\2\2=\1\1\0K\0\1\0\frequire\vnotify\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-notify"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeFindFile" },
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.nvim-tree\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["octo-notifications.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/octo-notifications.nvim"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\nT\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\30reaction_viewer_hint_icon\5\nsetup\tocto\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/octo.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n�\2\0\0\6\0\17\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0024\3\0\0=\3\v\0026\3\f\0009\3\r\0039\3\14\3'\5\15\0B\3\2\2=\3\16\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\3\0\0\t.git\17package.json\22detection_methods\1\0\2\17silent_chdir\2\16manual_mode\1\1\3\0\0\blsp\fpattern\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/project.nvim"
  },
  ["rainbow_parentheses.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/rainbow_parentheses.vim"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/sql.nvim"
  },
  ["tabout.nvim"] = {
    config = { "\27LJ\2\n�\2\0\0\5\0\f\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\a\0005\4\4\0>\4\1\0035\4\5\0>\4\2\0035\4\6\0>\4\3\0035\4\a\0>\4\4\0035\4\b\0>\4\5\0035\4\t\0>\4\6\3=\3\n\0024\3\0\0=\3\v\2B\0\2\1K\0\1\0\fexclude\ftabouts\1\0\2\topen\6{\nclose\6}\1\0\2\topen\6[\nclose\6]\1\0\2\topen\6(\nclose\6)\1\0\2\topen\6`\nclose\6`\1\0\2\topen\6\"\nclose\6\"\1\0\2\topen\6'\nclose\6'\1\0\a\15act_as_tab\2\21backwards_tabkey\f<S-Tab>\vtabkey\n<Tab>\21ignore_beginning\2\15completion\1\21enable_backwards\2\21act_as_shift_tab\1\nsetup\vtabout\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/tabout.nvim",
    wants = { "nvim-treesitter" }
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/trouble.nvim"
  },
  ["vim-choosewin"] = {
    config = { "\27LJ\2\n:\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\29choosewin_overlay_enable\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-choosewin"
  },
  ["vim-easy-align"] = {
    keys = { { "", "<Plug>(EasyAlign)" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-http"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-http"
  },
  ["vim-http-client"] = {
    config = { "\27LJ\2\n�\2\0\0\3\0\t\0\0216\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Bautocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>\bcmd#http_client_preserve_responses$http_client_focus_output_window\15javascript\24http_client_json_ft\28http_client_bind_hotkey\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-http-client"
  },
  ["vim-illuminate"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\b\0\0146\0\0\0009\0\1\0006\1\0\0009\1\3\0016\3\0\0009\3\4\0039\3\5\0036\5\1\0009\5\6\5B\3\2\0025\4\a\0B\1\3\2=\1\2\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend\27Illuminate_ftblacklist\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-illuminate"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-wordmotion"] = {
    config = { "\27LJ\2\n5\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\6_\22wordmotion_prefix\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-wordmotion"
  },
  ["vscode-codeql"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vscode-codeql"
  },
  ["vscode-java-snippets"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vscode-java-snippets"
  },
  ["vscode-python-snippets"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vscode-python-snippets"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^nvim%-web%-devicons"] = "nvim-web-devicons"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: goto-preview
time([[Config for goto-preview]], true)
try_loadstring("\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\21default_mappings\1\vheight\3\15\ndebug\1\nwidth\3x\nsetup\17goto-preview\frequire\0", "config", "goto-preview")
time([[Config for goto-preview]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\n-\0\1\4\0\2\0\0039\1\0\0'\3\1\0D\1\2\0\16stylua.toml\18root_has_file�\2\1\0\b\0\18\1!6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0004\3\3\0006\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\4\0049\4\5\0049\4\6\0045\6\b\0003\a\a\0=\a\t\6B\4\2\0?\4\0\0=\3\v\2B\0\2\0016\0\0\0'\2\f\0B\0\2\0029\0\1\0009\0\r\0005\2\16\0006\3\0\0'\5\14\0B\3\2\0029\3\15\3=\3\17\2B\0\2\1K\0\1\0\14on_attach\1\0\0\23on_attach_callback\15lsp_config\nsetup\14lspconfig\fsources\1\0\0\14condition\1\0\0\0\twith\vstylua\15formatting\rbuiltins\vconfig\fnull-ls\frequire\3����\4\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: vim-choosewin
time([[Config for vim-choosewin]], true)
try_loadstring("\27LJ\2\n:\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\29choosewin_overlay_enable\6g\bvim\0", "config", "vim-choosewin")
time([[Config for vim-choosewin]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21plugins.nvim-cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: vim-http-client
time([[Config for vim-http-client]], true)
try_loadstring("\27LJ\2\n�\2\0\0\3\0\t\0\0216\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Bautocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>\bcmd#http_client_preserve_responses$http_client_focus_output_window\15javascript\24http_client_json_ft\28http_client_bind_hotkey\6g\bvim\0", "config", "vim-http-client")
time([[Config for vim-http-client]], false)
-- Config for: vim-illuminate
time([[Config for vim-illuminate]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\b\0\0146\0\0\0009\0\1\0006\1\0\0009\1\3\0016\3\0\0009\3\4\0039\3\5\0036\5\1\0009\5\6\5B\3\2\0025\4\a\0B\1\3\2=\1\2\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend\27Illuminate_ftblacklist\6g\bvim\0", "config", "vim-illuminate")
time([[Config for vim-illuminate]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lsp_config\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n�\1\0\0\t\0\v\0\0196\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3B\1\2\0016\1\0\0'\3\6\0B\1\2\0029\2\a\0\18\4\1\0'\6\b\0'\a\t\0'\b\n\0B\4\4\0A\2\0\1K\0\1\0\aql\5\6|\radd_rule\24nvim-autopairs.rule\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: vim-wordmotion
time([[Config for vim-wordmotion]], true)
try_loadstring("\27LJ\2\n5\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\6_\22wordmotion_prefix\6g\bvim\0", "config", "vim-wordmotion")
time([[Config for vim-wordmotion]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
try_loadstring("\27LJ\2\n�\20\0\0\4\0\29\0)6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\n\0005\2\b\0005\3\a\0=\3\t\2=\2\v\0015\2\r\0005\3\f\0=\3\t\2=\2\14\0015\2\16\0005\3\15\0=\3\t\2=\2\17\0015\2\19\0005\3\18\0=\3\t\2=\2\20\0015\2\22\0005\3\21\0=\3\t\2=\2\23\0015\2\25\0005\3\24\0=\3\t\2=\2\26\0015\2\28\0005\3\27\0=\3\t\2=\2\1\1=\1\6\0K\0\1\0\1\0\1\fcommand&:e ~/.config/nvim/lua/plugins.lua\1\2\0\0\30  Config              \6f\1\0\1\fcommand\24Telescope live_grep\1\2\0\0\30  CWD Grep            \6e\1\0\1\fcommand\16SessionLoad\1\2\0\0\30  Load Last Session   \6d\1\0\1\fcommand\23Telescope frecency\1\2\0\0\30  Recently Used Files \6c\1\0\1\fcommand\25Telescope find_files\1\2\0\0\30  Find File           \6b\1\0\1\fcommand\nInbox\1\2\0\0\30  GitHub Notifications\6a\1\0\0\16description\1\0\1\fcommand\tTODO\1\2\0\0\30  ToDo                \29dashboard_custom_section\1\b\0\0\5\5�\2███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  �\3██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ �\3███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  �\3     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    �\3███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    \28dashboard_custom_header\14telescope dashboard_default_executive\6g\bvim\0", "config", "dashboard-nvim")
time([[Config for dashboard-nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\23plugins.galaxyline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\nT\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\30reaction_viewer_hint_icon\5\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\rmappings\vstatus\1\0\0\1\0\1\6>\vToggle\17integrations\1\0\1 disable_commit_confirmation\2\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: gitlinker.nvim
time([[Config for gitlinker.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14gitlinker\frequire\0", "config", "gitlinker.nvim")
time([[Config for gitlinker.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\n�\2\0\0\6\0\17\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0024\3\0\0=\3\v\0026\3\f\0009\3\r\0039\3\14\3'\5\15\0B\3\2\2=\3\16\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\3\0\0\t.git\17package.json\22detection_methods\1\0\2\17silent_chdir\2\16manual_mode\1\1\3\0\0\blsp\fpattern\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: nvim-jdtls
time([[Config for nvim-jdtls]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14setup_jdt\15lsp_config\frequire\0", "config", "nvim-jdtls")
time([[Config for nvim-jdtls]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\1\0\4\0\b6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\2�+\0\1\0L\0\2\0K\0\1\0\rmarkdown\aft\abo\bvim�\3\1\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\0025\3\18\0=\3\19\0023\3\20\0=\3\21\2B\0\2\1K\0\1\0\14on_attach\0\16watch_index\1\0\1\rinterval\3�\a\fkeymaps\1\0\2\vbuffer\2\fnoremap\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ttext\6~\ahl\19GitSignsChange\14topdelete\1\0\2\ttext\b‾\ahl\19GitSignsDelete\vdelete\1\0\2\ttext\6_\ahl\19GitSignsDelete\vchange\1\0\2\ttext\6~\ahl\19GitSignsChange\badd\1\0\0\1\0\2\ttext\6+\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: TrueZen.nvim
time([[Config for TrueZen.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17integrations\1\0\0\1\0\14\14limelight\1\20nvim_bufferline\2\ttmux\2\15galaxyline\2\18vim_gitgutter\1\16vim_signify\1\vfeline\1\14lightline\1\flualine\1\17express_line\1\rgitsigns\2\18vim_powerline\1\16vim_airline\1\rtwilight\1\nsetup\rtrue-zen\frequire\0", "config", "TrueZen.nvim")
time([[Config for TrueZen.nvim]], false)
-- Config for: codeql.nvim
time([[Config for codeql.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\4\0\0(/Users/pwntester/codeql-home/codeql+/Users/pwntester/codeql-home/codeql-go-/Users/pwntester/codeql-home/codeql-ruby\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0", "config", "codeql.nvim")
time([[Config for codeql.nvim]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: crane.nvim
time([[Config for crane.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ncrane\frequire\0", "config", "crane.nvim")
time([[Config for crane.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\n\0\0186\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0006\1\0\0009\1\5\0016\3\0\0009\3\6\0039\3\a\0036\5\1\0009\5\b\5B\3\2\0025\4\t\0B\1\3\2=\1\4\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend&indent_blankline_filetype_exclude\a¦\26indent_blankline_char\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\n2\0\0\4\0\3\0\0066\0\0\0006\1\2\0'\3\1\0B\1\2\2=\1\1\0K\0\1\0\frequire\vnotify\bvim\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: tabout.nvim
time([[Config for tabout.nvim]], true)
try_loadstring("\27LJ\2\n�\2\0\0\5\0\f\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\a\0005\4\4\0>\4\1\0035\4\5\0>\4\2\0035\4\6\0>\4\3\0035\4\a\0>\4\4\0035\4\b\0>\4\5\0035\4\t\0>\4\6\3=\3\n\0024\3\0\0=\3\v\2B\0\2\1K\0\1\0\fexclude\ftabouts\1\0\2\topen\6{\nclose\6}\1\0\2\topen\6[\nclose\6]\1\0\2\topen\6(\nclose\6)\1\0\2\topen\6`\nclose\6`\1\0\2\topen\6\"\nclose\6\"\1\0\2\topen\6'\nclose\6'\1\0\a\15act_as_tab\2\21backwards_tabkey\f<S-Tab>\vtabkey\n<Tab>\21ignore_beginning\2\15completion\1\21enable_backwards\2\21act_as_shift_tab\1\nsetup\vtabout\frequire\0", "config", "tabout.nvim")
time([[Config for tabout.nvim]], false)
-- Config for: close-buffers.nvim
time([[Config for close-buffers.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6�6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5�K\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequire�\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\2\0\0\tthis\20filetype_ignore\1\0\0\nsetup\18close_buffers\frequire\0", "config", "close-buffers.nvim")
time([[Config for close-buffers.nvim]], false)
-- Config for: nautilus.nvim
time([[Config for nautilus.nvim]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tmode\tgrey\nsetup\rnautilus\frequire\0", "config", "nautilus.nvim")
time([[Config for nautilus.nvim]], false)
-- Config for: telescope-frecency.nvim
time([[Config for telescope-frecency.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")
time([[Config for telescope-frecency.nvim]], false)
-- Config for: mkdx
time([[Config for mkdx]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17plugins.mkdx\frequire\0", "config", "mkdx")
time([[Config for mkdx]], false)
-- Config for: nvim-bufferline.lua
time([[Config for nvim-bufferline.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0", "config", "nvim-bufferline.lua")
time([[Config for nvim-bufferline.lua]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <Plug>(EasyAlign) <cmd>lua require("packer.load")({'vim-easy-align'}, { keys = "<lt>Plug>(EasyAlign)", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
