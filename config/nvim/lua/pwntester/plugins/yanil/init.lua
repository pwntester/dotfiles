local yanil = require "yanil"
local canvas = require "yanil/canvas"
local git = require "yanil/git"
local yanil_utils = require "yanil/utils"
local decorators = require "pwntester.plugins.yanil.decorators"
local actions = require "pwntester.plugins.yanil.actions"

local function setup()
  yanil.setup {
    git = {
      icons = {
        Unstaged = "●",
        Staged = "●",
        Unmerged = "●",
        Renamed = "●",
        Untracked = "U",
        Modified = "M",
        Deleted = "●",
        Dirty = "●",
        Ignored = "●",
        Clean = "●",
        Unknown = "●",
      },
      highlights = {
        Unstaged = "ErrorMsg",
        Staged = "ErrorMsg",
        Unmerged = "ErrorMsg",
        Renamed = "ErrorMsg",
        Untracked = "ErrorMsg",
        Modified = "ErrorMsg",
        Deleted = "ErrorMsg",
        Dirty = "ErrorMsg",
        Ignored = "ErrorMsg",
        Clean = "ErrorMsg",
        Unknown = "ErrorMsg",
      },
    },
  }

  local tree = require("yanil/sections/tree"):new()

  tree:setup {
    draw_opts = {
      decorators = {
        decorators.indent_decorator,
        decorators.icon_decorator,
        decorators.space,
        decorators.default_decorator,
        decorators.readonly,
        decorators.executable,
        decorators.link_to,
        decorators.git_decorator,
      },
    },
    filters = {
      function(name)
        local patterns = {
          "^%.git$",
          "%.pyc",
          "^__pycache__$",
          "^%.idea$",
          "^%.iml$",
          "^%.DS_Store$",
          "%.o$",
          "%.d$",
        }
        for _, pat in ipairs(patterns) do
          if string.find(name, pat) then
            return true
          end
        end
      end,
    },
    keymaps = {
      ["]c"] = actions.git_next,
      ["[c"] = actions.git_prev,
      ["o"] = actions.expand_collapase_node,
      ["a"] = actions.create_node,
      ["d"] = actions.delete_node,
      ["r"] = actions.rename_node,
      ["m"] = actions.move_node,
      ["<tab>"] = actions.toggle_zoom,
      ["C"] = actions.copy_node,
      ["U"] = actions.noop,
      ["/"] = actions.find_file,
      ["R"] = actions.refresh_and_focus,
      ["F"] = actions.reveal_node,
      ["p"] = actions.go_to_parent,
    },
  }

  canvas.register_hooks {
    on_leave = function()
      vim.wo.cursorline = false
    end,
    on_enter = function()
      vim.api.nvim_command "doautocmd User YanilTreeEnter"
      vim.wo.cursorline = true
      vim.cmd "hi YanilGitUntracked gui=None guifg=#65737e"
      vim.cmd "hi YanilTreeDirectory guifg=#6699cc"
      vim.cmd "hi YanilTreeLinkTo guibg=none"
      vim.cmd "hi YanilTreeFile guibg=none"
      vim.cmd "setl nowrap"
      vim.cmd "silent vertical resize 45"

      local path = vim.g.yanil_selected
      local node = tree.root:find_node_by_path(path)
      if node then
        tree:go_to_node(node)
      end

      git.update(tree.cwd)
      yanil_utils.buf_set_keymap(canvas.bufnr, "n", "q", function()
        vim.fn.execute "quit"
      end)
    end,
    -- on_open = function(cwd) end,
    -- on_exit = function() end,
  }

  -- local header = require("pwntester.plugins.header"):new()

  canvas.setup {
    sections = {
      -- header,
      tree,
    },
    autocmds = {
      {
        event = "User",
        pattern = "YanilGitStatusChanged",
        cmd = function()
          git.refresh_tree(tree)
        end,
      },
      {
        event = "BufEnter",
        pattern = "*",
        cmd = function()
          actions.highlight_node(tree)
        end,
      },
    },
  }
end

return {
  setup = setup,
}
