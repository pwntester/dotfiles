local uv = vim.loop
local filter = vim.tbl_filter
local deepcopy = vim.deepcopy
local make_entry = require('telescope.make_entry')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')

local theme

local function setup()
  require('telescope').setup{
    defaults = {
      winblend = 30;
      default_mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<CR>"]  = actions.goto_file_selection_edit,
          ["<C-x>"] = actions.goto_file_selection_split,
          ["<C-v>"] = actions.goto_file_selection_vsplit,
          ["<C-t>"] = actions.goto_file_selection_tabedit,
        };
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
          ["<CR>"]  = actions.goto_file_selection_edit,
          ["<C-x>"] = actions.goto_file_selection_split,
          ["<C-v>"] = actions.goto_file_selection_vsplit,
          ["<C-t>"] = actions.goto_file_selection_tabedit,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
        };
      }
    }
  }

  -- custom theme
  theme = require('telescope.themes').get_dropdown({
    results_height = 25;
    results_width = 120;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
      preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    };
  })

  -- custom mappings
  mappings = function(prompt_bufnr, map)
    map('i', '<C-j>', function() actions.move_selection_next(prompt_bufnr) end)
    map('i', '<C-k>', function() actions.move_selection_previous(prompt_bufnr) end)

    return true
  end

end

-- most recent files
local function mru()
  local opts = deepcopy(theme)
  opts.prompt_prefix = 'MRU>'
  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table({
      results = vim.tbl_filter(function(val)
        return 0 ~= vim.fn.filereadable(val)
      end, vim.v.oldfiles);
      entry_maker = make_entry.gen_from_file(opts)
    });
    sorter = sorters.get_fuzzy_file();
  }):find()
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

  local opts = deepcopy(theme)
  opts.prompt_prefix = 'Files>'
  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table({
      results = _files;
      entry_maker = make_entry.gen_from_file(opts)
    });
    sorter = sorters.get_fuzzy_file();
  }):find()
end

-- buffers
local function buffers()
  local _buffers = filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local opts = deepcopy(theme)
  opts.prompt_prefix = 'Buffers>'
  opts.bufnr_width = #tostring(math.max(unpack(_buffers)))

  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table {
      results = _buffers;
      entry_maker = make_entry.gen_from_buffer(opts);
    };
    sorter = sorters.get_generic_fuzzy_sorter();
  }):find()
end

local function treesitter()
  local opts = {
    width = 90;
    winblend = 10;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    };
    show_line = false;
    prompt_prefix = 'Symbols>';
  }

  local function prepare_match(entry, kind)
    local entries = {}

    if entry.node then
        entry["kind"] = kind
        table.insert(entries, entry)
    else
      for name, item in pairs(entry) do
          vim.list_extend(entries, prepare_match(item, name))
      end
    end

    return entries
  end

  local has_nvim_treesitter, _ = pcall(require, 'nvim-treesitter')
  if not has_nvim_treesitter then
    print('You need to install nvim-treesitter')
    return
  end

  local parsers = require('nvim-treesitter.parsers')
  if not parsers.has_parser() then
    print('No parser for the current buffer')
    return
  end

  local ts_locals = require('nvim-treesitter.locals')
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local results = {}
  for _, definitions in ipairs(ts_locals.get_definitions(bufnr)) do
    local entries = prepare_match(definitions)
    for _, entry in ipairs(entries) do
      table.insert(results, entry)
    end
  end

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt = '',
    finder = finders.new_table {
      results = results,
      entry_maker = make_entry.gen_from_treesitter(opts)
    },
    results_title = false;
    preview_title = false;
    previewer = previewers.vim_buffer.new(opts),
    sorter = sorters.get_generic_fuzzy_sorter(),
  }):find()
end

local function reloader()
  local opts = deepcopy(theme)
  opts.prompt_prefix = 'Packages>'
  pickers.new(opts, {
    prompt = '',
    finder = finders.new_table {
      results = vim.tbl_keys(package.loaded),
      entry_maker = make_entry.gen_from_string(opts),
    },
    sorter = sorters.get_generic_fuzzy_sorter(),

    attach_mappings = function(prompt_bufnr, map)
      local reload_package = function()
        local selection = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        require('plenary.reload').reload_module(selection.value)
        print(string.format("[%s] - module reloaded", selection.value))
      end

      map('i', '<CR>', reload_package)
      map('n', '<CR>', reload_package)

      return true
    end
  }):find()
end

return {
  setup = setup;
  mru = mru;
  files = files;
  buffers = buffers;
  treesitter = treesitter;
  reloader = reloader;
}
