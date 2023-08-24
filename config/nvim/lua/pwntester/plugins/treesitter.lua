local colors = require("nautilus.theme").colors.octonauts
local function setup()
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      colors = { colors.blue, colors.blue2, colors.blue3, colors.blue4, colors.blue5, colors.blue6 }
    },
    highlight = {
      enable = true,
      disable = { "xml" },
      --additional_vim_regex_highlighting = { "markdown" }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = "<Plug>(TsSelInit)",         -- maps in normal mode to init the node/scope selection
        node_incremental = "<Plug>(TsSelNodeIncr)",   -- increment to the upper named parent
        node_decremental = "<Plug>(TsSelNodeDecr)",   -- decrement to the previous node
        scope_incremental = "<Plug>(TsSelScopeIncr)", -- increment to the upper scope (as defined in locals.scm)
        scope_decremental = "<Plug>(TsSelScopeDecr)", -- decrement to the upper scope (as defined in locals.scm)
      },
    },
    indent = {
      enable = true,
    },
    refactor = {
      highlight_definitions = {
        enable = false,
      },
      highlight_current_scope = {
        enable = false,
      },
      smart_rename = {
        enable = false,
        keymaps = {
          smart_rename = "<Plug>(TsRename)", -- mapping to rename reference under cursor
        },
      },
      navigation = {
        enable = false,
        keymaps = {
          goto_definition_lsp_fallback = "<Plug>(TsGotoDef)", -- mapping to go to definition of symbol under cursor
          list_definitions = "<Plug>(TsListDefs)",            -- mapping to list all definitions in current file
          goto_next_usage = "<Plug>(TsGotoNextUse)",
          goto_previous_usage = "<Plug>(TsGotoPrevUse)",
        },
      },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          -- or you use the queries from supported languages with textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        goto_next_start = {
          ["<Plug>(TsGotoNextFuncStart"] = "@function.outer",
          ["<Plug>(TsGotoNextClassStart"] = "@class.outer",
        },
        goto_next_end = {
          -- ["<Plug>(TsGotoNextFuncEnd"] = "@function.outer",
          -- ["<Plug>(TsGotoNextClassEnd"] = "@class.outer",
          ["]m"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]i"] = "@scopename.inner",
        },
        goto_previous_start = {
          --["<Plug>(TsGotoPrevFuncStart"] = "@function.outer",
          --["<Plug>(TsGotoPrevClassStart"] = "@class.outer",
          ["[m"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[i"] = "@scopename.inner",
        },
        goto_previous_end = {
          ["<Plug>(TsGotoPrevFuncEnd"] = "@function.outer",
          ["<Plug>(TsGotoPrevClassEnd"] = "@class.outer",
        },
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    playground = {
      enable = false,
      updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
    },
  }

  require("nvim-treesitter").define_modules {
    mappings = {
      enable = true, -- false will disable the whole extension
      attach = function(bufnr)
        g.map(require("pwntester.mappings").treesitter, { silent = false }, bufnr)
      end,
      detach = function()
      end,
      is_supported = function()
        return true
      end,
    },
  }

  vim.treesitter.language.register('markdown', 'octo')
end

return {
  setup = setup,
}
