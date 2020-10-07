local function setup()
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,                    -- false will disable the whole extension
      disable = {},
      custom_captures = {               -- mapping of user defined captures to highlight groups
        -- ["foo.bar"] = "Identifier"     -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {                       -- mappings for incremental selection (visual mappings)
        init_selection = '<Plug>(TsSelInit)', -- maps in normal mode to init the node/scope selection
        node_incremental = '<Plug>(TsSelNodeIncr)', -- increment to the upper named parent
        node_decremental = '<Plug>(TsSelNodeDecr)', -- decrement to the previous node
        scope_incremental = '<Plug>(TsSelScopeIncr)', -- increment to the upper scope (as defined in locals.scm)
        scope_decremental = '<Plug>(TsSelScopeDecr)', -- decrement to the upper scope (as defined in locals.scm)
      }
    },
    refactor = {
      highlight_definitions = {
        enable = true
      },
      highlight_current_scope = {
        enable = false
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "<Plug>(TsRename)"            -- mapping to rename reference under cursor
        }
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition_lsp_fallback = "<Plug>(TsGotoDef)", -- mapping to go to definition of symbol under cursor
          list_definitions = "<Plug>(TsListDefs)",        -- mapping to list all definitions in current file
          goto_next_usage = "<Plug>(TsGotoNextUse)",
          goto_previous_usage = "<Plug>(TsGotoPrevUse)",
        }
      }
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["iF"] = { -- you can define your own textobjects directly here
            python = "(function_definition) @function",
            cpp = "(function_definition) @function",
            c = "(function_definition) @function",
            java = "(method_declaration) @function"
          },
          -- or you use the queries from supported languages with textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["aC"] = "@class.outer",
          ["iC"] = "@class.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ae"] = "@block.outer",
          ["ie"] = "@block.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["is"] = "@statement.inner",
          ["as"] = "@statement.outer",
          ["ad"] = "@comment.outer",
          ["am"] = "@call.outer",
          ["im"] = "@call.inner"
        }
      },
      move = {
        enable = true,
        goto_next_start = {
          -- ["]m"] = "@function.outer",
          -- ["]]"] = "@class.outer",
          ["<Plug>(TsGotoNextFuncStart"] = "@function.outer",
          ["<Plug>(TsGotoNextClassStart"] = "@class.outer",
        },
        goto_next_end = {
          -- ["]M"] = "@function.outer",
          -- ["]["] = "@class.outer",
          ["<Plug>(TsGotoNextFuncEnd"] = "@function.outer",
          ["<Plug>(TsGotoNextClassEnd"] = "@class.outer",
        },
        goto_previous_start = {
          -- ["[m"] = "@function.outer",
          -- ["[["] = "@class.outer",
          ["<Plug>(TsGotoPrevFuncStart"] = "@function.outer",
          ["<Plug>(TsGotoPrevClassStart"] = "@class.outer",
        },
        goto_previous_end = {
          -- ["[M"] = "@function.outer",
          -- ["[]"] = "@class.outer",
          ["<Plug>(TsGotoPrevFuncEnd"] = "@function.outer",
          ["<Plug>(TsGotoPrevClassEnd"] = "@class.outer",
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false -- Whether the query persists across vim sessions
    },
    ensure_installed = 'all' -- one of 'all', 'language', or a list of languages
  }
end

return {
  setup = setup;
}
