-- some path manipulation utilities
function is_dir(filename)
    local stat = vim.loop.fs_stat(filename)
    return stat and stat.type == 'directory' or false
end

local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
-- Asumes filepath is a file.
local function dirname(filepath)
    local is_changed = false
    local result = filepath:gsub(path_sep.."([^"..path_sep.."]+)$", function()
        is_changed = true
        return ""
    end)
    return result, is_changed
end

function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
end

-- ascend the buffer's path until we find the rootdir.
-- is_root_path is a function which returns bool
function buffer_find_root_dir(bufnr, is_root_path)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.filereadable(bufname) == 0 then
        return nil
    end
    local dir = bufname
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
        local did_change
        dir, did_change = dirname(dir)
        if is_root_path(dir, bufname) then
            return dir, bufname
        end
        -- If we can't ascend further, then stop looking.
        if not did_change then
            return nil
        end
    end
end

-- dump table to string
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- start with helper function
function starts_with(str, start)
   return str:sub(1, #start) == start
end

--  get decoration column with (signs + folding + number)
function window_decoration_columns()
    local decoration_width = 0 

    -- number width
    -- Note: 'numberwidth' is only the minimal width, can be more if...
    local max_number = 0
    if vim.api.nvim_win_get_option(0,"number") then
        -- ...the buffer has many lines.
        max_number = vim.api.nvim_buf_line_count(bufnr) 
    elseif vim.api.nvim_win_get_option(0,"relativenumber") then
        -- ...the window width has more digits.
        max_number = vim.fn.winheight(0)
    end
    if max_number > 0 then
        local actual_number_width = string.len(max_number) + 1
        local number_width = vim.api.nvim_win_get_option(0,"numberwidth")
        decoration_width = decoration_width + math.max(number_width, actual_number_width)
    end

    -- signs
    if vim.fn.has('signs') then
        local signcolumn = vim.api.nvim_win_get_option(0,"signcolumn")
        local signcolumn_width = 2 
        if starts_with(signcolumn, 'yes') or starts_with(signcolumn, 'auto') then
            decoration_width = decoration_width + signcolumn_width
        end
    end

    -- folding
    if vim.fn.has('folding') then
        local folding_width = vim.api.nvim_win_get_option(0,"foldcolumn")
        decoration_width = decoration_width + folding_width
    end

    return decoration_width
end
