local api = vim.api
local format = string.format
local uv = vim.loop
local filter = vim.tbl_filter
local make_entry = require('telescope.make_entry')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

local function mappings (prompt_bufnr, map)
  map('i', '<C-j>', function()
    actions.move_selection_next(prompt_bufnr)
  end)
  map('i', '<C-k>', function()
    actions.move_selection_previous(prompt_bufnr)
  end)
  return true
end

local function setup()
  require('telescope').setup{
    defaults = {
      --shorten_path = false -- currently the default value is true
    }
  }
end

local function mru()
  local dropdown_opts = require('telescope.themes').get_dropdown({
    winblend = 10;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    }
  })
  pickers.new(dropdown_opts, {
    prompt = '';
    finder = finders.new_table(vim.tbl_filter(function(val)
      return 0 ~= vim.fn.filereadable(val)
    end, vim.v.oldfiles));
    sorter = sorters.get_fuzzy_file();
    attach_mappings = mappings;
  }):find()
end

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

  local dropdown_opts = require('telescope.themes').get_dropdown({
    winblend = 10;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    }
  })
  local _files = list_files(nil, {
    exts = {'png'};
    files = {'.DS_Store'};
    dirs = {'.git'};
  })

  pickers.new(dropdown_opts, {
    prompt = '';
    finder = finders.new_table(_files);
    sorter = sorters.get_fuzzy_file();
    attach_mappings = mappings;
  }):find()
end

local function buffers()
  local dropdown_opts = require('telescope.themes').get_dropdown({
    winblend = 10;
    borderchars = {
      prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
      results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    }
  })
  local _buffers = filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  if not dropdown_opts.bufnr_width then
    local max_bufnr = math.max(unpack(_buffers))
    dropdown_opts.bufnr_width = #tostring(max_bufnr)
  end

  pickers.new(dropdown_opts, {
    prompt = '';
    finder = finders.new_table {
      results = _buffers;
      entry_maker = make_entry.gen_from_buffer(dropdown_opts);
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
