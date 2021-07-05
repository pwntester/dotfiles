local lspconfig = require'lsp_config'

return function()
  -- local function is_ft(b, ft)
  --   return vim.bo[b].filetype == ft
  -- end

  -- local symbols = { error = " ", warning = " ", info = " " }

  -- local function diagnostics_indicator(_, _, diagnostics)
  --   local result = {}
  --   for name, count in pairs(diagnostics) do
  --     if symbols[name] and count > 0 then
  --       table.insert(result, symbols[name] .. count)
  --     end
  --   end
  --   result = table.concat(result, " ")
  --   return #result > 0 and " " .. result or ""
  -- end

  -- local function custom_filter(buf, buf_nums)
  --   local logs = vim.tbl_filter(function(b)
  --     return is_ft(b, "log")
  --   end, buf_nums)
  --   if vim.tbl_isempty(logs) then
  --     return true
  --   end
  --   local tab_num = vim.fn.tabpagenr()
  --   local last_tab = vim.fn.tabpagenr "$"
  --   local is_log = is_ft(buf, "log")
  --   if last_tab == 1 then
  --     return true
  --   end
  --   -- only show log buffers in secondary tabs
  --   return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
  -- end

  local function get_lsp_client(msg)
    msg = msg or 'No Active LSP'
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local client_id = lspconfig.clients[bufnr]
    if client_id then
      for _, client in ipairs(clients) do
        if client.id == client_id[1] then return client.name.." ("..client.id..")" end
      end
    end
    return msg
  end

  require("bufferline").setup {
    highlights = {
      tab_selected = {
        guifg = '#1f283b',
        guibg = '#ffcc66'
      },
      buffer_selected = {
        guifg = '#1f283b',
        guibg = '#ffcc66'
      },
      modified = {
        guifg = '#f04c75',
        guibg = '#1f283b',
      },
      modified_visible = {
        guifg = '#f04c75',
        guibg = '#1f283b',
      },
      modified_selected = {
        guifg = '#f04c75',
        guibg = '#ffcc66',
      },
      separator = {
        guibg = '#1f283b',
      },
      separator_visible = {
        guibg = '#1f283b',
      },
      separator_selected = {
        guibg = '#ffcc66',
      },
      close_button = {
        guifg = '#abb2bf',
        guibg = '#1f283b',
      },
      close_button_visible = {
        guifg = '#abb2bf',
        guibg = '#1f283b',
      },
      close_button_selected = {
        guifg = '#1f283b',
        guibg = '#ffcc66',
      },
      indicator_selected = {
        guifg = '#0000ff',
      },
    },
    options = {
      mappings = false,
      -- sort_by = function(a, b)
      --   local astat = vim.loop.fs_stat(a.path)
      --   local bstat = vim.loop.fs_stat(b.path)
      --   local mod_a = astat and astat.mtime.sec or 0
      --   local mod_b = bstat and bstat.mtime.sec or 0
      --   return mod_a > mod_b
      -- end,
      show_close_icon = false,
      ---based on https://github.com/kovidgoyal/kitty/issues/957
      separator_style = os.getenv "KITTY_WINDOW_ID" and "slant" or "padded_slant",
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
          if client == 'No Active LSP' then
            result[1] = {text = " ", guifg = "#f04c75"}
          else
            result[1] = {text = " "..client.." ", guifg = "#98c379"}
          end

          if error ~= 0 then
            result[2] = {text = " "..error.." ", guifg = "#f04c75"}
          end

          if warning ~= 0 then
            result[3] = {text = " "..warning.." ", guifg = "#ffae57"}
          end
          return result
        end
      }
    },
  }
end
