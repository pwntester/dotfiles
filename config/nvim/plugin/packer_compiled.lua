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
  ["Navigator.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/Navigator.nvim"
  },
  ["better-escape.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/better-escape.vim"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/bufdelete.nvim"
  },
  ["bullets.vim"] = {
    config = { "\27LJ\2\nN\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\3\0\0\rmarkdown\tocto\31bullets_enabled_file_types\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/bullets.vim"
  },
  ["codeql.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\3\0\0-/Users/pwntester/codeql-home/codeql-repo+/Users/pwntester/codeql-home/codeql-go\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/codeql.nvim"
  },
  ["committia.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/committia.vim"
  },
  ["completion-treesitter"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/completion-treesitter"
  },
  ["dashboard-nvim"] = {
    config = { "\27LJ\2\n�\20\0\0\4\0\29\0)6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\n\0005\2\b\0005\3\a\0=\3\t\2=\2\v\0015\2\r\0005\3\f\0=\3\t\2=\2\14\0015\2\16\0005\3\15\0=\3\t\2=\2\17\0015\2\19\0005\3\18\0=\3\t\2=\2\20\0015\2\22\0005\3\21\0=\3\t\2=\2\23\0015\2\25\0005\3\24\0=\3\t\2=\2\26\0015\2\28\0005\3\27\0=\3\t\2=\2\1\1=\1\6\0K\0\1\0\1\0\1\fcommand&:e ~/.config/nvim/lua/plugins.lua\1\2\0\0\30  Config              \6f\1\0\1\fcommand\24Telescope live_grep\1\2\0\0\30  CWD Grep            \6e\1\0\1\fcommand\16SessionLoad\1\2\0\0\30  Load Last Session   \6d\1\0\1\fcommand\23Telescope frecency\1\2\0\0\30  Recently Used Files \6c\1\0\1\fcommand\25Telescope find_files\1\2\0\0\30  Find File           \6b\1\0\1\fcommand\nInbox\1\2\0\0\30  GitHub Notifications\6a\1\0\0\16description\1\0\1\fcommand\tTODO\1\2\0\0\30  ToDo                \29dashboard_custom_section\1\6\0\0�\2███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  �\3██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ �\3███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  �\3     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    �\3███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    \28dashboard_custom_header\14telescope dashboard_default_executive\6g\bvim\0" },
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
    config = { "\27LJ\2\n�\6\0\0\5\0\24\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0005\4\17\0=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\2B\0\2\1K\0\1\0\16watch_index\1\0\1\rinterval\3�\a\fkeymaps\tn [h\1\2\1\0@&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'\texpr\2\tn ]h\1\2\1\0@&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'\texpr\2\1\0\6\17n <leader>hs0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\vbuffer\2\17n <leader>hu5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17n <leader>hp2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17n <leader>hr0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\fnoremap\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ahl\19GitSignsChange\ttext\6~\14topdelete\1\0\2\ahl\19GitSignsDelete\ttext\b‾\vdelete\1\0\2\ahl\19GitSignsDelete\ttext\6_\vchange\1\0\2\ahl\19GitSignsChange\ttext\6~\badd\1\0\0\1\0\2\ahl\16GitSignsAdd\ttext\6+\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goto-preview"] = {
    config = { "\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\21default_mappings\1\nwidth\3x\ndebug\1\vheight\3\15\nsetup\17goto-preview\frequire\0" },
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
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\18init_lsp_saga\flspsaga\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
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
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\b\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0016\0\0\0'\2\6\0B\0\2\0029\0\2\0005\2\a\0B\0\2\1K\0\1\0\1\0\2\vmap_cr\2\17map_complete\2$nvim-autopairs.completion.compe\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-comment"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17nvim_comment\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-comment"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18plugins.compe\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-compe"
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
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeFindFile" },
    config = { "\27LJ\2\n�\3\0\0\2\0\16\0.6\0\0\0009\0\1\0)\1\30\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\5\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0006\1\1\0009\1\b\1=\1\a\0006\0\0\0009\0\1\0)\1\0\0=\1\t\0006\0\0\0009\0\1\0)\1\0\0=\1\n\0006\0\0\0009\0\1\0)\1\1\0=\1\v\0006\0\0\0009\0\1\0)\1\1\0=\1\f\0006\0\0\0009\0\1\0)\1\1\0=\1\r\0006\0\0\0009\0\1\0005\1\15\0=\1\14\0K\0\1\0\1\0\3\ffolders\3\1\nfiles\3\1\bgit\3\0\25nvim_tree_show_icons\26nvim_tree_group_empty\27nvim_tree_add_trailing\28nvim_tree_hide_dotfiles\21nvim_tree_follow\27nvim_tree_quit_on_open\20special_buffers\29nvim_tree_auto_ignore_ft\24nvim_tree_gitignore\24nvim_tree_auto_open\1\2\0\0\t.git\21nvim_tree_ignore\20nvim_tree_width\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
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
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
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
  ["rainbow_parentheses.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/rainbow_parentheses.vim"
  },
  ["sql.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/sql.nvim"
  },
  ["telescope-cheat.nvim"] = {
    config = { "\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ncheat\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-cheat.nvim"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim"
  },
  ["telescope-project.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-project.nvim"
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
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-easy-align"
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
    config = { "\27LJ\2\nL\0\0\2\0\4\0\0066\0\0\0009\0\1\0006\1\1\0009\1\3\1=\1\2\0K\0\1\0\20special_buffers\27Illuminate_ftblacklist\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-illuminate"
  },
  ["vim-ripgrep"] = {
    config = { "\27LJ\2\nW\0\0\2\0\5\0\t6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0K\0\1\0\1\2\0\0\t.git\18rg_root_types\19rg_derive_root\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-ripgrep"
  },
  ["vim-rooter"] = {
    config = { "\27LJ\2\n�\1\0\0\2\0\v\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0K\0\1\0\fcurrent2rooter_change_directory_for_non_project_files\24rooter_silent_chdir\1\2\0\0\t.git\20rooter_patterns\b/,*\19rooter_targets\acd\18rooter_cd_cmd\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-scriptease"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-scriptease"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-wordmotion"] = {
    config = { "\27LJ\2\n<\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\r<Leader>\22wordmotion_prefix\6g\bvim\0" },
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
-- Config for: vim-wordmotion
time([[Config for vim-wordmotion]], true)
try_loadstring("\27LJ\2\n<\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\r<Leader>\22wordmotion_prefix\6g\bvim\0", "config", "vim-wordmotion")
time([[Config for vim-wordmotion]], false)
-- Config for: nvim-bufferline.lua
time([[Config for nvim-bufferline.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0", "config", "nvim-bufferline.lua")
time([[Config for nvim-bufferline.lua]], false)
-- Config for: nvim-comment
time([[Config for nvim-comment]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17nvim_comment\frequire\0", "config", "nvim-comment")
time([[Config for nvim-comment]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18plugins.compe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: nvim-jdtls
time([[Config for nvim-jdtls]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14setup_jdt\15lsp_config\frequire\0", "config", "nvim-jdtls")
time([[Config for nvim-jdtls]], false)
-- Config for: telescope-cheat.nvim
time([[Config for telescope-cheat.nvim]], true)
try_loadstring("\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ncheat\19load_extension\14telescope\frequire\0", "config", "telescope-cheat.nvim")
time([[Config for telescope-cheat.nvim]], false)
-- Config for: bullets.vim
time([[Config for bullets.vim]], true)
try_loadstring("\27LJ\2\nN\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\3\0\0\rmarkdown\tocto\31bullets_enabled_file_types\6g\bvim\0", "config", "bullets.vim")
time([[Config for bullets.vim]], false)
-- Config for: telescope-frecency.nvim
time([[Config for telescope-frecency.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")
time([[Config for telescope-frecency.nvim]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\rmappings\vstatus\1\0\0\1\0\1\6>\vToggle\17integrations\1\0\1 disable_commit_confirmation\2\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: telescope-project.nvim
time([[Config for telescope-project.nvim]], true)
try_loadstring("\27LJ\2\nL\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fproject\19load_extension\14telescope\frequire\0", "config", "telescope-project.nvim")
time([[Config for telescope-project.nvim]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
try_loadstring("\27LJ\2\n�\20\0\0\4\0\29\0)6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\n\0005\2\b\0005\3\a\0=\3\t\2=\2\v\0015\2\r\0005\3\f\0=\3\t\2=\2\14\0015\2\16\0005\3\15\0=\3\t\2=\2\17\0015\2\19\0005\3\18\0=\3\t\2=\2\20\0015\2\22\0005\3\21\0=\3\t\2=\2\23\0015\2\25\0005\3\24\0=\3\t\2=\2\26\0015\2\28\0005\3\27\0=\3\t\2=\2\1\1=\1\6\0K\0\1\0\1\0\1\fcommand&:e ~/.config/nvim/lua/plugins.lua\1\2\0\0\30  Config              \6f\1\0\1\fcommand\24Telescope live_grep\1\2\0\0\30  CWD Grep            \6e\1\0\1\fcommand\16SessionLoad\1\2\0\0\30  Load Last Session   \6d\1\0\1\fcommand\23Telescope frecency\1\2\0\0\30  Recently Used Files \6c\1\0\1\fcommand\25Telescope find_files\1\2\0\0\30  Find File           \6b\1\0\1\fcommand\nInbox\1\2\0\0\30  GitHub Notifications\6a\1\0\0\16description\1\0\1\fcommand\tTODO\1\2\0\0\30  ToDo                \29dashboard_custom_section\1\6\0\0�\2███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  �\3██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ �\3███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  �\3     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    �\3███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    \28dashboard_custom_header\14telescope dashboard_default_executive\6g\bvim\0", "config", "dashboard-nvim")
time([[Config for dashboard-nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\nT\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\30reaction_viewer_hint_icon\5\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: vim-choosewin
time([[Config for vim-choosewin]], true)
try_loadstring("\27LJ\2\n:\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\29choosewin_overlay_enable\6g\bvim\0", "config", "vim-choosewin")
time([[Config for vim-choosewin]], false)
-- Config for: nautilus.nvim
time([[Config for nautilus.nvim]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tmode\tgrey\nsetup\rnautilus\frequire\0", "config", "nautilus.nvim")
time([[Config for nautilus.nvim]], false)
-- Config for: codeql.nvim
time([[Config for codeql.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\3\0\0-/Users/pwntester/codeql-home/codeql-repo+/Users/pwntester/codeql-home/codeql-go\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0", "config", "codeql.nvim")
time([[Config for codeql.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lsp_config\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\n\0\0186\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0006\1\0\0009\1\5\0016\3\0\0009\3\6\0039\3\a\0036\5\1\0009\5\b\5B\3\2\0025\4\t\0B\1\3\2=\1\4\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend&indent_blankline_filetype_exclude\a¦\26indent_blankline_char\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: vim-http-client
time([[Config for vim-http-client]], true)
try_loadstring("\27LJ\2\n�\2\0\0\3\0\t\0\0216\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Bautocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>\bcmd#http_client_preserve_responses$http_client_focus_output_window\15javascript\24http_client_json_ft\28http_client_bind_hotkey\6g\bvim\0", "config", "vim-http-client")
time([[Config for vim-http-client]], false)
-- Config for: gitlinker.nvim
time([[Config for gitlinker.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14gitlinker\frequire\0", "config", "gitlinker.nvim")
time([[Config for gitlinker.nvim]], false)
-- Config for: goto-preview
time([[Config for goto-preview]], true)
try_loadstring("\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\21default_mappings\1\nwidth\3x\ndebug\1\vheight\3\15\nsetup\17goto-preview\frequire\0", "config", "goto-preview")
time([[Config for goto-preview]], false)
-- Config for: vim-illuminate
time([[Config for vim-illuminate]], true)
try_loadstring("\27LJ\2\nL\0\0\2\0\4\0\0066\0\0\0009\0\1\0006\1\1\0009\1\3\1=\1\2\0K\0\1\0\20special_buffers\27Illuminate_ftblacklist\6g\bvim\0", "config", "vim-illuminate")
time([[Config for vim-illuminate]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\b\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\0016\0\0\0'\2\6\0B\0\2\0029\0\2\0005\2\a\0B\0\2\1K\0\1\0\1\0\2\vmap_cr\2\17map_complete\2$nvim-autopairs.completion.compe\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: lspsaga.nvim
time([[Config for lspsaga.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\18init_lsp_saga\flspsaga\frequire\0", "config", "lspsaga.nvim")
time([[Config for lspsaga.nvim]], false)
-- Config for: vim-ripgrep
time([[Config for vim-ripgrep]], true)
try_loadstring("\27LJ\2\nW\0\0\2\0\5\0\t6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0K\0\1\0\1\2\0\0\t.git\18rg_root_types\19rg_derive_root\6g\bvim\0", "config", "vim-ripgrep")
time([[Config for vim-ripgrep]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: Navigator.nvim
time([[Config for Navigator.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14Navigator\frequire\0", "config", "Navigator.nvim")
time([[Config for Navigator.nvim]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\n�\1\0\0\2\0\v\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0K\0\1\0\fcurrent2rooter_change_directory_for_non_project_files\24rooter_silent_chdir\1\2\0\0\t.git\20rooter_patterns\b/,*\19rooter_targets\acd\18rooter_cd_cmd\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: mkdx
time([[Config for mkdx]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17plugins.mkdx\frequire\0", "config", "mkdx")
time([[Config for mkdx]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n�\6\0\0\5\0\24\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0005\4\17\0=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\2B\0\2\1K\0\1\0\16watch_index\1\0\1\rinterval\3�\a\fkeymaps\tn [h\1\2\1\0@&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'\texpr\2\tn ]h\1\2\1\0@&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'\texpr\2\1\0\6\17n <leader>hs0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\vbuffer\2\17n <leader>hu5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17n <leader>hp2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17n <leader>hr0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\fnoremap\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ahl\19GitSignsChange\ttext\6~\14topdelete\1\0\2\ahl\19GitSignsDelete\ttext\b‾\vdelete\1\0\2\ahl\19GitSignsDelete\ttext\6_\vchange\1\0\2\ahl\19GitSignsChange\ttext\6~\badd\1\0\0\1\0\2\ahl\16GitSignsAdd\ttext\6+\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\23plugins.galaxyline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
