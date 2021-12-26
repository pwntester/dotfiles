local uv = vim.loop
local deepcopy = vim.deepcopy
local make_entry = require "telescope.make_entry"
local actions = require "telescope.actions"
local _, trouble = pcall(require, "trouble.providers.telescope")
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local window = require "pwntester.window"

local dropdown_theme = require("telescope.themes").get_dropdown {
  layout_config = {
    width = 0.8,
    height = 20,
  },
  prompt_title = false,
  results_title = false,
  previewer = false,
  file_sorter = sorters.get_fzy_sorter,
  borderchars = {
    results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
    prompt = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
  },
}

local function setup()
  require("telescope").setup {
    defaults = {
      borderchars = {
        results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        prompt = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" },
        preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
      },
      color_devicons = false,
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
      prompt_title = false,
      results_title = false,
      preview_title = false,
    },
    extensions = {
      frecency = {
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

-- cwd files
local function files()
  local function list_files(dir, exclude)
    local _files = {}
    local function scan(dir)
      local req = uv.fs_scandir(dir)
      local function iter()
        return uv.fs_scandir_next(req)
      end
      for name, ftype in iter do
        local absname = dir .. "/" .. name
        local ext = vim.fn.fnamemodify(name, ":e")
        if
          ftype == "file"
          and not vim.tbl_contains(exclude.files, name)
          and not vim.tbl_contains(exclude.exts, ext)
        then
          table.insert(_files, absname)
        elseif ftype == "directory" and not vim.tbl_contains(exclude.dirs, name) then
          scan(absname)
        end
      end
    end
    scan(dir or vim.fn.getcwd())
    return _files
  end

  local _files = list_files(nil, {
    exts = { "png" },
    files = { ".DS_Store" },
    dirs = { ".git" },
  })

  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = "Files>"
  pickers.new(opts, {
    prompt_title = "",
    finder = finders.new_table {
      results = _files,
      entry_maker = make_entry.gen_from_file(opts),
    },
    --sorter = sorters.get_fuzzy_file();
    sorter = sorters.get_fzy_sorter(),
  }):find()
end

-- buffers
local function buffers()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_title = ""
  require("telescope.builtin").buffers(opts)
end

-- module reloader
local function reloader()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = "Modules>"
  require("telescope.builtin").reloader(opts)
end

return {
  setup = setup,
  files = files,
  buffers = buffers,
  reloader = reloader,
  lsp_dynamic_symbols = lsp_dynamic_symbols,
}
