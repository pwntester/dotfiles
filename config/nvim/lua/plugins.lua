--- from https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/init.lua#L64-L113
---local variant of packer's `use` function that specifies both a local and upstream version of a plugin
---@param spec table|string
local function use_local(spec)
  local path = ""
  if type(spec) ~= "table" then
    return g.echomsg(string.format("spec must be a table", spec[1]))
  end
  local local_spec = vim.deepcopy(spec)
  if not local_spec.local_path then
    return g.echomsg(string.format("%s has no specified local path", spec[1]))
  end

  local name = vim.split(spec[1], "/")[2]
  path = os.getenv "HOME" .. "/" .. local_spec.local_path .. "/" .. name
  if vim.fn.isdirectory(vim.fn.expand(path)) < 1 then
    -- remote spec
    require("packer").use(spec)
  else
    -- local spec
    local_spec[1] = path
    local_spec.tag = nil
    local_spec.branch = nil
    local_spec.commit = nil
    local_spec.local_path = nil
    local_spec.local_cond = nil
    local_spec.local_disable = nil
    local_spec.local_name = nil
    require("packer").use(local_spec)
  end
end

local spec = function(use)

  use {
    'wbthomason/packer.nvim',
    opt = true
  }

  -- SESSIONS
  use {
    'glepnir/dashboard-nvim',
    config = function()
      vim.g.dashboard_default_executive = 'telescope'
      vim.g.dashboard_custom_header = {
        [[███████ ██   ██  █████  ██      ██          ██     ██ ███████     ██████  ██       █████  ██    ██      █████       ██████   █████  ███    ███ ███████ ██████  ]],
        [[██      ██   ██ ██   ██ ██      ██          ██     ██ ██          ██   ██ ██      ██   ██  ██  ██      ██   ██     ██       ██   ██ ████  ████ ██           ██ ]],
        [[███████ ███████ ███████ ██      ██          ██  █  ██ █████       ██████  ██      ███████   ████       ███████     ██   ███ ███████ ██ ████ ██ █████     ▄███  ]],
        [[     ██ ██   ██ ██   ██ ██      ██          ██ ███ ██ ██          ██      ██      ██   ██    ██        ██   ██     ██    ██ ██   ██ ██  ██  ██ ██        ▀▀    ]],
        [[███████ ██   ██ ██   ██ ███████ ███████      ███ ███  ███████     ██      ███████ ██   ██    ██        ██   ██      ██████  ██   ██ ██      ██ ███████   ██    ]],
      }

      vim.g.dashboard_custom_section = {
          a = {description = {'  ToDo                '}, command = 'TODO'},
          b = {description = {'  GitHub Notifications'}, command = 'Inbox'},
          c = {description = {'  Find File           '}, command = 'Telescope find_files'},
          d = {description = {'  Recently Used Files '}, command = 'Telescope frecency'},
          e = {description = {'  Load Last Session   '}, command = 'SessionLoad'},
          f = {description = {'  CWD Grep            '}, command = 'Telescope live_grep'},
          g = {description = {'  Config              '}, command = ':e ~/.config/nvim/lua/plugins.lua'}
      }
    end
  }

  -- DEPS
  use {'tami5/sql.nvim'}
  use {'nvim-lua/popup.nvim'}
  use {'nvim-lua/plenary.nvim'}

  -- BASICS
  use {'famiu/bufdelete.nvim'}
  use {'jdhao/better-escape.vim'}
  use {'monaqa/dial.nvim'}
  use {
    't9md/vim-choosewin',
    config = function()
      vim.g.choosewin_overlay_enable = 1
    end
  }
  use {'tpope/vim-scriptease'}
    -- :Messages: view messages in quickfix list
    -- :Verbose: view verbose output in preview window.
    -- :Time: measure how long it takes to run some stuff.
    -- zS: Debug syntax under cursor
  use {'karb94/neoscroll.nvim'}

  -- TELESCOPE.NVIM
  use {
    'nvim-lua/telescope.nvim',
    config = function()
      require'plugins.telescope'.setup()
    end,
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
  }
  use {
    'nvim-telescope/telescope-project.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require'telescope'.load_extension('project')
    end
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require"telescope".load_extension("frecency")
    end
  }
  use {
    'nvim-telescope/telescope-cheat.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require'telescope'.load_extension("cheat")
    end
  }
  use {
    'nvim-telescope/telescope-symbols.nvim',
    requires = {'nvim-telescope/telescope.nvim'}
  }

  -- SEARCH
  use {
    'jremmen/vim-ripgrep',
    config = function()
      vim.g.rg_derive_root = true
      vim.g.rg_root_types = {'.git'}
    end
  }
  --- :Rg
  --- :RgRoot

  -- COMPLETION
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require"plugins.compe".setup()
    end
  }

  -- SNIPPETS
  use {'hrsh7th/vim-vsnip'}
  use {'seudev/vscode-java-snippets'}
  use {'NexSabre/vscode-python-snippets'}
  use {'github/vscode-codeql'}

  -- TREESITTER
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'plugins.treesitter'.setup()
    end
  }
  use {'nvim-treesitter/playground'}
  use {'nvim-treesitter/completion-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-refactor'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}

  -- TMUX
  use {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end
  }

  -- ALIGNING
  use {'junegunn/vim-easy-align'}
    -- MD tables: `EasyAlign*<Bar>`

  -- TEXT OBJECTS/MOTIONS/OPERATORS
  use {'machakann/vim-sandwich'}
    -- add: sa{motion/textobject}{delimiter}
    -- delete: sd{delimiter}
    -- replace: sr{old}{new}
  use {
    'chaoren/vim-wordmotion',
    config = function()
      vim.g.wordmotion_prefix = '<Leader>'
    end
  }

  -- GIT
  use {'rhysd/committia.vim'}
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '+'},
          change       = {hl = 'GitSignsChange', text = '~'},
          delete       = {hl = 'GitSignsDelete', text = '_'},
          topdelete    = {hl = 'GitSignsDelete', text = '‾'},
          changedelete = {hl = 'GitSignsChange', text = '~'},
        },
        keymaps = {
          noremap = true,
          buffer = true,
          ['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
          ['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        },
        watch_index = {
          interval = 1000
        },
        sign_priority = 6,
        status_formatter = nil,
      }
    end
  }
  use {
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require"gitlinker".setup()
    end
  }
  --- <leader>gy
  use_local {
    'pwntester/octo.nvim',
    config = function()
      require"octo".setup({
        reaction_viewer_hint_icon = "";
      })
    end,
    local_path = "dev",
    requires = {'nvim-telescope/telescope.nvim'},
  }
  use_local {
    'pwntester/octo-notifications.nvim',
    requires = 'pwntester/octo.nvim',
    local_path = "dev",
  }
  use {"sindrets/diffview.nvim"}
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('neogit').setup {
        integrations = {
          diffview = true
        },
        disable_commit_confirmation = true,
        mappings = {
          status = {
            [">"] = "Toggle",
          }
        }
      }
    end
  }
  --- <tab>: Toggle diff
  --- s: tage (also supports staging selection/hunk)
  --- S: Stage unstaged changes
  --- u: Unstage (also supports staging selection/hunk)
  --- U: Unstage staged changes
  --- c: Open commit popup
  --- r: Open rebase popup
  --- L: Open log popup
  --- p: Open pull popup
  --- P: Open push popup
  --- Z: Open stash popup
  --- x: Discard changes (also supports discarding hunks)
  --- <C-r>: Refresh Buffer
  --- d: Open diffview.nvim at hovered file
  --- D: Open diff popup

  -- THEMES & COLORS
  use {'rktjmp/lush.nvim'}
  use_local {
    'pwntester/nautilus.nvim',
    config = function()
      require'nautilus'.setup({mode = "grey"})
    end,
    local_path = "dev",
  }
  use {
    'norcalli/nvim-colorizer.lua',
    branch = 'color-editor'
  }

  -- UI
  use {'ryanoasis/vim-devicons'}
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require'nvim-web-devicons'.setup()
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.g.indent_blankline_char = '¦' -- ['|', '¦', '┆', '┊']
      vim.g.indent_blankline_filetype_exclude = vim.list_extend(vim.fn.deepcopy(g.special_buffers), {'markdown'})
    end
  }
  use {'junegunn/rainbow_parentheses.vim'}
  use {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = g.special_buffers
    end
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- STATUSLINE & TABLINE
  use {
    'glepnir/galaxyline.nvim',
    config = function()
      require'plugins.galaxyline'()
    end
  }
  use {
    'akinsho/nvim-bufferline.lua',
    config = function()
      require'plugins.nvim-bufferline'()
    end
  }

  -- PAIRING
  --
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" , "octo" },
        --ignored_next_char = [[ [%w%%%{%(%[%"%'%.] ]]
        ignored_next_char = "[%w%.%(%{%[]"
      })

      require("nvim-autopairs.completion.compe").setup({
        map_cr = true, --  map <CR> on insert mode
        map_complete = true -- it will auto insert `(` after select function or method item
      })
    end
  }

  -- FILE EXPLORER
  use {
    'kyazdani42/nvim-tree.lua',
    cmd = {'NvimTreeToggle', 'NvimTreeFindFile'},
    config = function()
      vim.g.nvim_tree_width = 30
      vim.g.nvim_tree_ignore = {'.git'}
      vim.g.nvim_tree_auto_open = 0
      vim.g.nvim_tree_gitignore = 1
      vim.g.nvim_tree_auto_ignore_ft = g.special_buffers
      vim.g.nvim_tree_quit_on_open = 0
      vim.g.nvim_tree_follow = 0
      vim.g.nvim_tree_hide_dotfiles = 1
      vim.g.nvim_tree_add_trailing = 1
      vim.g.nvim_tree_group_empty = 1
      vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 1,
        files = 1,
      }
    end
  }

  -- COMMENTS
  use {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  }

  -- ROOTER
  use {
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_cd_cmd = 'cd'
      vim.g.rooter_targets = '/,*'
      vim.g.rooter_patterns = {'.git'}
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_change_directory_for_non_project_files = 'current'
    end
  }

  -- STATIC ANALYSIS
  use_local {
    'pwntester/codeql.nvim',
    config = function()
      vim.g.codeql_group_by_sink = true
      vim.g.codeql_max_ram = 32000
      vim.g.codeql_search_path = {'/Users/pwntester/codeql-home/codeql-repo', '/Users/pwntester/codeql-home/codeql-go'}
    end,
    local_path = "dev",
  }
  -- use_local {
  --   'pwntester/fortify.nvim',
  --   config = function()
  --     require'plugins.fortify'.setup()
  --   end,
  --   local_path = "dev",
  -- }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require'lsp_config'.setup()
    end
  }
  use {
    'mfussenegger/nvim-jdtls',
    config = function()
      require'lsp_config'.setup_jdt()
    end
  }
  use {
    'glepnir/lspsaga.nvim',
    config = function()
      require'lspsaga'.init_lsp_saga()
    end
  }
  use {
    'onsails/lspkind-nvim',
    config = function()
      require'lspkind'.init()
    end
  }
  -- use {
  --   'simrat39/symbols-outline.nvim',
  --   config = function(_)
  --     vim.g.symbols_outline = {
  --       highlight_hovered_item = false,
  --       show_guides = true,
  --       auto_preview = false,
  --       position = 'right',
  --       show_numbers = false,
  --       show_relative_numbers = false,
  --       show_symbol_details = true,
  --       keymaps = {
  --         close = "<Esc>",
  --         goto_location = "<Cr>",
  --         focus_location = "o",
  --         hover_symbol = "<C-space>",
  --         rename_symbol = "r",
  --         code_actions = "a",
  --       },
  --       lsp_blacklist = {},
  --     }
  --   end
  -- }
  -- use {
  --   'stevearc/aerial.nvim',
  --   config = function()
  --     vim.g.aerial_manage_folds = false
  --     vim.g.aerial_icons = {
  --       Class          = ' ';
  --       ClassCollapsed = ' ';
  --       Function       = '';
  --       Constant       = ' ';
  --       Collapsed      = '▶';
  --     }
  --   end
  -- }
  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 15; -- Height of the floating window
        default_mappings = false; -- Bind default mappings
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
      }
    end
  }

  -- MARKDOWN
  use {
    'SidOfc/mkdx',
    config = function()
      require'plugins.mkdx'.setup()
    end
  }
  use {
    'dkarter/bullets.vim',
    config = function()
      vim.g.bullets_enabled_file_types = {'markdown', 'octo'}
    end
  }

  -- HTTP Client
  use {'nicwest/vim-http'} -- just for the syntax
  use {
    'aquach/vim-http-client',
    config = function()
      vim.g.http_client_bind_hotkey = false
      vim.g.http_client_json_ft = 'javascript'
      vim.g.http_client_focus_output_window = false
      vim.g.http_client_preserve_responses = false
      vim.cmd [[autocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>]]
    end
  }

  -- use {'sunjon/shade.nvim', config = function()
  --   require'shade'.setup({
  --     overlay_opacity = 20,
  --     opacity_step = 1,
  --     keys = {
  --       brightness_up    = '<A-k>',
  --       brightness_down  = '<A-j>',
  --       toggle           = '<Leader>s',
  --     }
  --   })
  -- end}


end

local config = {
  display = {
    open_fn = function()
      local bufnr, winnr = require("window").floating_window({border=true, width_per=0.8, height_per=0.8})
      vim.api.nvim_set_current_win(winnr)
      return bufnr, winnr
    end
  },
  -- profile = {
  --   enable = true,
  --   threshold = 1,
  -- },
}

-- Bootstrap Packer
local install_path = string.format("%s/site/pack/packer/opt/packer.nvim", vim.fn.stdpath "data")
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.notify "Downloading packer.nvim..."
  vim.notify(
    vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
  )
  vim.cmd "packadd! packer.nvim"
  require'packer'.startup {spec, config = config}
  require"packer".sync()
else
  vim.cmd "packadd! packer.nvim"
  require'packer'.startup {spec, config = config}
end
