local M = {}

function M.setup()
  require("noice").setup {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      view_search = "cmdline_popup_search",
      opts = { buf_options = { filetype = "vim" } },
      icons = {
        ["/"] = { icon = " ", hl_group = "NoiceCmdlineIconSearch" },
        ["?"] = { icon = " ", hl_group = "NoiceCmdlineIconSearch" },
        [":"] = { icon = " ", hl_group = "NoiceCmdlineIcon", firstc = false },
      },
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    messages = {
      enabled = true,
    },
    notify = {
      enabled = true,
    },
    lsp_progress = {
      enabled = true,
      format_done = "lsp_progress_done",
      throttle = 1000 / 30, -- frequency to update lsp progress message
      format = {
        -- {
        --   "{progress} ",
        --   key = "progress.percentage",
        --   contents = {
        --     { "{data.progress.message} " },
        --   },
        -- },
        { "{data.progress.message} ", hl_group = "NoiceLspProgressTitle" },
        { "({data.progress.percentage}%) " },
        { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
        { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
        { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
      },
    },
    routes = {
      {
        view = "mini",
        filter = {
          any = {
            { event = "notify" },
            {
              event = "msg_show",
              kind = {
                "",
                "echo",
                "echomsg",
                "echoerr",
                "lua_error",
                "rpc_error",
                "return_prompt",
                "quickfix",
                "wmsg",
              },
            },
          },
        },
        -- Hide `written` messages
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
    views = {
      cmdline_popup = {
        -- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
        position = {
          --row = "30%",
          row = 15,
          col = "50%",
        },
        size = {
          width = 148,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 18,
          col = "50%",
        },
        size = {
          width = 150,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
  }
end
return M
