local function setup()

  vim.g.loaded_netrwPlugin = 1
  vim.g.polyglot_disabled = {'jsx', 'hive', 'markdown'}

  vim.cmd [[packadd! packer.nvim]]

  local packer = require'packer'
  packer.reset()

  local spec = function(use)

    use {'wbthomason/packer.nvim', opt = true}

    -- SYNTAX
    use {'sheerun/vim-polyglot', config = function()
      vim.g.no_csv_maps = 1
    end}
    use {'SidOfc/mkdx', config = function()
      vim.g['mkdx#settings'] = {
        highlight = {
          enable = 1;
          frontmatter = {
            yaml = 0;
            toml = 0;
            json = 0;
          };
        };
        gf_on_steroids = 1;
        enter = {
          enable = 1;
          shift = 1;
        };
      }
    end}

    -- TREESITTER
    use {'nvim-treesitter/nvim-treesitter', config = function()
      require'plugins.treesitter'.setup()
    end}
    use {'nvim-treesitter/completion-treesitter'}

    -- COMPLETION
    use {'nvim-lua/completion-nvim'}

    -- FZF
    use {'junegunn/fzf.vim'}
    use {'/usr/local/opt/fzf', config = function()
      vim.g.fzf_layout = { window = 'lua require("window").floating_window({border=true;width_per=0.8;height_per=0.7;})' }
    end}

    -- TEXT OBJECTS
    use {'machakann/vim-sandwich'}
    use {'chaoren/vim-wordmotion', config = function()
      -- vim.g.wordmotion_prefix = '<Leader>'
    end}

    -- SEARCH
    use {'romainl/vim-cool'}

    -- GIT
    use {'tpope/vim-fugitive'}

    -- UI
    use {'Yggdroot/indentLine', config = function()
      vim.g.indentLine_color_gui = '#11305f'
      vim.g.indentLine_fileTypeExclude = vim.list_extend(vim.g.special_buffers, {'markdown','octo_issue'})
      vim.g.indentLine_faster = 1
      vim.g.indentLine_conceallevel = 2
    end}
    use {'psliwka/vim-smoothie', config = function()
      vim.g.smoothie_no_default_mappings = true
    end}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'junegunn/rainbow_parentheses.vim', config = function()
      vim.cmd [[autocmd WinEnter,BufEnter * nested lua util.enableRainbowParentheses()]]
      vim.cmd [[autocmd WinEnter,BufEnter {} nested lua util.enableRainbowParentheses()]]
    end}
    use {'junegunn/goyo.vim', config = function()
      vim.cmd [[autocmd User GoyoEnter nested lua util.goyoEnter()]]
    end}

    -- PAIRING
    use {'andymass/vim-matchup', config = function()
      vim.g.matchup_matchparen_status_offscreen = 0
      vim.g.matchup_matchparen_nomode = [[ivV\<c-v>]]
      vim.g.matchup_matchparen_deferred = 1
    end}
    use {'tmsvg/pear-tree', config = function()
      vim.g.pear_tree_repeatable_expand = 0
      vim.g.pear_tree_smart_backspace = 1
      vim.g.pear_tree_smart_closers = 1
      vim.g.pear_tree_smart_openers = 1
      vim.g.pear_tree_ft_disabled = {'fuzzy_menu', 'TelescopePrompt'}
    end}
    use {'alvan/vim-closetag', config = function()
      vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsp'
      vim.g.closetag_filetypes = 'html,xhtml,phtml,fortifyrulepack,xml,jsp'
      vim.g.closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsp,*.html'
      vim.g.closetag_xhtml_filetypes = 'xhtml,jsx,fortifyrulepack'
    end}

    -- FILE EXPLORER
    use {'justinmk/vim-dirvish', config = function()
      require'plugins.dirvish'.setup()
    end}

    -- LSP
    use {'neovim/nvim-lspconfig', config = function()
      require("lsp_config").setup()
    end}
    use {'liuchengxu/vista.vim', config = function()
      vim.g.vista_default_executive = 'nvim_lsp'
      vim.g.vista_sidebar_position = 'vertical topleft 15'
      vim.g.vista_fzf_preview = {'right:50%'}
      vim.g.vista_keep_fzf_colors = 1
    end}

    -- THEMES & COLORS
    use {'norcalli/nvim-base16.lua'}
    use {'norcalli/nvim-colorizer.lua', branch = 'color-editor'}

    -- COMMENTS
    use {'tomtom/tcomment_vim'}

    -- BUFFER LINE
    use {'pacha/vem-tabline', config = function()
      vim.g.vem_tabline_show = 2
    end}

    -- DIFFING
    use {'AndrewRadev/linediff.vim'}

    -- SNIPPETS
    use {'norcalli/snippets.nvim', config = function()
      require'plugins.snippets'.setup()
    end}

    -- ROOTER
    use {'airblade/vim-rooter', config = function()
      vim.g.rooter_cd_cmd = 'lcd'
      vim.g.rooter_patterns = {'.git/'}
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_change_directory_for_non_project_files = 'current'
    end}

    -- ALIGNING
    use {'tommcdo/vim-lion'}

    -- TERMINAL
    use {'voldikss/vim-floaterm'}

    -- STATIC ANALYSIS
    use {'~/Dev/codeql.nvim', config = function()
      vim.g.codeql_max_ram = 32000
      vim.g.codeql_search_path = '/Users/pwntester/codeql-home/codeql-repo'
    end}
    use {'~/Dev/fortify.nvim', config = function()
      --require'plugins.fortify'.setup()
    end}

    -- GITHUB
    use {'~/Dev/octo.nvim', config = function()
      vim.cmd [[ augroup octo ]]
      vim.cmd [[ autocmd! ]]
      vim.cmd [[ autocmd FileType octo_issue lua statusline.active() ]]
      vim.cmd [[ autocmd FileType octo_issue nested setlocal conceallevel=2 ]]
      vim.cmd [[ autocmd FileType octo_issue nested setlocal concealcursor=c ]]
      vim.cmd [[ augroup END ]]
    end}
  end

  local config = {
    display = {
      open_fn = function()
        local winnr, bufnr = require("window").floating_window({border=true;width_per=0.8;height_per=0.8})
        return bufnr, winnr
      end
    }
  }

  packer.startup {spec, config = config}

  vim.cmd [[packloadall!]]

  -- FZF
  -- vim.cmd [[
  -- inoremap <expr> <c-x><c-f> fzf#vim#complete(fzf#wrap({'source': 'find '.getcwd().' -type f -name "*.md" -not -path "*/\.*"\; \| xargs realpath', 'reducer': function('<sid>make_relative') }))
  -- ]]

end

return {
  setup = setup;
}

