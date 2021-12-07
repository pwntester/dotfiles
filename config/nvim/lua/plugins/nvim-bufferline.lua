local lspconfig = require "pwntester.lsp"

return function()
  local function get_lsp_client(msg)
    msg = msg or "No Active LSP"
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local client_id = lspconfig.clients[bufnr]
    if client_id then
      for _, client in ipairs(clients) do
        if client.id == client_id[1] then
          return client.name .. " (" .. client.id .. ")"
        end
      end
    end
    return msg
  end

  local colors = {
    accent = "#ffcc66",
    background = "#1f283b",
    dark_background = "#181e2e",
    foreground = "#80b2d6",
    red = "#f04c75",
    green = "#98c379",
    orange = "#ffae57",
  }
  require("bufferline").setup {
    highlights = {
      background = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      tab_selected = {
        guifg = colors.background,
        guibg = colors.accent,
      },
      duplicate = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      duplicate_visible = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      duplicate_selected = {
        guifg = colors.background,
        guibg = colors.accent,
      },
      buffer_visible = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      buffer_selected = {
        guifg = colors.background,
        guibg = colors.accent,
      },
      modified = {
        guifg = colors.red,
        guibg = colors.background,
      },
      modified_visible = {
        guifg = colors.red,
        guibg = colors.background,
      },
      modified_selected = {
        guifg = colors.red,
        guibg = colors.accent,
      },
      separator = {
        guifg = colors.dark_background,
        guibg = colors.background,
      },
      separator_visible = {
        guifg = colors.dark_background,
        guibg = colors.background,
      },
      separator_selected = {
        guifg = colors.dark_background,
        guibg = colors.accent,
      },
      close_button = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      close_button_visible = {
        guifg = colors.foreground,
        guibg = colors.background,
      },
      close_button_selected = {
        guifg = colors.background,
        guibg = colors.accent,
      },
      indicator_selected = {
        guifg = "#0000ff",
      },
    },
    options = {
      -- sort_by = function(a, b)
      --   local astat = vim.loop.fs_stat(a.path)
      --   local bstat = vim.loop.fs_stat(b.path)
      --   local mod_a = astat and astat.mtime.sec or 0
      --   local mod_b = bstat and bstat.mtime.sec or 0
      --   return mod_a > mod_b
      -- end,
      show_close_icon = false,
      ---based on https://github.com/kovidgoyal/kitty/issues/957
      --separator_style = os.getenv "KITTY_WINDOW_ID" and "slant" or "padded_slant",
      separator_style = "slant",
      -- diagnostics = "nvim_lsp",
      -- diagnostics_indicator = diagnostics_indicator,
      -- custom_filter = custom_filter,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "codeqlpanel",
          text = "CodeQL results",
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
          padding = 1,
        },
      },
      name_formatter = function(buf)
        if vim.startswith(buf.path, "octo:") and octo_buffers and octo_buffers[buf.bufnr] then
          local title = octo_buffers[buf.bufnr].node.title
          return string.sub(title, 1, 10)
        end
      end,
      custom_areas = {
        right = function()
          local result = {}
          local error = vim.lsp.diagnostic.get_count(0, [[Error]])
          local warning = vim.lsp.diagnostic.get_count(0, [[Warning]])

          local client = get_lsp_client()
          if client == "No Active LSP" then
            result[1] = { text = "  ", guifg = colors.red }
            result[2] = { text = "", guifg = colors.green }
          else
            result[1] = { text = "  ", guifg = colors.accent }
            result[2] = { text = client .. " ", guifg = colors.green }
          end

          if error ~= 0 then
            result[3] = { text = " " .. error .. " ", guifg = colors.red }
          end

          if warning ~= 0 then
            result[4] = { text = " " .. warning .. " ", guifg = colors.orange }
          end
          return result
        end,
      },
    },
  }
end
