local vim = vim
local api = vim.api
local uv = vim.loop
local format = string.format
local menu = require'fuzzy_menu'

local function is_file(fname)
    local stat = uv.fs_stat(fname)
    return stat and stat.type == 'file' or false
end

local function list_buffers()
    local buffers = {}
    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_valid(bufnr) and api.nvim_buf_is_loaded(bufnr) then
            local entry = {
                display = api.nvim_buf_get_name(bufnr);
                id = bufnr;
            }
            if entry.display ~= '' then table.insert(buffers, entry) end
        end
    end
    return buffers
end

local function list_files(dir, exclude)
    local files = {}

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

                table.insert(files, absname)
            elseif ftype == 'directory'
                   and not vim.tbl_contains(exclude.dirs, name) then
                scan(absname)
            end
        end
    end

    scan(dir or vim.fn.getcwd())

    return files
end

local function fuzzy_buffers()
    local buffers = list_buffers()
    local winnr = api.nvim_get_current_win()
    menu.floating_fuzzy_menu{
        buffers,
        prompt_position = 'top';
        prompt = 'Buffers>';
        leave_empty_line = true;
        function(e, _, _)
            api.nvim_win_set_buf(winnr, e.id)
        end
    }
end

local function fuzzy_mru()
    local history = vim.v.oldfiles
    --history = vim.tbl_filter(function(v) return string.sub(v,1,1) == '/' end, history)
    history = vim.tbl_filter(is_file, history)
    local winnr = api.nvim_get_current_win()
    menu.floating_fuzzy_menu{
        inputs = history;
        prompt_position = 'top';
        prompt = 'MRU>';
        --virtual_text = '10/100';
        leave_empty_line = true;
        width_per = 0.8;
        height_per = 0.7;
        callback = function(e, _, _)
            api.nvim_set_current_win(winnr)
            api.nvim_command('e '..e)
        end
    }
end

local function fuzzy_files()
    local files = list_files(nil, {
        exts = {'png'};
        files = {'.DS_Store'};
        dirs = {'.git'};
    })
    local winnr = api.nvim_get_current_win()
    menu.floating_fuzzy_menu{
        inputs = files;
        prompt_position = 'top';
        prompt = 'Files>';
        leave_empty_line = true;
        width_per = 0.8;
        height_per = 0.7;
        callback = function(e, _, _)
            api.nvim_set_current_win(winnr)
            api.nvim_command('e '..e)
            --api.nvim_win_set_buf(winnr, i or load_buffer(tostring(e)))
        end
    }
end

local function fuzzy_gh_issues(repo)

    local resp = require'octo'.get_repo_issues(repo, {})

    local source = {}
    for _,i in ipairs(resp.issues) do
        table.insert(source, {
            number = i['number'];
            display = string.format('#%d - %s', i['number'], i['title']);
        })
    end

    require'fuzzy_menu'.floating_fuzzy_menu{
        inputs = source;
        prompt_position = 'top';
        leave_empty_space = true;
        height = 30;
        prompt = 'Search:';
        virtual_text = format('%d out of %d', resp.count, resp.total);
        callback = function(e, _, _)
            api.nvim_command(format('lua require"octo".get_issue(%d, %s)', e.number, repo))
        end
    }
end

return {
    buffers = fuzzy_buffers;
    mru = fuzzy_mru;
    files = fuzzy_files;
    list_files = list_files;
    fuzzy_gh_issues = fuzzy_gh_issues;
}

