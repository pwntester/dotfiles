local have_make = vim.fn.executable "make" == 1
local have_cmake = vim.fn.executable "cmake" == 1
local g = require "pwntester.globals"

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function(plugin)
          g.on_load("telescope.nvim", function()
            vim.ui.select = function(...)
              -- This will override the `vim.ui.select` function with a new implementation.
              pcall(require("telescope").load_extension, "ui-select")
              vim.ui.select(...)
            end
          end)
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = have_make and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = have_make or have_cmake,
        config = function(plugin)
          g.on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. "so"
              if not vim.uv.fs_stat(lib) then
                print "`telescope-fzf-native.nvim` not built. Rebuilding..."
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  print "Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim."
                end)
              else
                print("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
              end
            end
          end)
        end,
      },
    },
    opts = function()
      local actions = require "telescope.actions"

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

      -- local dropdown_borderchars = {
      --   results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
      --   prompt = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
      -- }
      local dropdown_layout_config = {
        width = 0.8,
        height = 20,
      }

      return {
        defaults = {
          prompt_title = false,
          results_title = false,
          preview_title = false,
          multi_icon = "",
          layout_strategy = "flex",
          scroll_strategy = "cycle",
          selection_strategy = "reset",
          winblend = 0,
          dynamic_preview_title = false,
          color_devicons = true,
          layout_config = {
            vertical = {
              mirror = true,
            },
            center = {
              mirror = true,
            },
          },
          file_ignore_patterns = { "build", "tags", "src/parser.c" },
          hl_result_eol = false,
          preview = false,
          -- {
          --   msg_bg_fillchar = " ",
          -- },
          cache = false,
          borderchars = {
            results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
            prompt = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" },
            preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close,
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          buffers = {
            sort_mru = true,
            theme = "dropdown",
            previewer = false,
            prompt_title = false,
            results_title = false,
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer },
            },
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
          },
          oldfiles = {
            previewer = false,
            prompt_title = "",
            results_title = "",
          },
          find_files = {
            theme = "dropdown",
            previewer = false,
            prompt_title = false,
            results_title = false,
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
            -- hidden = true,
          },
          grep_string = {
            theme = "dropdown",
            previewer = false,
            prompt_title = false,
            results_title = false,
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
            prompt_title = false,
            results_title = false,
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
          },
          man_pages = { sections = { "2", "3" } },
          lsp_references = { path_display = { "shorten" } },
          lsp_document_symbols = { path_display = { "hidden" } },
          lsp_workspace_symbols = { path_display = { "shorten" } },
          lsp_code_actions = {
            theme = "dropdown",
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
          },
          current_buffer_fuzzy_find = {
            theme = "dropdown",
            -- borderchars = dropdown_borderchars,
            layout_config = dropdown_layout_config,
          },
        },
        extensions = {
          -- frecency = {
          --   persistent_filter = false,
          --   show_scores = true,
          --   show_unindexed = true,
          --   ignore_patterns = { ".*codeql_db.*", "*.git/*", "*/tmp/*" },
          -- },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }
    end,
    -- stylua: ignore
    -- keys = {
    --   { "<leader>f", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    --   { "<leader>l", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    --   { "<leader>o", function() require("telescope.builtin").buffers() end, desc = "Open buffers" },
    --   { "<leader>m", function() require("telescope.builtin").oldfiles() end, desc = "Most Recently Used" },
    -- }
  },
}
