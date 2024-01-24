local ls = require "luasnip"

local M = {}

function M.setup()

  require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
  ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { { "⬤", "Statement" } }
        }
      }
    }
  }
  --require("luasnip/loaders/from_vscode").lazy_load()
end

return M
