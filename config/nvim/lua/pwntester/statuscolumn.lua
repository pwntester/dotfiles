local icons = require("pwntester.icons")
local ffi = require("pwntester.ffi")

local gitsigns_bar = '▎' -- '▌'

local gitsigns_hl_pool = {
  GitSignsAdd          = "DiagnosticOk",
  GitSignsChange       = "DiagnosticWarn",
  GitSignsChangedelete = "DiagnosticWarn",
  GitSignsDelete       = "DiagnosticError",
  GitSignsTopdelete    = "DiagnosticError",
  GitSignsUntracked    = "NonText",
}

local diag_signs_icons = {
  DiagnosticSignError = icons.diagnostics.Error,
  DiagnosticSignWarn = icons.diagnostics.Warning,
  DiagnosticSignInfo = icons.diagnostics.Information,
  DiagnosticSignHint = icons.diagnostics.Hint,
  DiagnosticSignOk = icons.misc.Ok
}

local fillchars = vim.opt.fillchars:get()
local foldopen = fillchars.foldopen or ""
local foldclosed = fillchars.foldclose or ""
local foldsep = fillchars.foldsep or " "
local function get_fold_level_color(level)
  local hls = { "FoldColumn", "FoldColumn1", "FoldColumn2", "FoldColumn3", "FoldColumn4" }
  if level < #hls + 1 then
    return hls[level]
  else
    return "FoldColumn"
  end
end

local function get_sign_name(cur_sign)
  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign[1]

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign.signs

  if (cur_sign == nil) then
    return nil
  end

  cur_sign = cur_sign[1]

  if (cur_sign == nil) then
    return nil
  end

  return cur_sign["name"]
end

local function mk_hl(group, sym)
  return table.concat({ "%#", group, "#", sym, "%*" })
end

local function get_name_from_group(bufnum, lnum, group)
  local cur_sign_tbl = vim.fn.sign_getplaced(bufnum, {
    group = group,
    lnum = lnum
  })

  return get_sign_name(cur_sign_tbl)
end

_G.get_statuscol_fold = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains(g.special_buffers, filetype) then
    return ""
  end
  local wp = ffi.C.find_window_by_handle(0, ffi.new('Error'))
  local foldinfo = ffi.C.fold_info(wp, vim.v.lnum)
  local level = foldinfo.level

  if level == 0 then
    return " %#LineNr#"
  end

  local closed = foldinfo.lines > 0
  local first_level = level - (closed and 1 or 0)
  if first_level < 1 then first_level = 1 end

  if closed and 1 == level then
    return mk_hl(get_fold_level_color(level), foldclosed) --.. "%#LineNr#"
  elseif foldinfo.start == vim.v.lnum and first_level + 1 > foldinfo.llevel then
    return mk_hl(get_fold_level_color(level), foldopen) --.. "%#LineNr#"
  else
    return mk_hl(get_fold_level_color(level), foldsep) --.. "%#LineNr#"
  end

end

_G.get_statuscol_gitsign = function(bufnr, lnum)
  local filetype = vim.bo.filetype
  if vim.tbl_contains(g.special_buffers, filetype) then
    return ""
  end
  local cur_sign_nm = get_name_from_group(bufnr, lnum, "gitsigns_vimfn_signs_")

  if cur_sign_nm ~= nil then
    return mk_hl(gitsigns_hl_pool[cur_sign_nm], gitsigns_bar)
  else
    return " "
  end
end

_G.get_statuscol_num = function(lnum, relnum)
  local filetype = vim.bo.filetype
  if vim.tbl_contains(g.special_buffers, filetype) then
    return ""
  end
  local width = #tostring(vim.fn.line('$'))
  if relnum == 0 then
    local current_line_width = #tostring(lnum)
    return mk_hl("Identifier", string.rep(" ", width - current_line_width) .. lnum)
  else
    local current_line_width = #tostring(relnum)
    return " " .. string.rep(" ", width - current_line_width) .. relnum
  end
  --return "%=%l"
  --return "%=%{v:relnum?v:relnum:v:lnum}"
end

_G.get_statuscol_diag = function(bufnum, lnum)
  local filetype = vim.bo.filetype
  if vim.tbl_contains(g.special_buffers, filetype) then
    return ""
  end
  local cur_sign_nm = get_name_from_group(bufnum, lnum, "*")

  if cur_sign_nm ~= nil and vim.startswith(cur_sign_nm, "DiagnosticSign") then
    return mk_hl(cur_sign_nm, diag_signs_icons[cur_sign_nm])
  else
    return " "
  end
end

_G.get_statuscol_octo = function(bufnum, lnum)
  local filetype = vim.bo.filetype
  if filetype == "octo" then
    if type(octo_buffers) == "table" then
      local buffer = octo_buffers[bufnum]
      if buffer then
        buffer:update_metadata()
        local hl = "OctoSignColumn"
        local metadatas = { buffer.titleMetadata, buffer.bodyMetadata }
        for _, comment_metadata in ipairs(buffer.commentsMetadata) do
          table.insert(metadatas, comment_metadata)
        end
        for _, metadata in ipairs(metadatas) do
          if metadata and metadata.startLine and metadata.endLine then
            if metadata.dirty then
              hl = "OctoDirty"
            else
              hl = "OctoSignColumn"
            end
            if lnum - 1 == metadata.startLine and lnum - 1 == metadata.endLine then
              return mk_hl(hl, "[ ")
            elseif lnum - 1 == metadata.startLine then
              return mk_hl(hl, "┌ ")
            elseif lnum - 1 == metadata.endLine then
              return mk_hl(hl, "└ ")
            elseif metadata.startLine < lnum - 1 and lnum - 1 < metadata.endLine then
              return mk_hl(hl, "│ ")
            end
          end
        end
      end
    end
    return " "
  end
  return ""
end

_G.get_statuscol_space = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains(g.special_buffers, filetype) then
    return ""
  else
    return " "
  end
end

_G.get_statuscol = function()
  local str_table = {}

  local parts = {
    ["gitsigns"] = "%{%v:lua.get_statuscol_gitsign(bufnr(), v:lnum)%}",
    ["diagnostics"] = "%{%v:lua.get_statuscol_diag(bufnr(), v:lnum)%}",
    ["num"] = "%{%v:lua.get_statuscol_num(v:lnum, v:relnum)%}",
    ["space"] = "%{%v:lua.get_statuscol_space(bufnr())%}",
    ["fold"] = "%{%v:lua.get_statuscol_fold()%}",
    ["octo"] = "%{%v:lua.get_statuscol_octo(bufnr(), v:lnum)%}",
  }

  local order = {
    "gitsigns",
    "diagnostics",
    "num",
    "space",
    "fold",
    "octo",
    --"space",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, parts[val])
  end

  return table.concat(str_table)
end
