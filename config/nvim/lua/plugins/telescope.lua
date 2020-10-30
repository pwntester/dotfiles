local uv = vim.loop
local deepcopy = vim.deepcopy
local make_entry = require('telescope.make_entry')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

local dropdown_theme = require('telescope.themes').get_dropdown({
  results_height = 20;
  --winblend = 10;
  width = 0.8;
  prompt_title = '';
  previewer = false;
  file_sorter = sorters.get_fzy_sorter;
  borderchars = {
    prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
  };
})

local full_theme = {
  --winblend = 10;
  width = 0.8;
  prompt_title = '';
  show_line = false;
  results_title = '';
  preview_title = '';
  borderchars = {
    prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    results = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
  };
}

local function setup()
  require('telescope').setup{
    defaults = {
      color_devicons = false;
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
        };
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
        };
      }
    }
  }
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
        local absname = dir..'/'..name
        local ext = vim.fn.fnamemodify(name, ':e')
        if ftype == 'file'
          and not vim.tbl_contains(exclude.files, name)
          and not vim.tbl_contains(exclude.exts, ext) then
            table.insert(_files, absname)
        elseif ftype == 'directory' and not vim.tbl_contains(exclude.dirs, name) then
          scan(absname)
        end
      end
    end
    scan(dir or vim.fn.getcwd())
    return _files
  end

  local _files = list_files(nil, {
    exts = {'png'};
    files = {'.DS_Store'};
    dirs = {'.git'};
  })

  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = 'Files>'
  pickers.new(opts, {
    prompt_title = '';
    finder = finders.new_table({
      results = _files;
      entry_maker = make_entry.gen_from_file(opts)
    });
    --sorter = sorters.get_fuzzy_file();
    sorter = sorters.get_fzy_sorter();
  }):find()
end

-- most recent files
local function fd()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = 'Files>'
  require'telescope.builtin'.find_files(opts)
end

-- most recent files
local function mru()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = 'MRU>'
  require'telescope.builtin'.oldfiles(opts)
end

-- buffers
local function buffers()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = 'Buffers>'
  require'telescope.builtin'.buffers(opts)
end

-- module reloader
local function reloader()
  local opts = deepcopy(dropdown_theme)
  opts.prompt_prefix = 'Modules>'
  require'telescope.builtin'.reloader(opts)
end

-- treesitter symbols
local function treesitter()
  local opts = deepcopy(full_theme)
  opts.prompt_prefix = 'TS Symbols>'
  require'telescope.builtin'.treesitter(opts)
end

-- live grep
local function live_grep()
  local opts = deepcopy(full_theme)
  opts.prompt_prefix = 'RG>'
  require'telescope.builtin'.live_grep(opts)
end

return {
  setup = setup;
  mru = mru;
  files = files;
  fd = fd;
  buffers = buffers;
  treesitter = treesitter;
  reloader = reloader;
  live_grep = live_grep;
}
