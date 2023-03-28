local telescope = require "telescope"
local actions = require "telescope.actions"
local _, trouble = pcall(require, "trouble.providers.telescope")
local window = require "pwntester.window"

local dropdown_borderchars = {
  results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
  prompt = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
}
local dropdown_layout_config = {
  width = 0.8,
  height = 20,
}

local function setup()
  telescope.setup {
    defaults = {
      prompt_title = false,
      results_title = false,
      preview_title = false,
      multi_icon = "",
      layout_strategy = "flex",
      scroll_strategy = "cycle",
      selection_strategy = "reset",
      winblend = 0,
      dynamic_preview_title = true,
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
          ["<c-t>"] = trouble.open_with_trouble,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
          ["<c-t>"] = trouble.open_with_trouble,
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
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      frecency = {
        previewer = false,
        prompt_title = "",
        results_title = "",
      },
      projects = {
        theme = "dropdown",
        previewer = false,
        prompt_title = false,
        results_title = false,
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      find_files = {
        theme = "dropdown",
        previewer = false,
        prompt_title = false,
        results_title = false,
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      grep_string = {
        theme = "dropdown",
        previewer = false,
        prompt_title = false,
        results_title = false,
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      git_files = {
        theme = "dropdown",
        previewer = false,
        prompt_title = false,
        results_title = false,
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      reloader = {
        theme = "dropdown",
        previewer = false,
        prompt_title = false,
        results_title = false,
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      man_pages = { sections = { "2", "3" } },
      lsp_references = { path_display = { "shorten" } },
      lsp_document_symbols = { path_display = { "hidden" } },
      lsp_workspace_symbols = { path_display = { "shorten" } },
      lsp_code_actions = {
        theme = "dropdown",
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
      current_buffer_fuzzy_find = {
        theme = "dropdown",
        borderchars = dropdown_borderchars,
        layout_config = dropdown_layout_config,
      },
    },
    extensions = {
      frecency = {
        persistent_filter = false,
        show_scores = true,
        show_unindexed = true,
        ignore_patterns = { ".*codeql_db.*", "*.git/*", "*/tmp/*" },
        workspaces = {
          ["octo"] = "/Users/pwntester/dev/personal/octo.nvim",
          ["dots"] = "/Users/pwntester/dotfiles",
          ["ql"] = "/Users/pwntester/research/codeql/codeql-securitylab",
          ["notes"] = "/Users/pwntester/bitacora",
        },
      },
    },
  }

  telescope.load_extension "fzf"
  telescope.load_extension "frecency"
  telescope.load_extension "octo"
  telescope.load_extension "ui-select"
  telescope.load_extension "projects"
  telescope.load_extension "gh"
end

-- LSP workspace symbols
local function lsp_dynamic_symbols()
  local opts = require("telescope.themes").get_dropdown {
    layout_config = {
      width = 0.4,
      height = 15,
    },
    prompt_title = "",
    previewer = false,
    borderchars = {
      prompt = window.window_border_chars_telescope_prompt,
      results = window.window_border_chars_telescope_results,
      preview = window.window_border_chars_telescope_preview,
    },
  }
  require("telescope.builtin.lsp").dynamic_workspace_symbols(opts)
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
--local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local set_db = require("codeql").set_database
local codeql_dbs = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "CodeQL Databases",
    finder = finders.new_oneshot_job({ "find", "/Users/pwntester/seclab/workshops/h-c0n_workshop/", "-type", "d", "-maxdepth", "1" }, opts ),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(selection.value)
        set_db(selection.value)
      end)
			return true
		end,
  }):find()
end


return {
  setup = setup,
  lsp_dynamic_symbols = lsp_dynamic_symbols,
  codeql_dbs = codeql_dbs
}
