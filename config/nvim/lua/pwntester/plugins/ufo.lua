local M = {}

function M.setup()
  local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('  %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
          else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, {chunkText, hlGroup})
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                  suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
          end
          curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, {suffix, 'MoreMsg'})
      return newVirtText
  end

  local ft_map = {
    octo = '',
    dart = { "lsp" }
  }

  require("ufo").setup {
    open_fold_hl_timeout = 0,
    close_fold_kinds = {'imports', 'comment'},
    fold_virt_text_handler = handler,
    enable_get_fold_virt_text = true,
    provider_selector = function(_, filetype)
      return ft_map[filetype] or { "treesitter", "indent" }
    end,
    preview = {
        win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>'
        }
    },
  }
end

return M
