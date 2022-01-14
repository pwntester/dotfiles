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

-- Bootstrap Packer
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

vim.cmd "packadd! packer.nvim"
return require("packer").startup {
  function(use)
    use {
      "wbthomason/packer.nvim",
      opt = true,
    }

    -- DEPS
    use { "nvim-lua/popup.nvim" }
    use { "nvim-lua/plenary.nvim" }

    -- BASICS
    use { "jdhao/better-escape.vim" }
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
          -- next_buffer_cmd = function(windows)
          --   require("bufferline").cycle(1)
          --   local bufnr = vim.api.nvim_get_current_buf()
          --
          --   for _, window in ipairs(windows) do
          --     vim.api.nvim_win_set_buf(window, bufnr)
          --   end
          -- end,
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
          config = function()
            require("telescope").load_extension "fzf"
          end,
        },
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = "tami5/sqlite.lua",
          config = function()
            require("telescope").load_extension "frecency"
          end,
        },
        {
          "nvim-telescope/telescope-live-grep-raw.nvim",
        },
        --- to search `foo` on java files use: `-tjava foo`
        {
          "camgraff/telescope-tmux.nvim",
          config = function()
            require("telescope").load_extension "tmux"
          end,
        },
        {
          "nvim-telescope/telescope-symbols.nvim",
        },
      },
      config = function()
        require("pwntester.plugins.telescope").setup()
      end,
    }
    use_local {
      "pwntester/telescope-zip.nvim",
      local_path = "dev/personal",
    }

    -- COMPLETION
    use { "hrsh7th/cmp-nvim-lua" }
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        --{ "hrsh7th/cmp-copilot" },
        { "f3fora/cmp-spell" },
        { "saadparwaiz1/cmp_luasnip" },
        { "dmitmel/cmp-cmdline-history" },
      },
      config = function()
        require("pwntester.plugins.nvim-cmp").setup()
      end,
    }

    -- SNIPPETS
    use {
      "L3MON4D3/LuaSnip",
      after = "nvim-cmp",
      requires = {
        { "rafamadriz/friendly-snippets" },
      },
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
      "github/copilot.vim",
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = "<Plug>(Tabout)"
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
    use_local {
      "nvim-treesitter/nvim-treesitter",
      local_path = "dev/nvim",
      config = function()
        require("pwntester.plugins.treesitter").setup()
      end,
    }
    use {
      "nvim-treesitter/playground",
      wants = { "nvim-treesitter" },
    }
    use {
      "nvim-treesitter/completion-treesitter",
      wants = { "nvim-treesitter" },
    }
    use {
      "nvim-treesitter/nvim-treesitter-refactor",
      wants = { "nvim-treesitter" },
    }
    use {
      "nvim-treesitter/nvim-treesitter-textobjects",
      wants = { "nvim-treesitter" },
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
    use {
      "ggandor/lightspeed.nvim",
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
    -- use_local {
    --   "pwntester/octo-notifications.nvim",
    --   requires = "pwntester/octo.nvim",
    --   local_path = "dev/personal",
    -- }
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
    -- use {
    --   "EdenEast/nightfox.nvim",
    --   config = function()
    --     local nightfox = require "nightfox"
    --     nightfox.setup {
    --       fox = "nightfox",
    --       colors = {},
    --       hlgroups = {
    --         TelescopeBorder = { fg = "${border}" },
    --       },
    --     }
    --     nightfox.load()
    --   end,
    -- }
    use_local {
      "pwntester/nautilus.nvim",
      local_path = "dev/personal",
      config = function()
        require("nautilus").load {
          transparent = false,
        }
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
      "MunifTanjim/nui.nvim",
      module = "nui",
    }
    -- use {
    --   "lukas-reineke/indent-blankline.nvim",
    --   config = function()
    --     vim.g.indent_blankline_char = "¦" -- ['|', '¦', '┆', '┊']
    --     vim.g.indent_blankline_filetype_exclude = vim.list_extend(vim.fn.deepcopy(g.special_buffers), { "markdown" })
    --   end,
    -- }
    use { "junegunn/rainbow_parentheses.vim" }
    -- use {
    --   "RRethy/vim-illuminate",
    --   config = function()
    --     vim.g.Illuminate_ftblacklist = vim.list_extend(vim.fn.deepcopy(g.special_buffers), { "markdown" })
    --   end,
    -- }
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {}
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

    -- STATUSLINE & TABLINE
    use {
      "windwp/windline.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require "pwntester.plugins.windline"
      end,
    }
    -- use {
    --   "akinsho/nvim-bufferline.lua",
    --   config = function()
    --     require "pwntester.plugins.nvim-bufferline"()
    --   end,
    -- }

    -- FILE EXPLORER
    use {
      "Xuyuanp/yanil",
      config = function()
        require("pwntester.plugins.yanil").setup()
      end,
    }
    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v1.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup()
      end,
    }

    -- COMMENTS
    use {
      "JoosepAlviste/nvim-ts-context-commentstring",
      wants = { "nvim-treesitter" },
    }
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup {
          pre_hook = function(ctx)
            local U = require "Comment.utils"

            local location = nil
            if ctx.ctype == U.ctype.block then
              location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring {
              key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
              location = location,
            }
          end,
        }
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
          patterns = { ".git" },
          ignore_lsp = {},
          silent_chdir = true,
          datapath = vim.fn.stdpath "data",
        }
      end,
    }

    -- STATIC ANALYSIS
    use_local {
      "pwntester/codeql.nvim",
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("codeql").setup {
          results = {
            max_paths = 10,
            max_path_depth = nil,
          },
          panel = {
            group_by = "sink",
            show_filename = true,
            long_filename = false,
          },
          max_ram = 32000,
          format_on_save = true,
          search_path = {
            "/Users/pwntester/codeql-home/codeql",
            "/Users/pwntester/codeql-home/codeql-go",
            "/Users/pwntester/codeql-home/codeql-ruby",
            "./codeql",
          },
        }
      end,
      local_path = "dev/personal",
    }
    -- use_local {
    --   'pwntester/fortify.nvim',
    --   config = function()
    --     require'pwntester.plugins.fortify'.setup()
    --   end,
    --   local_path = 'dev/personal',
    -- }

    -- LSP
    use {
      "neovim/nvim-lspconfig",
      requires = { "cmp-nvim-lsp" },
      config = function()
        require("pwntester.lsp").setup()
      end,
    }
    use { "ii14/lsp-command" }
    use {
      "mfussenegger/nvim-jdtls",
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
      "filipdutescu/renamer.nvim",
      branch = "master",
      requires = { { "nvim-lua/plenary.nvim" } },
      config = function()
        require("renamer").setup {}
      end,
    }

    -- MARKDOWN
    use {
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
    }
    use {
      "Pocco81/TrueZen.nvim",
      config = function()
        require("true-zen").setup {
          integrations = {
            vim_gitgutter = false,
            --galaxyline = true,
            --tmux = true,
            gitsigns = true,
            --nvim_bufferline = true,
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

    -- SEARCH
    use {
      "kevinhwang91/nvim-hlslens",
      config = function()
        require("hlslens").setup {
          calm_down = true,
          nearest_only = true,
          -- nearest_float_when = "always",
          build_position_cb = function(plist, bufnr, changedtick, pattern)
            require("scrollbar.handlers.search").handler.show(plist.start_pos)
          end,
        }
      end,
    }

    -- Scrollbar
    use {
      "petertriho/nvim-scrollbar",
      config = function()
        local c = require("nautilus.theme").colors
        require("scrollbar").setup {
          excluded_filetypes = g.special_buffers,
          handle = {
            text = " ",
            color = c.cobalt,
            hide_if_all_visible = true, -- Hides handle if all lines are visible
          },
          marks = {
            Search = { text = { "-", "=" }, priority = 0, color = "orange" },
            Error = { text = { "-", "=" }, priority = 1, color = "red" },
            Warn = { text = { "-", "=" }, priority = 2, color = "yellow" },
            Info = { text = { "-", "=" }, priority = 3, color = "blue" },
            Hint = { text = { "-", "=" }, priority = 4, color = "green" },
            Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
          },
        }
        vim.cmd [[
          augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
        ]]
      end,
    }

    -- HTTP Client
    use {
      "NTBBloodbath/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("rest-nvim").setup {
          -- Open request results in a horizontal split
          result_split_horizontal = false,
          -- Skip SSL verification, useful for unknown certificates
          skip_ssl_verification = false,
          -- Highlight request on run
          highlight = {
            enabled = true,
            timeout = 150,
          },
          result = {
            -- toggle showing URL, HTTP info, headers at top the of result window
            show_url = true,
            show_http_info = true,
            show_headers = true,
          },
          -- Jump to request line on run
          jump_to_request = false,
          env_file = ".env",
          custom_dynamic_variables = {},
          yank_dry_run = true,
        }
        vim.cmd [[autocmd FileType http nmap <C-j> <Plug>RestNvim]]
      end,
    }

    -- use { "alexghergh/nvim-tmux-navigation" }
    use { "nathom/tmux.nvim" }

    -- DOCKER
    -- use_local {
    --   "pwntester/crane.nvim",
    --   local_path = "dev/personal",
    --   config = function()
    --     require("crane").setup()
    --   end,
    -- }

    -- Try:
    -- ldelossa/calltree.nvim
    -- AckslD/nvim-neoclip.lua
    -- https://github.com/lewis6991/spellsitter.nvim
    -- https://www.reddit.com/r/neovim/comments/rgclni/jsonls_autocompletion_using_schemastore/

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        local bufnr, winnr = require("pwntester.window").floating_window {
          border = true,
          width_per = 0.8,
          height_per = 0.8,
        }
        vim.api.nvim_set_current_win(winnr)
        return bufnr, winnr
      end,
    },
    -- profile = {
    --   enable = true,
    --   threshold = 1,
    -- },
  },
}