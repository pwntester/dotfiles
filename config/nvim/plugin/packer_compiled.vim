" Automatically generated packer.nvim plugin loader code

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
      vim._update_package_paths()
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
-- Config for: nvim-lspconfig
loadstring("\27LJ\1\0028\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\15lsp_config\frequire\0")()
-- Config for: pear-tree
loadstring("\27LJ\1\2ü\1\0\0\2\0\b\0\0214\0\0\0007\0\1\0'\1\0\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\1\0'\1\1\0:\1\5\0004\0\0\0007\0\1\0003\1\a\0:\1\6\0G\0\1\0\1\3\0\0\20TelescopePrompt\15fuzzy_menu\26pear_tree_ft_disabled\28pear_tree_smart_openers\28pear_tree_smart_closers\30pear_tree_smart_backspace pear_tree_repeatable_expand\6g\bvim\0")()
-- Config for: vim-rooter
loadstring("\27LJ\1\2Ç\1\0\0\2\0\t\0\0174\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0003\1\5\0:\1\4\0004\0\0\0007\0\1\0'\1\1\0:\1\6\0004\0\0\0007\0\1\0%\1\b\0:\1\a\0G\0\1\0\fcurrent2rooter_change_directory_for_non_project_files\24rooter_silent_chdir\1\2\0\0\n.git/\20rooter_patterns\blcd\18rooter_cd_cmd\6g\bvim\0")()
-- Config for: snippets.nvim
loadstring("\27LJ\1\2>\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\21plugins.snippets\frequire\0")()
-- Config for: vim-matchup
loadstring("\27LJ\1\2¥\1\0\0\2\0\6\0\r4\0\0\0007\0\1\0'\1\0\0:\1\2\0004\0\0\0007\0\1\0%\1\4\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\5\0G\0\1\0 matchup_matchparen_deferred\14ivV\\<c-v>\30matchup_matchparen_nomode(matchup_matchparen_status_offscreen\6g\bvim\0")()
-- Config for: octo.nvim
loadstring("\27LJ\1\2¬\3\0\0\2\0\t\0\0294\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\0\0007\0\1\0%\1\3\0>\0\2\0014\0\0\0007\0\1\0%\1\4\0>\0\2\0014\0\0\0007\0\1\0%\1\5\0>\0\2\0014\0\0\0007\0\1\0%\1\6\0>\0\2\0014\0\0\0007\0\1\0%\1\a\0>\0\2\0014\0\0\0007\0\1\0%\1\b\0>\0\2\1G\0\1\0T command! -nargs=1 ListIssues :lua require'plugins.telescope'.issues(<f-args>) \18 augroup END B autocmd FileType octo_issue nested setlocal concealcursor=c A autocmd FileType octo_issue nested setlocal conceallevel=2 : autocmd FileType octo_issue lua statusline.active() \15 autocmd! \19 augroup octo \bcmd\bvim\0")()
-- Config for: telescope.nvim
loadstring("\27LJ\1\2?\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\22plugins.telescope\frequire\0")()
-- Config for: completion-nvim
loadstring("\27LJ\1\2@\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\23plugins.completion\frequire\0")()
-- Config for: vim-wordmotion
loadstring("\27LJ\1\2<\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\r<Leader>\22wordmotion_prefix\6g\bvim\0")()
-- Config for: goyo.vim
loadstring("\27LJ\1\2V\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0007autocmd User GoyoEnter nested lua util.goyoEnter()\bcmd\bvim\0")()
-- Config for: mkdx
loadstring("\27LJ\1\2¯\1\0\0\4\0\n\0\v4\0\0\0007\0\1\0003\1\6\0003\2\3\0003\3\4\0:\3\5\2:\2\a\0013\2\b\0:\2\t\1:\1\2\0G\0\1\0\nenter\1\0\2\nshift\3\1\venable\3\1\14highlight\1\0\1\19gf_on_steroids\3\1\16frontmatter\1\0\3\tjson\3\0\tyaml\3\0\ttoml\3\0\1\0\1\venable\3\1\18mkdx#settings\6g\bvim\0")()
-- Config for: nvim-treesitter
loadstring("\27LJ\1\2@\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\23plugins.treesitter\frequire\0")()
-- Config for: nvim-base16.lua
loadstring("\27LJ\1\0023\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\ntheme\frequire\0")()
-- Config for: codeql.nvim
loadstring("\27LJ\1\2ž\1\0\0\2\0\6\0\r4\0\0\0007\0\1\0'\1\0}:\1\2\0004\0\0\0007\0\1\0%\1\4\0:\1\3\0004\0\0\0007\0\1\0'\1\1\0:\1\5\0G\0\1\0\22codeql_fmt_onsave-/Users/pwntester/codeql-home/codeql-repo\23codeql_search_path\19codeql_max_ram\6g\bvim\0")()
-- Config for: vim-smoothie
loadstring("\27LJ\1\2>\0\0\2\0\3\0\0054\0\0\0007\0\1\0)\1\2\0:\1\2\0G\0\1\0!smoothie_no_default_mappings\6g\bvim\0")()
-- Config for: indentLine
loadstring("\27LJ\1\2ÿ\1\0\0\4\0\n\0\0234\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0004\1\0\0007\1\5\0014\2\0\0007\2\1\0027\2\6\0023\3\a\0>\1\3\2:\1\4\0004\0\0\0007\0\1\0'\1\1\0:\1\b\0004\0\0\0007\0\1\0'\1\2\0:\1\t\0G\0\1\0\28indentLine_conceallevel\22indentLine_faster\1\3\0\0\rmarkdown\15octo_issue\20special_buffers\16list_extend\31indentLine_fileTypeExclude\f#11305f\25indentLine_color_gui\6g\bvim\0")()
-- Config for: nvim-web-devicons
loadstring("\27LJ\1\2?\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\22nvim-web-devicons\frequire\0")()
-- Conditional loads
-- Load plugins in order defined by `after`
vim._update_package_paths()
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
