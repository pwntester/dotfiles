local vim = vim
local api = vim.api

local function list_buffers()
    local buffers = {}
    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_valid(bufnr) and api.nvim_buf_is_loaded(bufnr) then
            local label = api.nvim_buf_get_name(bufnr)
            if label ~= '' then table.insert(buffers, label) end
        end
    end
    return buffers
end

local function fuzzy_buffers()
    local buffers = list_buffers()
    local winnr = api.nvim_get_current_win()
    require'ui'.floating_fuzzy_menu{
        buffers,
        function(e, i, c)
            --api.nvim_win_set_buf(winnr, i)
            api.nvim_command('e '..e)
        end
    }
end

local function fuzzy_mru()
    local history = list_buffers()
    --vim.list_extend(history, {vim.fn.expand('%')})
    vim.list_extend(history, vim.v.oldfiles)
    local winnr = api.nvim_get_current_win()
    require'ui'.floating_fuzzy_menu{
        history,
        function(e, i, c)
            api.nvim_command('e '..e)
            --api.nvim_win_set_buf(winnr, i or load_buffer(tostring(e)))
        end
    }
end

return {
    buffers = fuzzy_buffers;
    mru = fuzzy_mru;
}

