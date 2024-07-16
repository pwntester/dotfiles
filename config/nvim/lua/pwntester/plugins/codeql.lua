local vim = vim
return {
  "pwntester/codeql.nvim",
  dev = true,
  cmd = "QL",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local entry_display = require "telescope.pickers.entry_display"
    local previewers = require "telescope.previewers"
    local utils = require "telescope.utils"
    local defaulter = utils.make_default_callable

    local displayer = entry_display.create {
      separator = " ",
      items = {
        { width = 8 }, -- commit
        { width = 8 }, -- lang
        { remaining = true }, -- nwo
      },
    }

    local make_display = function(entry)
      local path = entry.value
      local parts = vim.split(path, "/")
      local db = parts[#parts]
      local nwo = parts[#parts - 2] .. "/" .. parts[#parts - 1]
      local langAndCommit = vim.split(db:gsub("%.zip", ""), "-")
      local lang = langAndCommit[1]
      local commit = langAndCommit[2]
      return displayer {
        { commit, "TelescopeResultsComment" },
        { lang, "TelescopeResultsNumber" },
        { nwo, "TelescopeResultsString" },
      }
    end

    local entry_maker = function(entry)
      return {
        valid = entry,
        value = entry,
        ordinal = entry,
        display = make_display,
      }
    end

    local previewer = defaulter(function(opts)
      return previewers.new_buffer_previewer {
        title = opts.preview_title,
        get_buffer_by_name = function(_, entry)
          return entry.value
        end,
        define_preview = function(self, entry)
          local jsonPath = entry.value:gsub("%.zip", ".json")
          print("JSON", jsonPath)
          local bufnr = self.state.bufnr
          if self.state.bufname ~= jsonPath or vim.api.nvim_buf_line_count(bufnr) == 1 then
            local json = vim.fn.json_decode(vim.fn.readfile(jsonPath))
            if json then
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(vim.inspect(json), "\n"))
            end
            vim.api.nvim_buf_call(bufnr, function()
              pcall(vim.cmd, "set filetype=json")
            end)
          end
        end,
      }
    end).new

    local telescope_opts = {
      layout_strategy = "vertical",
      layout_config = {
        height = 50,
        width = 80,
      },
    }

    require("codeql").setup {
      find_databases_cmd = { "gh", "qldb", "list" },
      database_list_entry_maker = entry_maker,
      database_list_previewer = previewer,
      telescope_opts = telescope_opts,
      results = {
        max_paths = 15,
        max_path_depth = nil,
      },
      panel = {
        width = 80,
        group_by = "sink",
        show_filename = true,
        long_filename = false,
        context_lines = 3,
      },
      max_ram = 64000,
    }
    -- change summary background color
    vim.api.nvim_create_autocmd("WinEnter", {
      pattern = "*",
      callback = function()
        if not (vim.bo.filetype == "codeql_panel") then
          return
        end
        vim.wo.winhighlight = "Normal:NormalAlt"
      end,
    })
  end,
  -- stylua: ignore
  keys = {
    { "<leader>q", "", desc = "+codeql" },
    { "<leader>qp", function() require("codeql").smart_quick_evaluate() end, desc = "Eval Predicate" },
    { "<leader>qr", function() require("codeql").run_query() end, desc = "Run Query" },
    -- { "<leader>qg", function() require("codeql").run_query() end, desc = "Run Query" },    [[<Plug>(CodeQLGrepSource)]],
  }
}
