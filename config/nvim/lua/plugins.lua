vim.g.loaded_netrwPlugin = 1

vim.cmd [[packadd! packer.nvim]]

local packer = require'packer'

local spec = function(use)

  use {'wbthomason/packer.nvim', opt = true}

  -- SYNTAX
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

  use {'kyazdani42/nvim-web-devicons', config = function()
    require'nvim-web-devicons'.setup()
  end}

  -- TELESCOPE.NVIM
  use {'nvim-lua/popup.nvim'}
  use {'nvim-lua/plenary.nvim'}
  --use {'nvim-lua/telescope.nvim', config = function()
  use {'/Users/pwntester/Dev/telescope.nvim', config = function()
    require'plugins.telescope'.setup()
  end}

  -- COMPLETION
  use {'nvim-lua/completion-nvim', config = function()
    require'plugins.completion'.setup()
  end}
  use {'steelsojka/completion-buffers'}

  -- TREESITTER
  use {'nvim-treesitter/nvim-treesitter', config = function()
    require'plugins.treesitter'.setup()
  end}
  use {'nvim-treesitter/playground'}
  use {'nvim-treesitter/completion-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-refactor'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}

  -- TMUX
  use {'christoomey/vim-tmux-navigator'}

  -- TEXT OBJECTS/MOTIONS/OPERATORS
  use {'machakann/vim-sandwich'}
    -- add: sa{motion/textobject}{delimiter}
    -- delete: sd{delimiter}
    -- replace: sr{old}{new}
  use {'michaeljsmith/vim-indent-object'}
    -- ii: inner Indentation level (no line above).
    -- iI: inner Indentation level (no lines above/below).
    -- ai: an Indentation level and line above.
    -- aI: an Indentation level and lines above/below.
  use {'tommcdo/vim-lion'}
    -- gl{motion/textobject}{aligning char}: spaces to the left
    -- gL{motion/textobject}{aligning char}: spaces to the right
  use {'chaoren/vim-wordmotion', config = function()
    vim.g.wordmotion_prefix = '<Leader>'
  end}

  -- GIT
  use {'tpope/vim-fugitive'}
  use {'jaxbot/github-issues.vim'}
  use {'rhysd/committia.vim'}
  use {'rhysd/git-messenger.vim', config = function()
    vim.g.git_messenger_no_default_mappings = true
  end}
  use {'~/Dev/octo.nvim', config = function()
    vim.cmd [[ augroup octo ]]
    vim.cmd [[ autocmd! ]]
    vim.cmd [[ autocmd FileType octo_issue lua statusline.active() ]]
    vim.cmd [[ autocmd FileType octo_issue nested setlocal conceallevel=2 ]]
    vim.cmd [[ autocmd FileType octo_issue nested setlocal concealcursor=c ]]
    vim.cmd [[ augroup END ]]
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
  use {'mkitt/tabline.vim'}
  -- use {'pacha/vem-tabline', config = function()
  --   vim.g.vem_tabline_show = 2
  -- end}

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

  -- FILE EXPLORER
  use {'justinmk/vim-dirvish'}

  -- LSP
  use {'mfussenegger/nvim-jdtls'}
  use {'neovim/nvim-lspconfig', config = function()
    require("lsp_config").setup()
  end}

  -- THEMES & COLORS
  use {'norcalli/nvim-base16.lua', config = function()
    require'theme'.setup()
  end}
  use {'norcalli/nvim-colorizer.lua', branch = 'color-editor'}

  -- COMMENTS
  use {'tomtom/tcomment_vim'}

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

  -- STATIC ANALYSIS
  use {'~/Dev/codeql.nvim', config = function()
    vim.g.codeql_max_ram = 32000
    vim.g.codeql_search_path = '/Users/pwntester/codeql-home/codeql-repo'
    vim.g.codeql_fmt_onsave = 1
  end}
  -- use {'~/Dev/fortify.nvim', config = function()
  --   require'plugins.fortify'.setup()
  -- end}

  use {'tpope/vim-scriptease'}
    -- :Messages: view messages in quickfix list
    -- :Verbose: view verbose output in preview window.
    -- :Time: measure how long it takes to run some stuff.
    -- zS: Debug syntax under cursor

  -- TESTING
  use {'diepm/vim-rest-console'}
  use {'mhinz/vim-sayonara'}

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
