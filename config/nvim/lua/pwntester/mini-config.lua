local M = {}

-- Mini.ai indent text object
-- For "a", it will include the non-whitespace line surrounding the indent block.
-- "a" is line-wise, "i" is character-wise.
function M.ai_indent(ai_type)
  local spaces = (" "):rep(vim.o.tabstop)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local indents = {}

  for l, line in ipairs(lines) do
    if not line:find "^%s*$" then
      indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match "^%s*", text = line }
    end
  end

  local ret = {}

  for i = 1, #indents do
    if i == 1 or indents[i - 1].indent < indents[i].indent then
      local from, to = i, i
      for j = i + 1, #indents do
        if indents[j].indent < indents[i].indent then
          break
        end
        to = j
      end
      from = ai_type == "a" and from > 1 and from - 1 or from
      to = ai_type == "a" and to < #indents and to + 1 or to
      ret[#ret + 1] = {
        indent = indents[i].indent,
        from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
        to = { line = indents[to].line, col = #indents[to].text },
      }
    end
  end

  return ret
end

-- taken from MiniExtra.gen_ai_spec.buffer
function M.ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line "$"
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

M.ai = {
  n_lines = 500,
  custom_textobjects = {
    o = require("mini.ai").gen_spec.treesitter { -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    },
    f = require("mini.ai").gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
    c = require("mini.ai").gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    d = { "%f[%d]%d+" }, -- digits
    e = { -- Word with case
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    i = M.ai_indent, -- indent
    g = M.ai_buffer, -- buffer
    u = require("mini.ai").gen_spec.function_call(), -- u for "Usage"
    U = require("mini.ai").gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
  },
}

M.bufremove = {
  silent = true,
}

M.comment = {}

M.icons = {
  -- lsp = {
  --   ["function"] = { glyph = "󰡱", hl = "MiniIconsAzure" },
  -- },
}

M.pairs = {
  mappings = {
    ["<"] = { action = "closeopen", pair = "<>", neigh_pattern = "[^\\].", register = { cr = false } },
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
  },
}

M.surround = {
  mappings = {
    add = "sa", -- sa{motion/textobject}{delimiter}
    delete = "sd", -- sd{delimiter}
    find = "sf", -- Find surrounding (to the right)
    find_left = "sF", -- Find surrounding (to the left)
    highlight = "sh", -- Highlight surrounding
    replace = "sr", --- sr{old}{new}
    update_n_lines = "sn", -- Update `n_lines`
  },
}

-- M.files = {
--   windows = { preview = false, width_focus = 25, width_preview = 40, height_focus = 20, max_number = math.huge },
--   use_as_default_explorer = true,
-- }
--
-- local hipatterns = require "mini.hipatterns"
-- M.hipatterns = {
--   highlighters = {
--     fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
--     hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
--     todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
--     note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
--     hex_color = hipatterns.gen_highlighter.hex_color(),
--   },
-- }
--
-- M.pick = {
--   options = {
--     use_cache = true,
--   },
-- }
--
-- M.move = {
--   mappings = {
--     left = "<S-h>",
--     right = "<S-l>",
--     down = "<S-j>",
--     up = "<S-k>",
--     line_left = "<S-h>",
--     line_right = "<S-l>",
--     line_down = "<S-j>",
--     line_up = "<S-k>",
--   },
-- }
--
-- M.indentscope = {
--   symbol = "┋",
-- }
--
-- M.completion = {
--   window = {
--     info = { border = "rounded" },
--     signature = { border = "rounded" },
--   },
-- }
--
-- M.visits = {
--   store = {
--     path = vim.fn.stdpath "cache" .. "mini-visits-index",
--   },
-- }
--
-- local miniclue = require "mini.clue"
-- M.clue = {
--   triggers = {
--     { mode = "n", keys = "<Leader>" },
--     { mode = "x", keys = "<Leader>" },
--
--     { mode = "i", keys = "<C-x>" },
--
--     { mode = "n", keys = "g" },
--     { mode = "x", keys = "g" },
--
--     { mode = "n", keys = "'" },
--     { mode = "n", keys = "`" },
--     { mode = "x", keys = "'" },
--     { mode = "x", keys = "`" },
--
--     { mode = "n", keys = '"' },
--     { mode = "x", keys = '"' },
--     { mode = "i", keys = "<C-r>" },
--     { mode = "c", keys = "<C-r>" },
--
--     { mode = "n", keys = "<C-w>" },
--
--     { mode = "n", keys = "z" },
--     { mode = "x", keys = "z" },
--   },
--
--   clues = {
--     miniclue.gen_clues.builtin_completion(),
--     miniclue.gen_clues.g(),
--     miniclue.gen_clues.marks(),
--     miniclue.gen_clues.registers(),
--     miniclue.gen_clues.windows(),
--     miniclue.gen_clues.z(),
--   },
-- }
--
-- M.notify = {}
--
-- M.git = {}
--
-- M.diff = {
--   view = {
--     style = "sign",
--     signs = { add = "│", change = "󰗩 ", delete = "󰛌" },
--   },
-- }
--
-- local starter = require "mini.starter"
--
-- M.starter = {
--   evaluate_single = false,
--   header = table.concat({
--     " 𝙔𝘼𝙔!ーーーーー",
--     " ☆  *    .      ☆",
--     "     . ∧＿∧    ∩    * ☆",
--     "*  ☆ ( ・∀・)/ .",
--     "  .  ⊂         ノ* ☆",
--     "  ☆ * (つ ノ  .☆",
--     "       (ノ",
--   }, "\n"),
--   footer = os.date(),
--   items = {
--     {
--       name = "Bookmarked files 󰃀",
--       action = "lua MiniExtra.pickers.visit_paths { filter = 'todo' }",
--       section = "Actions ",
--     },
--     { name = "Lazy update 󰒲", action = ":Lazy update", section = "Actions " },
--     { name = "Open blank file 󰯉", action = ":enew", section = "Actions " },
--     { name = "Find files ", action = "lua MiniPick.builtin.files()", section = "Actions " },
--     { name = "Recent files ", action = "lua MiniExtra.pickers.oldfiles()", section = "Actions " },
--     { name = "Quit 󱍢", action = ":q!", section = "Actions " },
--   },
--   content_hooks = {
--     starter.gen_hook.aligning("center", "center"),
--   },
-- }

return M
