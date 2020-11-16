" Automatically generated packer.nvim plugin loader code

if !has('nvim')
  finish
endif

lua << END
local plugins = {
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/pwntester/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Post-load configuration
-- Config for: fortify.nvim
loadstring("\27LJ\2\2=\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20plugins.fortify\frequire\0")()
-- Config for: goyo.vim
loadstring("\27LJ\2\2V\0\0\2\0\3\0\0056\0\0\0009\0\1\0'\1\2\0B\0\2\1K\0\1\0007autocmd User GoyoEnter nested lua util.goyoEnter()\bcmd\bvim\0")()
-- Config for: nautilus
loadstring("\27LJ\2\2:\0\0\2\0\3\0\0056\0\0\0009\0\1\0'\1\2\0B\0\2\1K\0\1\0\27 colorscheme nautilus \bcmd\bvim\0")()
-- Config for: vem-tabline
loadstring("\27LJ\2\0022\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\2\0=\1\2\0K\0\1\0\21vem_tabline_show\6g\bvim\0")()
-- Config for: git-messenger.vim
loadstring("\27LJ\2\2C\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0&git_messenger_no_default_mappings\6g\bvim\0")()
-- Config for: vim-matchup
loadstring("\27LJ\2\2¥\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0K\0\1\0 matchup_matchparen_deferred\14ivV\\<c-v>\30matchup_matchparen_nomode(matchup_matchparen_status_offscreen\6g\bvim\0")()
-- Config for: octo.nvim
loadstring("\27LJ\2\2†\2\0\0\2\0\a\0\0216\0\0\0009\0\1\0'\1\2\0B\0\2\0016\0\0\0009\0\1\0'\1\3\0B\0\2\0016\0\0\0009\0\1\0'\1\4\0B\0\2\0016\0\0\0009\0\1\0'\1\5\0B\0\2\0016\0\0\0009\0\1\0'\1\6\0B\0\2\1K\0\1\0\18 augroup END B autocmd FileType octo_issue nested setlocal concealcursor=c A autocmd FileType octo_issue nested setlocal conceallevel=2 \15 autocmd! \19 augroup octo \bcmd\bvim\0")()
-- Config for: telescope.nvim
loadstring("\27LJ\2\2?\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22plugins.telescope\frequire\0")()
-- Config for: completion-nvim
loadstring("\27LJ\2\2@\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.completion\frequire\0")()
-- Config for: nvim-web-devicons
loadstring("\27LJ\2\2?\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0")()
-- Config for: express_line.nvim
loadstring("\27LJ\2\0023\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\24plugins.expressline\frequire\0")()
-- Config for: vim-wordmotion
loadstring("\27LJ\2\2<\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\r<Leader>\22wordmotion_prefix\6g\bvim\0")()
-- Config for: vim-signify
loadstring("\27LJ\2\0027\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\6~\24signify_sign_change\6g\bvim\0")()
-- Config for: vim-startify
loadstring("\27LJ\2\2Å\5\0\0\4\0\t\0\0186\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0005\0\5\0006\1\0\0009\1\1\0016\2\0\0009\2\a\0029\2\b\2\18\3\0\0B\2\2\2=\2\6\1K\0\1\0\17startify#pad\afn\27startify_custom_header\1\b\0\0G ____  __    __  ____   ______    ___  _____ ______    ___  ____  G|    \\|  |__|  ||    \\ |      |  /  _]/ ___/|      |  /  _]|    \\ G|  o  )  |  |  ||  _  ||      | /  [_(   \\_ |      | /  [_ |  D  )G|   _/|  |  |  ||  |  ||_|  |_||    _]\\__  ||_|  |_||    _]|    / G|  |  |  `  '  ||  |  |  |  |  |   [_ /  \\ |  |  |  |   [_ |    \\ G|  |   \\      / |  |  |  |  |  |     |\\    |  |  |  |     ||  .  \\G|__|    \\_/\\_/  |__|__|  |__|  |_____| \\___|  |__|  |_____||__|\\_|\29startify_update_oldfiles\1\4\0\0\r~/.zshrc\28~/.config/nvim/init.vim#~/.config/nvim/lua/plugins.lua\23startify_bookmarks\6g\bvim\0")()
-- Config for: indentLine
loadstring("\27LJ\2\2Á\2\0\0\5\0\14\0\0306\0\0\0'\1\1\0B\0\2\0029\0\2\0006\1\3\0009\1\4\0019\2\6\0\18\3\2\0009\2\a\2B\2\2\2=\2\5\0016\1\3\0009\1\4\0016\2\3\0009\2\t\0026\3\3\0009\3\4\0039\3\n\0035\4\v\0B\2\3\2=\2\b\0016\1\3\0009\1\4\1)\2\1\0=\2\f\0016\1\3\0009\1\4\1)\2\2\0=\2\r\1K\0\1\0\28indentLine_conceallevel\22indentLine_faster\1\3\0\0\rmarkdown\15octo_issue\20special_buffers\16list_extend\31indentLine_fileTypeExclude\vto_rgb\vbase01\25indentLine_color_gui\6g\bvim\vcolors\21colorbuddy.color\frequire\0")()
-- Config for: vim-smoothie
loadstring("\27LJ\2\2>\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0!smoothie_no_default_mappings\6g\bvim\0")()
-- Config for: nvim-lspconfig
loadstring("\27LJ\2\0028\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lsp_config\frequire\0")()
-- Config for: nvim-base16.lua
loadstring("\27LJ\2\2\v\0\0\1\0\0\0\1K\0\1\0\0")()
-- Config for: codeql.nvim
loadstring("\27LJ\2\2ý\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1\0}=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\4\0\0-/Users/pwntester/codeql-home/codeql-repo0/Users/pwntester/codeql-home/codeql-go-repo0/Users/pwntester/codeql-home/pwntester-repo\23codeql_search_path\19codeql_max_ram\25codeql_group_by_sink\6g\bvim\0")()
-- Config for: vim-rooter
loadstring("\27LJ\2\2Ç\1\0\0\2\0\t\0\0176\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0K\0\1\0\fcurrent2rooter_change_directory_for_non_project_files\24rooter_silent_chdir\1\2\0\0\n.git/\20rooter_patterns\blcd\18rooter_cd_cmd\6g\bvim\0")()
-- Config for: snippets.nvim
loadstring("\27LJ\2\2>\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21plugins.snippets\frequire\0")()
-- Config for: nvim-treesitter
loadstring("\27LJ\2\2@\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23plugins.treesitter\frequire\0")()
-- Conditional loads
-- Load plugins in order defined by `after`
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
augroup END
