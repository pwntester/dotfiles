vim.g.loaded_netrwPlugin = 1

vim.cmd [[packadd! packer.nvim]]

local packer = require'packer'

local spec = function(use)

  use {'wbthomason/packer.nvim', opt = true}

  -- SYNTAX
  -- use {'sheerun/vim-polyglot', config = function()
  --   vim.g.no_csv_maps = 1
  -- end}
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

  -- TELESCOPE.NVIM
  use {'kyazdani42/nvim-web-devicons', config = function()
    require'nvim-web-devicons'.setup()
  end}
  use {'nvim-lua/popup.nvim'}
  use {'/Users/pwntester/Dev/plenary.nvim'}
  use {'/Users/pwntester/Dev/telescope.nvim', config = function()
    require'plugins.telescope'.setup()
  end}

  -- COMPLETION
  use {'nvim-lua/completion-nvim', config = function()
    require'plugins.completion'.setup()
  end}
  use {'steelsojka/completion-buffers'}

  -- TREESITTER
  use {'/Users/pwntester/Dev/nvim-treesitter', config = function()
    require'plugins.treesitter'.setup()
  end}
  use {'nvim-treesitter/playground'}
  use {'nvim-treesitter/completion-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-refactor'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}

  -- TMUX
  use {'christoomey/vim-tmux-navigator'}

  -- TEXT OBJECTS
  use {'machakann/vim-sandwich'}
  use {'chaoren/vim-wordmotion', config = function()
    vim.g.wordmotion_prefix = '<Leader>'
  end}

  -- SEARCH
  use {'romainl/vim-cool'}

  -- GIT
  use {'tpope/vim-fugitive'}
  use {'jaxbot/github-issues.vim'}
  use {'~/Dev/octo.nvim', config = function()
    vim.cmd [[ augroup octo ]]
    vim.cmd [[ autocmd! ]]
    vim.cmd [[ autocmd FileType octo_issue lua statusline.active() ]]
    vim.cmd [[ autocmd FileType octo_issue nested setlocal conceallevel=2 ]]
    vim.cmd [[ autocmd FileType octo_issue nested setlocal concealcursor=c ]]
    vim.cmd [[ augroup END ]]
    vim.cmd [[ command! -nargs=1 ListIssues :lua require'plugins.telescope'.issues(<f-args>) ]]
  end}

  -- UI
  use {'Yggdroot/indentLine', config = function()
    vim.g.indentLine_color_gui = '#11305f'
    vim.g.indentLine_fileTypeExclude = vim.list_extend(vim.g.special_buffers, {'markdown','octo_issue'})
    vim.g.indentLine_faster = 1
    vim.g.indentLine_conceallevel = 2
  end}
  use {'lukas-reineke/indent-blankline.nvim'}
  use {'psliwka/vim-smoothie', config = function()
    vim.g.smoothie_no_default_mappings = true
  end}
  use {'junegunn/rainbow_parentheses.vim'}
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
    vim.g.pear_tree_ft_disabled = {'TelescopePrompt', 'fuzzy_menu'}
  end}
  -- use {'alvan/vim-closetag', config = function()
  --   vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsp'
  --   vim.g.closetag_filetypes = 'html,xhtml,phtml,fortifyrulepack,xml,jsp'
  --   vim.g.closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsp,*.html'
  --   vim.g.closetag_xhtml_filetypes = 'xhtml,jsx,fortifyrulepack'
  -- end}

  -- FILE EXPLORER
  use {'justinmk/vim-dirvish'}

  -- LSP
  use {'mfussenegger/nvim-jdtls'}
  use {'neovim/nvim-lspconfig', config = function()
    require("lsp_config").setup()
  end}
  -- use {'liuchengxu/vista.vim', config = function()
  --   vim.g.vista_default_executive = 'nvim_lsp'
  --   vim.g.vista_sidebar_position = 'vertical topleft 15'
  --   vim.g.vista_fzf_preview = {'right:50%'}
  --   vim.g.vista_keep_fzf_colors = 1
  -- end}

  -- THEMES & COLORS
  use {'norcalli/nvim-base16.lua', config = function()
    require'theme'.setup()
  end}
  use {'norcalli/nvim-colorizer.lua', branch = 'color-editor'}

  -- COMMENTS
  use {'tomtom/tcomment_vim'}

  -- BUFFER LINE
  -- use {'pacha/vem-tabline', config = function()
  --   vim.g.vem_tabline_show = 2
  -- end}

  -- DIFFING
  -- use {'AndrewRadev/linediff.vim'}

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
  -- use {'tommcdo/vim-lion'}

  -- TERMINAL
  use {'voldikss/vim-floaterm'}

  -- STATIC ANALYSIS
  use {'~/Dev/codeql.nvim', config = function()
    vim.g.codeql_max_ram = 32000
    vim.g.codeql_search_path = '/Users/pwntester/codeql-home/codeql-repo'
    vim.g.codeql_fmt_onsave = 1
  end}
  -- use {'~/Dev/fortify.nvim', config = function()
  --   require'plugins.fortify'.setup()
  -- end}

  -- :Messages <- view messages in quickfix list
  -- :Verbose  <- view verbose output in preview window.
  -- :Time     <- measure how long it takes to run some stuff.
  -- zS        <- Debug syntax under cursor
  use {'tpope/vim-scriptease'}

  use {'diepm/vim-rest-console'}
end

local config = {
  display = {
    open_fn = function()
      local bufnr, winnr = require("window").floating_window({border=true;width_per=0.8;height_per=0.8})
      vim.api.nvim_set_current_win(winnr)
      return bufnr, winnr
    end
  }
}

packer.startup {spec, config = config}
