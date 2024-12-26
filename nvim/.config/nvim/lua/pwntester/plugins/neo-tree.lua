local vim = vim
return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
    -- because `cwd` is not set up properly.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require "neo-tree"
          end
        end
      end,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
    "mrbjarksen/neo-tree-diagnostics.nvim",
  },
  keys = {
    {
      "ge",
      function()
        require("neo-tree.command").execute {
          action = "show",
          toggle = true,
          source = "filesystem",
          dir = require("pwntester.root").get(),
        }
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "gE",
      function()
        require("neo-tree.command").execute { action = "show", toggle = true, source = "filesystem", dir = vim.uv.cwd() }
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute { action = "show", toggle = true, source = "git_status" }
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute { action = "show", toggle = true, source = "buffers" }
      end,
      desc = "Buffer Explorer",
    },
  },

  config = function()
    local highlights = require "neo-tree.ui.highlights"
    local scan = require "plenary.scandir"
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local tactions = require "telescope.actions"
    local taction_state = require "telescope.actions.state"
    local conf = require("telescope.config").values
    local manager = require "neo-tree.sources.manager"
    local cc = require "neo-tree.sources.common.commands"
    local fs = require "neo-tree.sources.filesystem"
    local utils = require "neo-tree.utils"
    -- local icons = require "pwntester.icons"

    local function is_dir(name)
      local stats = vim.loop.fs_stat(name)
      return stats and stats.type == "directory"
    end

    vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

    local diff_files = function(state)
      local node = state.tree:get_node()
      local log = require "neo-tree.log"
      state.clipboard = state.clipboard or {}
      if diff_Node and diff_Node ~= tostring(node.id) then
        local current_Diff = node.id
        require("neo-tree.utils").open_file(state, diff_Node, open)
        vim.cmd("vert diffs " .. current_Diff)
        log.info("Diffing " .. diff_Name .. " against " .. node.name)
        diff_Node = nil
        current_Diff = nil
        state.clipboard = {}
        require("neo-tree.ui.renderer").redraw(state)
      else
        local existing = state.clipboard[node.id]
        if existing and existing.action == "diff" then
          state.clipboard[node.id] = nil
          diff_Node = nil
          require("neo-tree.ui.renderer").redraw(state)
        else
          state.clipboard[node.id] = { action = "diff", node = node }
          diff_Name = state.clipboard[node.id].node.name
          diff_Node = tostring(state.clipboard[node.id].node.id)
          log.info("Diff source file " .. diff_Name)
          require("neo-tree.ui.renderer").redraw(state)
        end
      end
    end

    require("neo-tree").setup {
      close_if_last_window = true,
      sources = {
        "filesystem",
        "git_status",
        "buffers",
      },
      source_selector = {
        winbar = true,
        statusline = false,
        separator_active = " ",
      },
      enable_git_status = true,
      git_status_async = true,
      enable_diagnostics = false,
      open_files_do_not_replace_types = { "terminal", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      -- sort_function = function (a,b)
      --       if a.type == b.type then
      --           return a.path > b.path
      --       else
      --           return a.type > b.type
      --       end
      --   end , -- this sorts files and directories descendantly
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "", -- this can only be used in the git_status source
            renamed = "", -- this can only be used in the git_status source
            -- Status type
            untracked = "◂",
            ignored = "",
            unstaged = "∙",
            staged = "∙",
            conflict = "",
          },
        },
      },
      commands = {
        diff_files = function(state)
          local node = state.tree:get_node()
          local log = require "neo-tree.log"
          state.clipboard = state.clipboard or {}
          if diff_Node and diff_Node ~= tostring(node.id) then
            local current_Diff = node.id
            require("neo-tree.utils").open_file(state, diff_Node, open)
            vim.cmd("vert diffs " .. current_Diff)
            log.info("Diffing " .. diff_Name .. " against " .. node.name)
            diff_Node = nil
            current_Diff = nil
            state.clipboard = {}
            require("neo-tree.ui.renderer").redraw(state)
          else
            local existing = state.clipboard[node.id]
            if existing and existing.action == "diff" then
              state.clipboard[node.id] = nil
              diff_Node = nil
              require("neo-tree.ui.renderer").redraw(state)
            else
              state.clipboard[node.id] = { action = "diff", node = node }
              diff_Name = state.clipboard[node.id].node.name
              diff_Node = tostring(state.clipboard[node.id].node.id)
              log.info("Diff source file " .. diff_Name)
              require("neo-tree.ui.renderer").redraw(state)
            end
          end
        end,
      },
      window = {
        mappings = {
          ["D"] = "diff_files",
          -- ["D"] = function(state)
          --   local diffNode = state.tree:get_node()
          --   local diffPath = diffNode:get_id()
          --   vim.cmd [[Neotree close]]
          --   vim.cmd("vert diffs " .. diffPath)
          --   vim.cmd [[Neotree toggle]]
          -- end,
          -- ["D"] = function(state)
          -- 	state.commands["copy_node_to_diff"](state, node)
          -- 	require("neo-tree.ui.renderer").redraw(state)
          -- end,
          ["<CR>"] = function(state)
            local node = state.tree:get_node()
            if vim.endswith(node.path, ".sarif") then
              require("codeql.loader").load_sarif_results(node.path)
            else
              cc.open_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
            end
          end,
          ["q"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node.ext == "zip" then
              local ok, codeql = pcall(require, "codeql")
              if ok then
                codeql.set_database(node.path)
              end
            end
          end,
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["o"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              local parent_node = state.tree:get_node(node:get_parent_id())
              require("neo-tree.sources.filesystem").toggle_directory(state, parent_node)
            end
          end,
          ["m"] = function(state)
            local node = state.tree:get_node()
            local tree = state.tree
            local cwd = manager.get_cwd(state)
            local dirs = scan.scan_dir(cwd, { only_dirs = true })
            local relative_dirs = {}
            for _, dir in ipairs(dirs) do
              local relative_dir = dir:gsub(cwd, "")
              table.insert(relative_dirs, relative_dir)
            end

            local opts = require("telescope.themes").get_dropdown {}
            pickers
              .new(opts, {
                prompt_title = "Target directory",
                finder = finders.new_table {
                  results = relative_dirs,
                },
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr)
                  tactions.select_default:replace(function()
                    tactions.close(prompt_bufnr)
                    local selection = taction_state.get_selected_entry()

                    local source_file = node.path
                    local target_dir = cwd .. selection[1]
                    target_dir = target_dir .. "/"
                    target_dir = target_dir:gsub("//", "/")
                    local target_file = target_dir .. node.name

                    if not is_dir(target_dir) then
                      vim.notify "Target is not a directory"
                      return
                    end

                    vim.loop.fs_rename(
                      source_file,
                      target_file,
                      vim.schedule(function(err)
                        if err then
                          print "Could not move the file"
                          return
                        else
                          print("Moved " .. node.name .. " successfully")
                          tree:render()
                        end
                      end)
                    )
                  end)
                  return true
                end,
              })
              :find()
          end,
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["<esc>"] = "revert_preview",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          -- the current file is changed while the tree is open.
        },
        hijack_netrw_behavior = "open_current",
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".git",
            ".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        components = {
          icon = function(config, node)
            local icon = config.default or " "
            local padding = config.padding or " "
            local highlight = config.highlight or highlights.FILE_ICON
            if node.type == "directory" then
              highlight = highlights.DIRECTORY_ICON
              if node:is_expanded() then
                icon = config.folder_open or "-"
              else
                icon = config.folder_closed or "+"
              end
            elseif node.type == "file" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")
              if success then
                local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                icon = devicon or icon
                highlight = hl or highlight
              end
            end
            if node:get_depth() == 1 then
              icon = ""
            end
            return {
              text = icon .. padding,
              highlight = highlight,
            }
          end,
          name = function(config, node)
            local text = node.name
            local highlight = config.highlight or highlights.FILE_NAME

            if node.type == "directory" then
              highlight = highlights.DIRECTORY_NAME
              text = text .. "/"
            end

            if node:get_depth() == 1 then
              text = string.upper(vim.fn.fnamemodify(node.path, ":t"))
              highlight = highlights.ROOT_NAME
            end
            return {
              text = text,
              highlight = highlight,
            }
          end,
          git_status = function(config, node, state)
            local git_status_lookup = state.git_status_lookup
            if not git_status_lookup then
              return {}
            end
            local git_status = git_status_lookup[node.path]
            if not git_status then
              return {}
            end

            local highlight = highlights.FILE_NAME
            if git_status:match "?$" then
              highlight = highlights.GIT_UNTRACKED
            elseif git_status:match "U" or git_status == "AA" then
              highlight = highlights.GIT_CONFLICT
            elseif git_status:match "M" then
              highlight = highlights.GIT_MODIFIED
            elseif git_status:match "[ACRT]" then
              highlight = highlights.GIT_ADDED
            end

            return {
              text = " ●",
              highlight = config.highlight or highlight,
            }
          end,
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd "wincmd ="
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd "wincmd ="
            end
          end,
        },
      },
    }
  end,
}
