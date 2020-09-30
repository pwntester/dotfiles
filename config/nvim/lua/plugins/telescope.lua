local uv = vim.loop
local filter = vim.tbl_filter
local make_entry = require('telescope.make_entry')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

local function setup()
  require('telescope').setup{
    defaults = {
      --shorten_path = false -- currently the default value is true
    }
  }

  -- custom theme
  local width, height = require'window'.scale_win(0.8, 0.9)
  padded_dropdown = require('telescope.themes').get_dropdown({
    width = width;
    height = height;
    winblend = 10;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    }
  })

  -- custom mappings
  function mappings (prompt_bufnr, map)
    map('i', '<C-j>', function()
      actions.move_selection_next(prompt_bufnr)
    end)
    map('i', '<C-k>', function()
      actions.move_selection_previous(prompt_bufnr)
    end)
    return true
  end

  -- no cursor line
  vim.cmd [[ autocmd FileType TelescopePrompt set nocursorline ]]
end

-- most recent files
local function mru()
  local opts = vim.deepcopy(padded_dropdown)
  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table(vim.tbl_filter(function(val)
      return 0 ~= vim.fn.filereadable(val)
    end, vim.v.oldfiles));
    sorter = sorters.get_fuzzy_file();
    attach_mappings = mappings;
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

  local opts = vim.deepcopy(padded_dropdown)

  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table(_files);
    sorter = sorters.get_fuzzy_file();
    attach_mappings = mappings;
  }):find()
end

-- buffers
local function buffers()
  local _buffers = filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local opts = vim.deepcopy(padded_dropdown)
  opts.bufnr_width = #tostring(math.max(unpack(_buffers)))

  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table {
      results = _buffers;
      entry_maker = make_entry.gen_from_buffer(opts);
    };
    sorter = sorters.get_generic_fuzzy_sorter();
    attach_mappings = mappings;
  }):find()
end

return {
  setup = setup;
  mru = mru;
  files = files;
  buffers = buffers;
}
