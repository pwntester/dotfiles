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
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
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
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\nµ\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0015\3\4\0B\1\2\0016\1\0\0'\3\5\0B\1\2\0029\1\6\1B\1\1\1K\0\1\0\14lazy_load luasnip/loaders/from_vscode\1\0\2\17updateevents\29TextChanged,TextChangedI\fhistory\2\15set_config\vconfig\fluasnip\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["TrueZen.nvim"] = {
    config = { "\27LJ\2\nç\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17integrations\1\0\0\1\0\f\16vim_signify\1\vfeline\1\14lightline\1\flualine\1\17express_line\1\rgitsigns\2\18vim_powerline\1\16vim_airline\1\rtwilight\1\14limelight\1\20nvim_bufferline\2\18vim_gitgutter\1\nsetup\rtrue-zen\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/TrueZen.nvim",
    url = "https://github.com/Pocco81/TrueZen.nvim"
  },
  ["better-escape.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/better-escape.vim",
    url = "https://github.com/jdhao/better-escape.vim"
  },
  ["clipboard-image.nvim"] = {
    config = { "\27LJ\2\n¦\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmarkdown\1\0\0\1\0\3\naffix\f![](%s)\16img_dir_txt\26resources/attachments\fimg_dir\26resources/attachments\nsetup\20clipboard-image\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/clipboard-image.nvim",
    url = "https://github.com/ekickx/clipboard-image.nvim"
  },
  ["close-buffers.nvim"] = {
    config = { "\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6€6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5øK\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequire›\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\2\0\0\tthis\20filetype_ignore\1\0\0\nsetup\18close_buffers\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/close-buffers.nvim",
    url = "https://github.com/kazhala/close-buffers.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-cmdline-history"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-cmdline-history",
    url = "https://github.com/dmitmel/cmp-cmdline-history"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["codeql.nvim"] = {
    config = { "\27LJ\2\nð\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\4\0\0(/Users/pwntester/codeql-home/codeql+/Users/pwntester/codeql-home/codeql-go-/Users/pwntester/codeql-home/codeql-ruby\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/codeql.nvim",
    url = "/Users/pwntester/dev/personal/codeql.nvim"
  },
  ["completion-treesitter"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/completion-treesitter",
    url = "https://github.com/nvim-treesitter/completion-treesitter"
  },
  ["copilot.vim"] = {
    after = { "tabout.nvim" },
    loaded = true,
    only_config = true
  },
  ["dial.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitlinker.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14gitlinker\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/gitlinker.nvim",
    url = "https://github.com/ruifm/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n:\0\0\1\0\4\0\b6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\2€+\0\1\0L\0\2\0K\0\1\0\rmarkdown\aft\abo\bvim”\3\1\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\0025\3\18\0=\3\19\0023\3\20\0=\3\21\2B\0\2\1K\0\1\0\14on_attach\0\16watch_index\1\0\1\rinterval\3è\a\fkeymaps\1\0\2\fnoremap\2\vbuffer\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ttext\6~\ahl\19GitSignsChange\14topdelete\1\0\2\ttext\bâ€¾\ahl\19GitSignsDelete\vdelete\1\0\2\ttext\6_\ahl\19GitSignsDelete\vchange\1\0\2\ttext\6~\ahl\19GitSignsChange\badd\1\0\0\1\0\2\ttext\6+\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goto-preview"] = {
    config = { "\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\nwidth\3x\21default_mappings\1\ndebug\1\vheight\3\15\nsetup\17goto-preview\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/goto-preview",
    url = "https://github.com/rmagatti/goto-preview"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nÅ\1\0\0\6\0\n\0\0186\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0006\1\0\0009\1\5\0016\3\0\0009\3\6\0039\3\a\0036\5\1\0009\5\b\5B\3\2\0025\4\t\0B\1\3\2=\1\4\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend&indent_blankline_filetype_exclude\aÂ¦\26indent_blankline_char\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lsp-command"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lsp-command",
    url = "https://github.com/ii14/lsp-command"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["nautilus.nvim"] = {
    config = { "\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tmode\tgrey\nsetup\rnautilus\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nautilus.nvim",
    url = "/Users/pwntester/dev/personal/nautilus.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n©\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\rmappings\vstatus\1\0\0\1\0\1\6>\vToggle\17integrations\1\0\1 disable_commit_confirmation\2\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nÛ\2\0\0\n\0\17\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\6\0005\6\5\0=\6\a\5B\3\2\0019\3\b\0\18\5\2\0'\a\t\0'\b\n\0'\t\v\0B\5\4\0A\3\0\0016\3\0\0'\5\f\0B\3\2\0029\4\r\3\18\6\4\0009\4\14\4'\a\15\0009\b\16\1B\b\1\0A\4\2\1K\0\1\0\20on_confirm_done\17confirm_done\aon\nevent\bcmp\aql\5\6|\radd_rule\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\24nvim-autopairs.rule\"nvim-autopairs.completion.cmp\19nvim-autopairs\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    after = { "LuaSnip", "nvim-autopairs", "tabout.nvim" },
    loaded = true,
    only_config = true
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-hlslens"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\17nearest_only\2\14calm_down\2\nsetup\fhlslens\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-jdtls"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14setup_jdt\18pwntester.lsp\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18pwntester.lsp\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nÒ\1\0\0\4\0\a\0\0146\0\0\0006\1\2\0'\3\1\0B\1\2\2=\1\1\0006\0\2\0'\2\1\0B\0\2\0029\0\3\0005\2\4\0005\3\5\0=\3\6\2B\0\2\1K\0\1\0\nicons\1\0\5\nTRACE\bâœŽ\nERROR\bï—\tWARN\bïª\tINFO\bïš\nDEBUG\bï†ˆ\1\0\3\ftimeout\3ˆ'\vstages\22fade_in_slide_out\22background_colour\f#ffcc66\nsetup\frequire\vnotify\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nå\2\0\0\3\0\15\0\0276\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0006\0\0\0009\0\1\0005\1\a\0006\2\1\0009\2\6\2=\2\b\0015\2\t\0=\2\n\1=\1\5\0006\0\0\0009\0\1\0)\1\3\0=\1\v\0006\0\f\0'\2\r\0B\0\2\0029\0\14\0B\0\1\1K\0\1\0\nsetup\22plugins.nvim-tree\frequire%nvim_tree_highlight_opened_files\fbuftype\1\2\0\0\rterminal\rfiletype\1\0\0\20special_buffers$nvim_tree_window_picker_exclude\1\0\4\18folder_arrows\3\1\nfiles\3\1\ffolders\3\1\bgit\3\0\25nvim_tree_show_icons\30nvim_tree_respect_buf_cwd\6g\bvim\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\nT\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\30reaction_viewer_hint_icon\5\nsetup\tocto\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/octo.nvim",
    url = "/Users/pwntester/dev/personal/octo.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n¢\2\0\0\6\0\17\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0024\3\0\0=\3\v\0026\3\f\0009\3\r\0039\3\14\3'\5\15\0B\3\2\2=\3\16\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\2\0\0\t.git\22detection_methods\1\0\2\16manual_mode\1\17silent_chdir\2\1\3\0\0\blsp\fpattern\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  ["rainbow_parentheses.vim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/rainbow_parentheses.vim",
    url = "https://github.com/junegunn/rainbow_parentheses.vim"
  },
  ["renamer.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\frenamer\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/renamer.nvim",
    url = "https://github.com/filipdutescu/renamer.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["surround.nvim"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19mappings_style\rsandwich\nsetup\rsurround\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/surround.nvim",
    url = "https://github.com/blackCauldron7/surround.nvim"
  },
  ["tabout.nvim"] = {
    config = { "\27LJ\2\n•\2\0\0\5\0\f\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0024\3\a\0005\4\5\0>\4\1\0035\4\6\0>\4\2\0035\4\a\0>\4\3\0035\4\b\0>\4\4\0035\4\t\0>\4\5\0035\4\n\0>\4\6\3=\3\v\2B\0\2\1K\0\1\0\ftabouts\1\0\2\topen\6{\nclose\6}\1\0\2\topen\6[\nclose\6]\1\0\2\topen\6(\nclose\6)\1\0\2\topen\6`\nclose\6`\1\0\2\topen\6\"\nclose\6\"\1\0\2\topen\6'\nclose\6'\fexclude\1\0\2\15completion\1\21ignore_beginning\1\nsetup\vtabout\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/tabout.nvim",
    url = "https://github.com/abecodes/tabout.nvim",
    wants = { "nvim-treesitter" }
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-live-grep-raw.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-live-grep-raw.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-raw.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope-tmux.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ttmux\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-tmux.nvim",
    url = "https://github.com/camgraff/telescope-tmux.nvim"
  },
  ["telescope-zip.nvim"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/telescope-zip.nvim",
    url = "/Users/pwntester/dev/personal/telescope-zip.nvim"
  },
  ["telescope.nvim"] = {
    commands = { "Telescope" },
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.telescope\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-lua/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-easy-align"] = {
    keys = { { "", "<Plug>(EasyAlign)" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-http"] = {
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-http",
    url = "https://github.com/nicwest/vim-http"
  },
  ["vim-http-client"] = {
    config = { "\27LJ\2\n™\2\0\0\3\0\t\0\0216\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Bautocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>\bcmd#http_client_preserve_responses$http_client_focus_output_window\15javascript\24http_client_json_ft\28http_client_bind_hotkey\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-http-client",
    url = "https://github.com/aquach/vim-http-client"
  },
  ["vim-illuminate"] = {
    config = { "\27LJ\2\n‘\1\0\0\6\0\b\0\0146\0\0\0009\0\1\0006\1\0\0009\1\3\0016\3\0\0009\3\4\0039\3\5\0036\5\1\0009\5\6\5B\3\2\0025\4\a\0B\1\3\2=\1\2\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend\27Illuminate_ftblacklist\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-illuminate",
    url = "https://github.com/RRethy/vim-illuminate"
  },
  ["vim-wordmotion"] = {
    config = { "\27LJ\2\n5\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\6_\22wordmotion_prefix\6g\bvim\0" },
    loaded = true,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/start/vim-wordmotion",
    url = "https://github.com/chaoren/vim-wordmotion"
  },
  ["windline.nvim"] = {
    after = { "nvim-tree.lua" },
    loaded = true,
    only_config = true
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^nvim%-web%-devicons"] = "nvim-web-devicons",
  ["telescope.*"] = "telescope.nvim"
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

-- Config for: TrueZen.nvim
time([[Config for TrueZen.nvim]], true)
try_loadstring("\27LJ\2\nç\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\17integrations\1\0\0\1\0\f\16vim_signify\1\vfeline\1\14lightline\1\flualine\1\17express_line\1\rgitsigns\2\18vim_powerline\1\16vim_airline\1\rtwilight\1\14limelight\1\20nvim_bufferline\2\18vim_gitgutter\1\nsetup\rtrue-zen\frequire\0", "config", "TrueZen.nvim")
time([[Config for TrueZen.nvim]], false)
-- Config for: surround.nvim
time([[Config for surround.nvim]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19mappings_style\rsandwich\nsetup\rsurround\frequire\0", "config", "surround.nvim")
time([[Config for surround.nvim]], false)
-- Config for: clipboard-image.nvim
time([[Config for clipboard-image.nvim]], true)
try_loadstring("\27LJ\2\n¦\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmarkdown\1\0\0\1\0\3\naffix\f![](%s)\16img_dir_txt\26resources/attachments\fimg_dir\26resources/attachments\nsetup\20clipboard-image\frequire\0", "config", "clipboard-image.nvim")
time([[Config for clipboard-image.nvim]], false)
-- Config for: nvim-hlslens
time([[Config for nvim-hlslens]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\17nearest_only\2\14calm_down\2\nsetup\fhlslens\frequire\0", "config", "nvim-hlslens")
time([[Config for nvim-hlslens]], false)
-- Config for: close-buffers.nvim
time([[Config for close-buffers.nvim]], true)
try_loadstring("\27LJ\2\n±\1\0\1\v\0\b\0\0236\1\0\0'\3\1\0B\1\2\0029\1\2\1)\3\1\0B\1\2\0016\1\3\0009\1\4\0019\1\5\1B\1\1\0026\2\6\0\18\4\0\0B\2\2\4X\5\6€6\a\3\0009\a\4\a9\a\a\a\18\t\6\0\18\n\1\0B\a\3\1E\5\3\3R\5øK\0\1\0\21nvim_win_set_buf\vipairs\25nvim_get_current_buf\bapi\bvim\ncycle\15bufferline\frequire›\1\1\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0025\3\5\0=\3\6\0023\3\a\0=\3\b\2B\0\2\1K\0\1\0\20next_buffer_cmd\0\27preserve_window_layout\1\2\0\0\tthis\20filetype_ignore\1\0\0\nsetup\18close_buffers\frequire\0", "config", "close-buffers.nvim")
time([[Config for close-buffers.nvim]], false)
-- Config for: nvim-jdtls
time([[Config for nvim-jdtls]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14setup_jdt\18pwntester.lsp\frequire\0", "config", "nvim-jdtls")
time([[Config for nvim-jdtls]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18pwntester.lsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: octo.nvim
time([[Config for octo.nvim]], true)
try_loadstring("\27LJ\2\nT\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\30reaction_viewer_hint_icon\5\nsetup\tocto\frequire\0", "config", "octo.nvim")
time([[Config for octo.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nÒ\1\0\0\4\0\a\0\0146\0\0\0006\1\2\0'\3\1\0B\1\2\2=\1\1\0006\0\2\0'\2\1\0B\0\2\0029\0\3\0005\2\4\0005\3\5\0=\3\6\2B\0\2\1K\0\1\0\nicons\1\0\5\nTRACE\bâœŽ\nERROR\bï—\tWARN\bïª\tINFO\bïš\nDEBUG\bï†ˆ\1\0\3\ftimeout\3ˆ'\vstages\22fade_in_slide_out\22background_colour\f#ffcc66\nsetup\frequire\vnotify\bvim\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: nautilus.nvim
time([[Config for nautilus.nvim]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tmode\tgrey\nsetup\rnautilus\frequire\0", "config", "nautilus.nvim")
time([[Config for nautilus.nvim]], false)
-- Config for: telescope-tmux.nvim
time([[Config for telescope-tmux.nvim]], true)
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\ttmux\19load_extension\14telescope\frequire\0", "config", "telescope-tmux.nvim")
time([[Config for telescope-tmux.nvim]], false)
-- Config for: codeql.nvim
time([[Config for codeql.nvim]], true)
try_loadstring("\27LJ\2\nð\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\4\0\0(/Users/pwntester/codeql-home/codeql+/Users/pwntester/codeql-home/codeql-go-/Users/pwntester/codeql-home/codeql-ruby\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0", "config", "codeql.nvim")
time([[Config for codeql.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nÅ\1\0\0\6\0\n\0\0186\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0006\1\0\0009\1\5\0016\3\0\0009\3\6\0039\3\a\0036\5\1\0009\5\b\5B\3\2\0025\4\t\0B\1\3\2=\1\4\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend&indent_blankline_filetype_exclude\aÂ¦\26indent_blankline_char\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21plugins.nvim-cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: windline.nvim
time([[Config for windline.nvim]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21plugins.windline\frequire\0", "config", "windline.nvim")
time([[Config for windline.nvim]], false)
-- Config for: goto-preview
time([[Config for goto-preview]], true)
try_loadstring("\27LJ\2\nk\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\nwidth\3x\21default_mappings\1\ndebug\1\vheight\3\15\nsetup\17goto-preview\frequire\0", "config", "goto-preview")
time([[Config for goto-preview]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n©\1\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\rmappings\vstatus\1\0\0\1\0\1\6>\vToggle\17integrations\1\0\1 disable_commit_confirmation\2\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: vim-illuminate
time([[Config for vim-illuminate]], true)
try_loadstring("\27LJ\2\n‘\1\0\0\6\0\b\0\0146\0\0\0009\0\1\0006\1\0\0009\1\3\0016\3\0\0009\3\4\0039\3\5\0036\5\1\0009\5\6\5B\3\2\0025\4\a\0B\1\3\2=\1\2\0K\0\1\0\1\2\0\0\rmarkdown\20special_buffers\rdeepcopy\afn\16list_extend\27Illuminate_ftblacklist\6g\bvim\0", "config", "vim-illuminate")
time([[Config for vim-illuminate]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\n¢\2\0\0\6\0\17\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0024\3\0\0=\3\v\0026\3\f\0009\3\r\0039\3\14\3'\5\15\0B\3\2\2=\3\16\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\2\0\0\t.git\22detection_methods\1\0\2\16manual_mode\1\17silent_chdir\2\1\3\0\0\blsp\fpattern\nsetup\17project_nvim\rprojects\19load_extension\14telescope\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: telescope-frecency.nvim
time([[Config for telescope-frecency.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")
time([[Config for telescope-frecency.nvim]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: vim-wordmotion
time([[Config for vim-wordmotion]], true)
try_loadstring("\27LJ\2\n5\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\6_\22wordmotion_prefix\6g\bvim\0", "config", "vim-wordmotion")
time([[Config for vim-wordmotion]], false)
-- Config for: gitlinker.nvim
time([[Config for gitlinker.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14gitlinker\frequire\0", "config", "gitlinker.nvim")
time([[Config for gitlinker.nvim]], false)
-- Config for: telescope-fzf-native.nvim
time([[Config for telescope-fzf-native.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")
time([[Config for telescope-fzf-native.nvim]], false)
-- Config for: vim-http-client
time([[Config for vim-http-client]], true)
try_loadstring("\27LJ\2\n™\2\0\0\3\0\t\0\0216\0\0\0009\0\1\0+\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0Bautocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>\bcmd#http_client_preserve_responses$http_client_focus_output_window\15javascript\24http_client_json_ft\28http_client_bind_hotkey\6g\bvim\0", "config", "vim-http-client")
time([[Config for vim-http-client]], false)
-- Config for: renamer.nvim
time([[Config for renamer.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\frenamer\frequire\0", "config", "renamer.nvim")
time([[Config for renamer.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\1\0\4\0\b6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\2€+\0\1\0L\0\2\0K\0\1\0\rmarkdown\aft\abo\bvim”\3\1\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\0025\3\18\0=\3\19\0023\3\20\0=\3\21\2B\0\2\1K\0\1\0\14on_attach\0\16watch_index\1\0\1\rinterval\3è\a\fkeymaps\1\0\2\fnoremap\2\vbuffer\2\nsigns\1\0\1\18sign_priority\3\6\17changedelete\1\0\2\ttext\6~\ahl\19GitSignsChange\14topdelete\1\0\2\ttext\bâ€¾\ahl\19GitSignsDelete\vdelete\1\0\2\ttext\6_\ahl\19GitSignsDelete\vchange\1\0\2\ttext\6~\ahl\19GitSignsChange\badd\1\0\0\1\0\2\ttext\6+\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: copilot.vim
time([[Config for copilot.vim]], true)
try_loadstring("\27LJ\2\né\1\0\0\2\0\b\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0K\0\1\0\1\0\b\ago\2\15typescript\2\blua\2\15javascript\2\thtml\2\aql\2\vpython\2\6*\1\22copilot_filetypes\19<Plug>(Tabout)\25copilot_tab_fallback\26copilot_assume_mapped\23copilot_no_tab_map\6g\bvim\0", "config", "copilot.vim")
time([[Config for copilot.vim]], false)
-- Config for: nvim-bufferline.lua
time([[Config for nvim-bufferline.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0056\0\0\0'\2\1\0B\0\2\2B\0\1\1K\0\1\0\28plugins.nvim-bufferline\frequire\0", "config", "nvim-bufferline.lua")
time([[Config for nvim-bufferline.lua]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-autopairs ]]

-- Config for: nvim-autopairs
try_loadstring("\27LJ\2\nÛ\2\0\0\n\0\17\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\6\0005\6\5\0=\6\a\5B\3\2\0019\3\b\0\18\5\2\0'\a\t\0'\b\n\0'\t\v\0B\5\4\0A\3\0\0016\3\0\0'\5\f\0B\3\2\0029\4\r\3\18\6\4\0009\4\14\4'\a\15\0009\b\16\1B\b\1\0A\4\2\1K\0\1\0\20on_confirm_done\17confirm_done\aon\nevent\bcmp\aql\5\6|\radd_rule\21disable_filetype\1\0\1\22ignored_next_char\17[%w%.%(%{%[]\1\3\0\0\20TelescopePrompt\tocto\nsetup\24nvim-autopairs.rule\"nvim-autopairs.completion.cmp\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")

vim.cmd [[ packadd LuaSnip ]]

-- Config for: LuaSnip
try_loadstring("\27LJ\2\nµ\1\0\0\4\0\a\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0015\3\4\0B\1\2\0016\1\0\0'\3\5\0B\1\2\0029\1\6\1B\1\1\1K\0\1\0\14lazy_load luasnip/loaders/from_vscode\1\0\2\17updateevents\29TextChanged,TextChangedI\fhistory\2\15set_config\vconfig\fluasnip\frequire\0", "config", "LuaSnip")

vim.cmd [[ packadd tabout.nvim ]]

-- Config for: tabout.nvim
try_loadstring("\27LJ\2\n•\2\0\0\5\0\f\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0024\3\a\0005\4\5\0>\4\1\0035\4\6\0>\4\2\0035\4\a\0>\4\3\0035\4\b\0>\4\4\0035\4\t\0>\4\5\0035\4\n\0>\4\6\3=\3\v\2B\0\2\1K\0\1\0\ftabouts\1\0\2\topen\6{\nclose\6}\1\0\2\topen\6[\nclose\6]\1\0\2\topen\6(\nclose\6)\1\0\2\topen\6`\nclose\6`\1\0\2\topen\6\"\nclose\6\"\1\0\2\topen\6'\nclose\6'\fexclude\1\0\2\15completion\1\21ignore_beginning\1\nsetup\vtabout\frequire\0", "config", "tabout.nvim")

vim.cmd [[ packadd nvim-tree.lua ]]

-- Config for: nvim-tree.lua
try_loadstring("\27LJ\2\nå\2\0\0\3\0\15\0\0276\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0=\1\3\0006\0\0\0009\0\1\0005\1\a\0006\2\1\0009\2\6\2=\2\b\0015\2\t\0=\2\n\1=\1\5\0006\0\0\0009\0\1\0)\1\3\0=\1\v\0006\0\f\0'\2\r\0B\0\2\0029\0\14\0B\0\1\1K\0\1\0\nsetup\22plugins.nvim-tree\frequire%nvim_tree_highlight_opened_files\fbuftype\1\2\0\0\rterminal\rfiletype\1\0\0\20special_buffers$nvim_tree_window_picker_exclude\1\0\4\18folder_arrows\3\1\nfiles\3\1\ffolders\3\1\bgit\3\0\25nvim_tree_show_icons\30nvim_tree_respect_buf_cwd\6g\bvim\0", "config", "nvim-tree.lua")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
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
