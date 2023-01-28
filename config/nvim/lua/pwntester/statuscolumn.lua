local icons = require("pwntester.icons")

--local gitsigns_bar = '▌'
local gitsigns_bar = '▎'

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

_G.get_statuscol_gitsign = function(bufnr, lnum)
  local cur_sign_nm = get_name_from_group(bufnr, lnum, "gitsigns_vimfn_signs_")

  if cur_sign_nm ~= nil then
    return mk_hl(gitsigns_hl_pool[cur_sign_nm], gitsigns_bar)
  else
    return " "
  end
end

_G.get_statuscol_num = function(bufnum, lnum)
  return lnum
end

_G.get_statuscol_diag = function(bufnum, lnum)
  local cur_sign_nm = get_name_from_group(bufnum, lnum, "*")

  if cur_sign_nm ~= nil and vim.startswith(cur_sign_nm, "DiagnosticSign") then
    return mk_hl(cur_sign_nm, diag_signs_icons[cur_sign_nm])
  else
    return " "
  end
end

_G.get_statuscol_octo = function(bufnum, lnum)
  if vim.api.nvim_buf_get_option(bufnum, "filetype") == "octo" then
    if type(octo_buffers) == "table" then
      local buffer = octo_buffers[bufnum]
      if buffer then
        buffer:update_metadata()
        local hl = "OctoSignColumn"
        local metadatas = {buffer.titleMetadata, buffer.bodyMetadata}
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
  end
  return "  "
end

_G.get_statuscol = function()
  local str_table = {}

  local parts = {
    ["diagnostics"] = "%{%v:lua.get_statuscol_diag(bufnr(), v:lnum)%}",
    ["fold"] = "%C",
    ["gitsigns"] = "%{%v:lua.get_statuscol_gitsign(bufnr(), v:lnum)%}",
    --["num"] = "%{v:relnum?v:relnum:v:lnum}",
    --["num"] = "%=%r│",
    --["num"] = "%{%v:lua.get_statuscol_num(bufnr(), v:lnum)%}",
    ["num"] = "%r",
    ["sep"] = "%=",
    ["signcol"] = "%s",
    ["space"] = " ",
    ["octo"] = "%{%v:lua.get_statuscol_octo(bufnr(), v:lnum)%}",
  }

  local order = {
    "gitsigns",
    "diagnostics",
    --"signcol",
    --"space",
    "sep",
    "num",
    "space",
    "octo",
    --"fold",
  }

  for _, val in ipairs(order) do
    table.insert(str_table, parts[val])
  end

  return table.concat(str_table)
end
