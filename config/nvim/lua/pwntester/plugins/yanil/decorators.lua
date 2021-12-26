local devicons = require "nvim-web-devicons"
local git = require "yanil/git"
local decorators = require "yanil/decorators"

local function indent_decorator(node)
  -- -- if not node.parent  then
  -- --   return '  '
  -- -- end
  local text = string.rep("  ", node.depth)
  return text
end

local function icon_decorator(node)
  local text = ""
  local hl = ""
  -- ﯤ
  if not node.parent then
    text = ""
    hl = "YanilTreeDirectory"
  elseif node:is_dir() then
    if node:is_link() then
      text = ""
      hl = "YanilTreeLink"
    else
      text = node.is_open and "" or ""
      hl = node:is_link() and "YanilTreeLink" or "YanilTreeDirectory"
    end
  else
    text, hl = devicons.get_icon(node.name, node.extension)
    text = text or ""
  end
  return text, hl
end

-- function M.default_decorator(node)
--   local text = node.name
--   local hl_group = "YanilTreeFile"
--   if node:is_dir() then
--     if not node.parent then
--       text = vim.fn.fnamemodify(node.name:sub(1, -2), ":.:t")
--       hl_group = "YanilTreeRoot"
--     else
--       hl_group = node:is_link() and "YanilTreeLink" or "YanilTreeDirectory"
--     end
--   else
--     if node:is_link() then
--       hl_group = node:is_broken() and "YanilTreeLinkBroken" or "YanilTreeLink"
--     elseif node.is_exec then
--       hl_group = "YanilTreeFileExecutable"
--     end
--   end
--   return text, hl_group
-- end

local function default_decorator(node)
  if vim.g.yanil_selected and vim.g.yanil_selected == node.abs_path then
    return node.name, "CursorLineNr"
  end
  return decorators.default(node)
end

local function git_decorator(node)
  if not node.parent then
    return
  end

  local git_icon, git_hl = git.get_icon_and_hl(node.abs_path)
  git_icon = git_icon or " "
  -- local indent = M.indent_decorator(node)
  -- return indent, git_hl
  return " " .. git_icon, git_hl
end

return {
  indent_decorator = indent_decorator,
  icon_decorator = icon_decorator,
  default_decorator = default_decorator,
  git_decorator = git_decorator,
  space = decorators.space,
  readonly = decorators.readonly,
  executable = decorators.executable,
  link_to = decorators.link_to,
}
