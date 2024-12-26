local vim = vim
local g = require "pwntester.globals"
local define = vim.api.nvim_create_autocmd

-- define({ "User" }, {
--   pattern = "LazyVimStarted",
--   callback = function()
--     local stats = require("lazy").stats()
--     local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--     print("⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms")
--   end,
-- })
-- define({ "TermEnter", "WinEnter", "BufEnter" }, {
--   pattern = { "*" },
--   callback = function()
--     local ft = vim.bo.filetype
--     -- if ft == "dashboardpreview" then
--     -- elseif vim.bo.buftype == "terminal" then
--     if vim.tbl_contains({ "alpha", "dashboard", "octo" }, ft) then
--       vim.wo.foldcolumn = "0"
--       vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
--     elseif
--       vim.tbl_contains({ "alpha", "dashboard", "octo", "frecency", "TelescopePrompt", "TelescopeResults" }, ft)
--     then
--       vim.wo.foldcolumn = "0"
--       --vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
--     elseif vim.tbl_contains(g.special_buffers, ft) then -- or vim.bo.buftype == "terminal" then
--       vim.wo.foldcolumn = "0"
--       vim.api.nvim_win_set_option(0, "winhighlight", "Normal:NormalAlt")
--     else
--       vim.wo.foldcolumn = "1"
--       vim.api.nvim_win_set_option(0, "winhighlight", "Normal:Normal")
--     end
--     vim.api.nvim_command [[au FileType * set fo-=c fo-=r fo-=o]]
--   end,
-- })
define({ "FocusGained", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    -- check if file was changed externally
    vim.cmd [[checktime]]
  end,
})
define({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank { on_visual = false, higroup = "IncSearch", timeout = 500 }
  end,
})
define({ "BufEnter" }, {
  pattern = { "*.txt" },
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "help" then
      vim.cmd [[wincmd L]]
    end
  end,
})
define({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.bo.ft == "markdown" then
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    else
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "»",
        },
      })
    end
  end,
})
define({
  "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",

  -- include this if you have set `show_modified` to `true`
  "BufModifiedSet",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
