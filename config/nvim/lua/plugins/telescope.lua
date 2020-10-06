local uv = vim.loop
local filter = vim.tbl_filter
local deepcopy = vim.deepcopy
local make_entry = require('telescope.make_entry')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')

local mappings
local theme

local function setup()
  require('telescope').setup{
    defaults = {
      winblend = 30;
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
    }
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
  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table({
      results = vim.tbl_filter(function(val)
        return 0 ~= vim.fn.filereadable(val)
      end, vim.v.oldfiles);
      entry_maker = make_entry.gen_from_file(opts)
    });
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

  local opts = deepcopy(theme)
  pickers.new(opts, {
    prompt = '';
    finder = finders.new_table({
      results = _files;
      entry_maker = make_entry.gen_from_file(opts)
    });
    sorter = sorters.get_fuzzy_file();
    attach_mappings = mappings;
  }):find()
end

-- buffers
local function buffers()
  local _buffers = filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local opts = deepcopy(theme)
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

-- github issues
local function issues(repo)

  local resp = require'octo'.get_repo_issues(repo, {})
  local results = {}
  for _,i in ipairs(resp.issues) do
    table.insert(results, {
      number = i.number;
      title = i.title;
    })
  end

  local make_issue_entry = function(result)
    return {
      valid = true;
      entry_type = make_entry.types.GENERIC;
      value = tostring(result.number);
      ordinal = tostring(result.number);
      display = string.format('#%d - %s', result.number, result.title);
    }
  end

  local custom_mappings = function(prompt_bufnr, map)
    local run_command = function()
      local selection = actions.get_selected_entry(prompt_bufnr)
      actions.close(prompt_bufnr)
      local cmd = string.format([[ lua require'octo'.get_issue('%s', '%s') ]], selection.value, repo)
      vim.cmd [[stopinsert]]
      vim.cmd(cmd)
    end

    map('i', '<CR>', run_command)
    map('n', '<CR>', run_command)
    map('i', '<C-j>', function() actions.move_selection_next(prompt_bufnr) end)
    map('i', '<C-k>', function() actions.move_selection_previous(prompt_bufnr) end)

    return true
  end

  pickers.new(deepcopy(theme), {
    prompt = '';
    finder = finders.new_table({
      results = results;
      entry_maker = make_issue_entry;
    });
    sorter = sorters.get_generic_fuzzy_sorter();
    attach_mappings = custom_mappings;
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
    attach_mappings = mappings;
  }):find()
end

local function issues_sujon(repo)

  if not vim.g.octo_last_results then vim.g.octo_last_results = {} end
  if not vim.g.octo_last_updatetime then vim.g.octo_last_updatetime = {} end

  local cache_timeout = 300 -- 5 min cache
  local current_time = os.time()
  local next_check
  if vim.g.octo_last_updatetime[repo] ~= nil then
    next_check = tonumber(vim.g.octo_last_updatetime[repo]) + cache_timeout
  else
    next_check = 0 -- now
  end

  local results = {}
  if current_time > next_check then
    local resp = require'octo'.get_repo_issues(repo, {})
    for _,i in ipairs(resp.issues) do
      table.insert(results, {
        number = i.number;
        title = i.title;
      })
    end
    local last_results = vim.api.nvim_get_var('octo_last_results')
    last_results[repo] = results
    vim.api.nvim_set_var('octo_last_results', last_results)

    local last_updatetime = vim.api.nvim_get_var('octo_last_updatetime')
    last_updatetime[repo] = current_time
    vim.api.nvim_set_var('octo_last_updatetime', last_updatetime)
  else
    results = vim.g.octo_last_results[repo]
  end

  local make_issue_entry = function(result)
    return {
      valid = true;
      entry_type = make_entry.types.GENERIC;
      value = tostring(result.number);
      ordinal = tostring(result.number);
      display = string.format('#%d - %s', result.number, result.title);
    }
  end

  local custom_mappings = function(prompt_bufnr, map)
    local run_command = function()
      local selection = actions.get_selected_entry(prompt_bufnr)
      actions.close(prompt_bufnr)
      local cmd = string.format([[ lua require'octo'.get_issue('%s', '%s') ]], selection.value, repo)
      vim.cmd [[stopinsert]]
      vim.cmd(cmd)
    end

    map('i', '<CR>', run_command)
    map('n', '<CR>', run_command)
    map('i', '<C-j>', function() actions.move_selection_next(prompt_bufnr) end)
    map('i', '<C-k>', function() actions.move_selection_previous(prompt_bufnr) end)

    return true
  end

  pickers.new(deepcopy(theme), {
    prompt = '';
    finder = finders.new_table({
      results = results;
      entry_maker = make_issue_entry;
    });
    sorter = sorters.get_generic_fuzzy_sorter();
    attach_mappings = custom_mappings;
  }):find()
end


return {
  setup = setup;
  mru = mru;
  files = files;
  buffers = buffers;
  issues = issues;
  issues_sujon = issues_sujon;
  treesitter = treesitter;
}
