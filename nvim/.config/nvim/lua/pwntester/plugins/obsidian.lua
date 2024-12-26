return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cmd = "ObsidianToday",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<C-t>", "<CMD>ObsidianToday<CR>", desc = "Daily Note" },
    { "<C-n>", "<CMD>ObsidianNew<CR>", desc = "New Note" },
  },
  config = function()
    local vim = vim
    local obsidian = require "obsidian"
    local client = obsidian.setup {
      workspaces = {
        {
          name = "CopperMind",
          path = "~/obsidian",
        },
      },
      notes_subdir = "Inbox",
      new_notes_location = "notes_subdir",
      log_level = vim.log.levels.INFO,
      daily_notes = {
        folder = "Journal",
        date_format = "%Y-%m-%d",
        template = "journal.md",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {},
      templates = {
        subdir = "System/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          ["date:YYYY-MM-DD"] = function()
            return os.date "%Y-%m-%d" -- , os.time() - 86400)
          end,
        },
      },
      preferred_link_style = "wiki",
      prepend_note_id = false,
      prepend_note_path = false,
      use_path_only = false,
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,
      image_name_func = function()
        return string.format("%s-", os.time())
      end,
      disable_frontmatter = false,
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
      follow_url_func = function(url)
        vim.fn.jobstart { "open", url } -- Mac OS
      end,
      use_advanced_uri = true,
      open_app_foreground = false,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      search_max_lines = 1000,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = false, -- set to false to disable all additional syntax features
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

    vim.cmd [[command! ObsidianNewMeetingNote :call v:lua.vim.g.append_to_journal("## Meetings & Conversations", v:lua.vim.g.new_note("Meeting Notes", v:true, "", v:true, "meeting"))]]
    vim.cmd [[command! ObsidianNewOneOnOneNote :call v:lua.vim.g.append_to_journal("## Meetings & Conversations", v:lua.vim.g.new_note("Meeting Notes", v:true, "1-on-1 with ", v:true, "1-on-1"))]]
  end,
}
