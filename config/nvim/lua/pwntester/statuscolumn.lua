-- Based on LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua
local vim = vim

local M = {}

---@type (fun(buf:number, lnum:number, vnum:number, win:number):Sign[]?)[]
M.virtual = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- Get regular signs
  ---@type Sign[]
  local signs = {}

  if vim.fn.has "nvim-0.10" == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
      if ret then
        ret.priority = sign.priority
        signs[#signs + 1] = ret
      end
    end
  end

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or extmark[4].sign_name or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "" } -- left, middle, right

  local show_open_folds = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_open
  local use_githl = vim.g.lazyvim_statuscolumn and vim.g.lazyvim_statuscolumn.folds_githl

  if show_signs then
    local signs = M.get_signs(buf, vim.v.lnum)

    local has_virtual = false
    for _, fn in ipairs(M.virtual) do
      local virtual = fn(buf, vim.v.lnum, vim.v.virtnum, win)
      if virtual then
        has_virtual = true
        vim.list_extend(signs, virtual)
      end
    end

    ---@type Sign?,Sign?,Sign?
    local left, right, fold, githl
    for _, s in ipairs(signs) do
      if s.name and s.name:lower():find "^octo_clean" then
        s.texthl = "IblScope"
      end
      if s.name and (s.name:find "GitSign" or s.name:find "MiniDiffSign") then
        right = s
        if use_githl then
          githl = s["texthl"]
        end
      else
        left = s
      end
    end
    if vim.v.virtnum ~= 0 and not has_virtual then
      left = nil
    end

    vim.api.nvim_win_call(win, function()
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = githl or "Folded" }
      elseif
        show_open_folds
        -- and not LazyVim.ui.skip_foldexpr[buf]
        and vim.treesitter.foldexpr(vim.v.lnum):sub(1, 1) == ">"
      then -- fold start
        fold = { text = vim.opt.fillchars:get().foldopen or "", texthl = githl }
      end
    end)
    -- Left: mark or non-git sign
    components[1] = M.icon(M.get_mark(buf, vim.v.lnum) or left)
    -- Right: fold icon or git sign (only if file)
    components[3] = is_file and M.icon(fold or right) or ""
  end

  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      components[2] = is_num and "%l" or "%r" -- the current line
    else
      components[2] = is_relnum and "%r" or "%l" -- other lines
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  if vim.v.virtnum ~= 0 then
    components[2] = "%= "
  end

  return table.concat(components, "")
end

---@return Sign?
---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match "[a-zA-Z]" then
      return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
    end
  end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

return M
