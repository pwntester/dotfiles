-- Some path manipulation utilities
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

-- Ascend the buffer's path until we find the rootdir.
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
