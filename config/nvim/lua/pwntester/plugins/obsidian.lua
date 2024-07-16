return {
  "epwalsh/obsidian.nvim",
  version = "*",
  -- event = {
  --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre "
  --     .. vim.fn.expand "~"
  --     .. "/obsidian/**.md",
  -- },
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local vim = vim
    local obsidian = require "obsidian"
    local client = obsidian.setup {
      workspaces = {
        {
          name = "second brain",
          path = "~/obsidian",
        },
      },
      notes_subdir = "Inbox",
      daily_notes = {
        folder = "Journal",
        date_format = "%Y-%m-%d",
        template = "journal.md",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      templates = {
        subdir = "System/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        tags = "",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      new_notes_location = "notes_subdir",
      preferred_link_style = "wiki",
      -- Whether to add the output of the node_id_func to new notes in autocompletion.
      -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
      prepend_note_id = false,
      prepend_note_path = false,
      use_path_only = false,
      disable_frontmatter = false,
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes "obsidian done"
        ["<leader>od"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Create a new newsletter issue
        ["<leader>onn"] = {
          action = function()
            return require("obsidian").commands.new_note "Newsletter-Issue"
          end,
          opts = { buffer = true },
        },
        ["<leader>ont"] = {
          action = function()
            return require("obsidian").util.insert_template "Newsletter-Issue"
          end,
          opts = { buffer = true },
        },
      },
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,

      image_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end,

      note_frontmatter_func = function(note)
        local out = {
          tags = note.tags,
          created = os.date "%Y-%m-%d",
          modified = os.date "%Y-%m-%d",
          links = {},
        }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- By default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { "open", url } -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      use_advanced_uri = true,

      open_app_foreground = false,

      finder = "telescope.nvim",

      finder_mappings = {
        -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
        -- Currently only telescope supports this.
        new = "<C-x>",
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "Systems/Attachments", -- This is the default
        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and a plenary `Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            -- Use relative path if the image is saved in the vault dir.
            link_path = vault_relative_path
          else
            -- Otherwise use the absolute path.
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format("![%s](%s)", display_name, link_path)
        end,
      },

      -- Optional, set the YAML parser to use. The valid options are:
      --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
      --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
      --    but much slower and needs to be installed separately.
      -- In general you should be using the native parser unless you run into a bug with it, in which
      -- case you can temporarily switch to the "yq" parser until the bug is fixed.
      yaml_parser = "native",
    }

    vim.g.new_note = function(subdir, ask_title, title_prefix, prefix_date, template)
      -- get file name, otherwise use ISO timestamp
      local title, fname = "", ""
      if ask_title == true then
        title = vim.fn.input("Name: ", "")
        if title == "" then
          return
        end
        title = title_prefix .. title
      else
        title = title_prefix .. "Untitled Note"
      end

      if prefix_date == true then
        title = tostring(os.date "%Y-%m-%d") .. " - " .. title
      end
      fname = title:gsub("[^A-Za-z0-9-_ ]", "")

      -- create query to check if note already exists
      local query = fname .. ".md"
      if subdir ~= nil then
        query = subdir .. "/" .. fname .. ".md"
      end

      -- try to find the note, and create if not found
      local note = client:resolve_note(query)
      if note == nil then
        print(vim.inspect(client.dir.filename))
        note = client:new_note(title, fname, client.dir.filename .. "/" .. subdir)
      end

      -- create a split and open note
      vim.cmd "vsplit"
      vim.cmd("edit " .. tostring(note.path))
      if template ~= nil then
        vim.cmd("ObsidianTemplate " .. tostring(template) .. ".md")
      end

      return title
    end

    vim.g.append_to_note = function(path, section, text)
      print("append_to_note", path, section, text)
    end
    vim.g.append_to_journal = function(section, text)
      local offset_days = 0
      local note = client:daily(offset_days)
      vim.g.append_to_note(note.path.filename, section, text)
    end

    vim.cmd [[command! ObsidianMeetingNote :call v:lua.vim.g.append_to_journal("## Meetings & Conversations", v:lua.vim.g.new_note("Meeting Notes", v:true, "", v:true, "meeting"))]]
    vim.cmd [[command! ObsidianOneOnOneNote :call v:lua.vim.g.append_to_journal("## Meetings & Conversations", v:lua.vim.g.new_note("Meeting Notes", v:true, "1-on-1 with ", v:true, "1-on-1"))]]
  end,
}
