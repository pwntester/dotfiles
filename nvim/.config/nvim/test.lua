local vim = vim
local ts = vim.treesitter

-- vim.treesitter.inspect_tree()

function trim(s)
  return s:match "^%s*(.-)%s*$"
end

local bufnr = vim.fn.bufnr("/tmp/test.md", true)
local p = ts.get_parser(bufnr, "markdown")
local root = p:parse()[1]:root()
local query = ts.query.parse("markdown", "((atx_heading) @header)")
for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
  --local name = query.captures[id]
  local text = ts.get_node_text(node, bufnr)
  --local start_row, start_col, end_row, end_col = node:range()
  if trim(text) == "## Logbook" then
    --if trim(text) == "## Meetings & Conversations" then
    -- print(text)
    -- print(name, start_row, start_col, end_row, end_col)

    local parent = node:parent()
    if parent:type() == "section" then
      local list_children = {}
      for child in parent:iter_children() do
        if child:type() == "list" then
          table.insert(list_children, child)
        end
      end
      if #list_children == 0 then
        print "No list children"
      elseif #list_children == 1 then
        local list = list_children[1]
        for item in list:iter_children() do
          print(ts.get_node_text(item, bufnr))
          local start_row, start_col, end_row, end_col = item:range()
          print(start_row, start_col, end_row, end_col)
        end
      else
        print "Multiple list children"
      end
    end
  end
end
