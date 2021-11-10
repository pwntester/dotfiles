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
    "wbthomason/packer.nvim",
    opt = true,
  }

  -- DEPS
  -- use { "tami5/sqlite.lua" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }

  -- BASICS
  use { "jdhao/better-escape.vim" }
  use { "monaqa/dial.nvim" }
  use {
    "t9md/vim-choosewin",
    config = function()
      vim.g.choosewin_overlay_enable = 1
    end,
  }
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  }
  use {
    "kazhala/close-buffers.nvim",
    config = function()
      require("close_buffers").setup {
        filetype_ignore = {}, -- Filetype to ignore when running deletions
        preserve_window_layout = { "this" },
        next_buffer_cmd = function(windows)
          require("bufferline").cycle(1)
          local bufnr = vim.api.nvim_get_current_buf()

          for _, window in ipairs(windows) do
            vim.api.nvim_win_set_buf(window, bufnr)
          end
        end,
      }
    end,
    -- BDelete! all glob=*octo://*
  }

  -- TELESCOPE.NVIM
  use {
    "nvim-lua/telescope.nvim",
    cmd = "Telescope",
    module_pattern = "telescope.*",
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        after = "telescope.nvim",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        after = "telescope.nvim",
        requires = "tami5/sqlite.lua",
        config = function()
          require("telescope").load_extension "frecency"
        end,
      },
      {
        "camgraff/telescope-tmux.nvim",
        after = "telescope.nvim",
        config = function()
          require("telescope").load_extension "tmux"
        end,
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
        after = "telescope.nvim",
      },
      {
        "ekickx/clipboard-image.nvim",
        config = function()
          require("clipboard-image").setup {
            markdown = {
              img_dir = "resources/attachments",
              img_dir_txt = "resources/attachments",
              affix = "![](%s)",
            },
          }
        end,
      },
    },
    config = function()
      require("plugins.telescope").setup()
    end,
  }

  -- COMPLETION
  use {
    "saadparwaiz1/cmp_luasnip",
    requires = { "LuaSnip" },
  }
  --use { "tzachar/fuzzy.nvim" }
  --use { "tzachar/cmp-fzy-buffer", requires = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } }
  --use { "tzachar/cmp-fuzzy-path", requires = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-path", "tzachar/fuzzy.nvim" } }
  use { "hrsh7th/cmp-nvim-lua" }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
      { "f3fora/cmp-spell", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      {
        "tzachar/cmp-fuzzy-path",
        after = "cmp-path",
        requires = { "hrsh7th/cmp-path", "tzachar/fuzzy.nvim" },
      },
      {
        "tzachar/cmp-fuzzy-buffer",
        after = "nvim-cmp",
        requires = { "tzachar/fuzzy.nvim" },
      },
    },
    config = function()
      require("plugins.nvim-cmp").setup()
    end,
  }

  -- SNIPPETS
  use {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    module = "luasnip",
    requires = "friendly-snippets",
    config = function()
      local ls = require "luasnip"
      ls.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      }
      require("luasnip/loaders/from_vscode").lazy_load()
    end,
  }
  use {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
  }
  -- use { "hrsh7th/vim-vsnip" }
  -- use { "seudev/vscode-java-snippets" }
  -- use { "NexSabre/vscode-python-snippets" }
  -- use { "github/vscode-codeql" }

  -- PAIRS
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      local npairs = require "nvim-autopairs"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local Rule = require "nvim-autopairs.rule"

      npairs.setup {
        disable_filetype = { "TelescopePrompt", "octo" },
        --ignored_next_char = [[ [%w%%%{%(%[%'%'%.] ]]
        ignored_next_char = "[%w%.%(%{%[]",
      }

      npairs.add_rule(Rule("|", "", "ql"))

      local cmp = require "cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  }

  -- TREESITTER
  use {
    "nvim-treesitter/nvim-treesitter",
    --event = 'BufRead',
    config = function()
      require("plugins.treesitter").setup()
    end,
  }
  use {
    "nvim-treesitter/playground",
    requires = "nvim-treesitter",
  }
  use {
    "nvim-treesitter/completion-treesitter",
    requires = "nvim-treesitter",
  }
  use {
    "nvim-treesitter/nvim-treesitter-refactor",
    requires = "nvim-treesitter",
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter",
  }

  -- ALIGNING
  use {
    "junegunn/vim-easy-align",
    keys = "<Plug>(EasyAlign)",
    --- MD tables: `EasyAlign*<Bar>`
  }

  -- TEXT OBJECTS/MOTIONS/OPERATORS
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup { mappings_style = "sandwich" }
    end,
    --- add: sa{motion/textobject}{delimiter}
    --- delete: sd{delimiter}
    --- replace: sr{old}{new}
    --- ss repeats last surround command.
  }
  use {
    "chaoren/vim-wordmotion",
    config = function()
      vim.g.wordmotion_prefix = "_"
    end,
  }

  -- GIT
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        signs = {
          add = { hl = "GitSignsAdd", text = "+" },
          change = { hl = "GitSignsChange", text = "~" },
          delete = { hl = "GitSignsDelete", text = "_" },
          topdelete = { hl = "GitSignsDelete", text = "‾" },
          changedelete = { hl = "GitSignsChange", text = "~" },
        },
        keymaps = {
          noremap = true,
          buffer = true,
        },
        watch_index = {
          interval = 1000,
        },
        sign_priority = 6,
        status_formatter = nil,
        on_attach = function()
          if vim.bo.ft == "markdown" then
            return false
          end
        end,
      }
    end,
  }
  use {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  }
  --- <leader>gy
  use_local {
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup {
        reaction_viewer_hint_icon = "",
      }
    end,
    local_path = "dev/personal",
    requires = { "nvim-telescope/telescope.nvim" },
  }
  use_local {
    "pwntester/octo-notifications.nvim",
    requires = "pwntester/octo.nvim",
    local_path = "dev/personal",
  }
  use { "sindrets/diffview.nvim" }
  use {
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      require("neogit").setup {
        integrations = {
          diffview = true,
        },
        disable_commit_confirmation = true,
        mappings = {
          status = {
            [">"] = "Toggle",
          },
        },
      }
    end,
  }

  -- THEMES & COLORS
  use {
    "rktjmp/lush.nvim",
  }
  use_local {
    "pwntester/nautilus.nvim",
    local_path = "dev/personal",
    requires = "rktjmp/lush.nvim",
    config = function()
      require("nautilus").setup { mode = "grey" }
    end,
  }
  use {
    "norcalli/nvim-colorizer.lua",
    branch = "color-editor",
  }

  -- UI
  use {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_char = "¦" -- ['|', '¦', '┆', '┊']
      vim.g.indent_blankline_filetype_exclude = vim.list_extend(vim.fn.deepcopy(g.special_buffers), { "markdown" })
    end,
  }
  use { "junegunn/rainbow_parentheses.vim" }
  use {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = vim.list_extend(vim.fn.deepcopy(g.special_buffers), { "markdown" })
    end,
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end,
  }

  -- STATUSLINE & TABLINE
  -- use {
  --   "glepnir/galaxyline.nvim",
  --   config = function()
  --     require "plugins.galaxyline"()
  --   end,
  -- }
  use {
    "windwp/windline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      -- vim.cmd [[set cmdheight=1]]
      -- vim.cmd [[set noshowmode]]
      require "plugins.windline"
      -- local windline = require "windline"
      --windline.setup {
      -- statuslines = {
      -- },
      --}
    end,
  }
  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require "plugins.nvim-bufferline"()
    end,
  }

  -- FILE EXPLORER
  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    config = function()
      require("plugins.nvim-tree").setup()
    end,
  }

  -- COMMENTS
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
  }

  -- ROOTER
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("telescope").load_extension "projects"
      require("project_nvim").setup {
        detection_methods = { "lsp", "pattern" },
        manual_mode = false,
        patterns = { ".git", "package.json" },
        ignore_lsp = {},
        silent_chdir = true,
        datapath = vim.fn.stdpath "data",
      }
    end,
  }

  -- STATIC ANALYSIS
  use_local {
    "pwntester/codeql.nvim",
    config = function()
      vim.g.codeql_group_by_sink = true
      vim.g.codeql_max_ram = 32000
      vim.g.codeql_search_path = {
        "/Users/pwntester/codeql-home/codeql",
        "/Users/pwntester/codeql-home/codeql-go",
        "/Users/pwntester/codeql-home/codeql-ruby",
      }
    end,
    local_path = "dev/personal",
  }
  -- use_local {
  --   'pwntester/fortify.nvim',
  --   config = function()
  --     require'plugins.fortify'.setup()
  --   end,
  --   local_path = 'dev/personal',
  -- }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = { "cmp-nvim-lsp" },
    config = function()
      require("lsp_config").setup()
    end,
  }
  use {
    "mfussenegger/nvim-jdtls",
    config = function()
      require("lsp_config").setup_jdt()
    end,
  }
  use {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init()
    end,
  }
  use {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {
        width = 120, -- Width of the floating window
        height = 15, -- Height of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
      }
    end,
  }
  use {
    "filipdutescu/Erenamer.nvim",
    branch = "master",
    requires = { { "nvim-lua/plenary.nvim" } },
  }

  -- MARKDOWN
  use {
    "Pocco81/TrueZen.nvim",
    config = function()
      require("true-zen").setup {
        integrations = {
          vim_gitgutter = false,
          --galaxyline = true,
          --tmux = true,
          gitsigns = true,
          nvim_bufferline = true,
          limelight = false,
          twilight = false,
          vim_airline = false,
          vim_powerline = false,
          vim_signify = false,
          express_line = false,
          lualine = false,
          lightline = false,
          feline = false,
        },
      }
    end,
  }

  -- HTTP Client
  use { "nicwest/vim-http" } -- just for the syntax
  use {
    "aquach/vim-http-client",
    config = function()
      vim.g.http_client_bind_hotkey = false
      vim.g.http_client_json_ft = "javascript"
      vim.g.http_client_focus_output_window = false
      vim.g.http_client_preserve_responses = false
      vim.cmd [[autocmd FileType http nnoremap <C-j> :HTTPClientDoRequest<CR>]]
    end,
  }

  use_local {
    "pwntester/crane.nvim",
    local_path = "dev/personal",
    config = function()
      require("crane").setup()
    end,
  }
  use {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require "notify"
      require("notify").setup {
        stages = "fade_in_slide_out",
        timeout = 5000,
        background_colour = "#ffcc66",
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      }
    end,
    --- :Telescope notify
    --- :lua require('telescope').extensions.notify.notify(<opts>)
  }
  use {
    "ggandor/lightspeed.nvim",
  }
  use {
    "github/copilot.vim",
    config = function()
      -- vim.g.copilot_no_tab_map = true
      -- vim.g.copilot_assume_mapped = true
      -- vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = {
        ["*"] = false,
        python = true,
        lua = true,
        go = true,
        ql = true,
        html = true,
        javascript = true,
        typescript = true,
      }
    end,
  }
  use {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup {
        calm_down = true,
        nearest_only = true,
        -- nearest_float_when = "always",
      }
    end,
  }
  use {
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup {
        nested = "QuickFixCmdPost,User LspDiagnosticsChanged",
      }
    end,
  }
  use {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp", "copilot.vim" },
    config = function()
      require("tabout").setup {
        completion = false,
        ignore_beginning = false,
        exclude = {},
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
      }
    end,
  }
end

local config = {
  display = {
    open_fn = function()
      local bufnr, winnr = require("window").floating_window { border = true, width_per = 0.8, height_per = 0.8 }
      vim.api.nvim_set_current_win(winnr)
      return bufnr, winnr
    end,
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
  vim.notify(vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd "packadd! packer.nvim"
  require("packer").startup { spec, config = config }
  require("packer").sync()
else
  vim.cmd "packadd! packer.nvim"
  require("packer").startup { spec, config = config }
end
