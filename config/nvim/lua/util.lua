local vim = vim
local api = vim.api

-- from https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/util.lua
-- local path_sep = is_windows and "\\" or "/"
-- local strip_dir_pat = path_sep.."([^"..path_sep.."]+)$"
-- local strip_sep_pat = path_sep.."$"
-- local is_windows = vim.loop.os_uname().version:match("Windows")
--
-- local is_fs_root
-- if is_windows then
--     is_fs_root = function(path)
--         return path:match("^%a:$")
--     end
-- else
--     is_fs_root = function(path)
--         return path == "/"
--     end
-- end
--
-- function root_pattern(bufnr, ...)
--   local patterns = vim.tbl_flatten {...}
--   local function matcher(path)
--     for _, pattern in ipairs(patterns) do
--       if exists(path_join(path, pattern)) then
--         return path
--       end
--     end
--   end
--
--   local filepath = vim.api.nvim_buf_get_name(bufnr)
--   local path = dirname(filepath)
--   return search_ancestors(path, matcher)
-- end
--
-- function search_ancestors(startpath, fn)
--   validate { fn = {fn, 'f'} }
--   if fn(startpath) then return startpath end
--   for path in iterate_parents(startpath) do
--     if fn(path) then return path end
--   end
-- end
--
-- function exists(filename)
--     local stat = vim.loop.fs_stat(filename)
--     return stat and stat.type or false
-- end
--
-- function dirname(path)
--     if not path then return end
--     local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
--     if #result == 0 then
--         return "/"
--     end
--     return result
-- end
--
-- function path_join(...)
--     local result = table.concat(vim.tbl_flatten {...}, path_sep):gsub(path_sep.."+", path_sep)
--     return result
-- end
--
-- function iterate_parents(path)
--     path = vim.loop.fs_realpath(path)
--     local function it(s, v)
--         if not v then return end
--         if is_fs_root(v) then return end
--         return dirname(v), path
--     end
--     return it, path, path
-- end



--local M = {}


-- function M.trim_empty_lines(lines)
--   local start = 1
--   for i = 1, #lines do
--     if #lines[i] > 0 then
--       start = i
--       break
--     end
--   end
--   local finish = 1
--   for i = #lines, 1, -1 do
--     if #lines[i] > 0 then
--       finish = i
--       break
--     end
--   end
--   return vim.list_extend({}, lines, start, finish)
-- end


return M
