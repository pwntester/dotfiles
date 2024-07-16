return {
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require "alpha"
      require "alpha.term"

      local margin_fix = vim.fn.floor(vim.fn.winwidth(0) / 2 - 46 / 2)

      local button = function(sc, txt, keybind, padding)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        local text = padding and (" "):rep(padding) .. txt or txt

        local offset = padding and padding + 3 or 3

        local opts = {
          width = 46,
          position = "center",
          shortcut = sc,
          cursor = -1,
          align_shortcut = "right",
          hl_shortcut = "AlphaButtonShortcut",
          hl = {
            { "AlphaButtonIcon", 0, margin_fix + offset },
            {
              "AlphaButton",
              offset,
              #text,
            },
          },
        }

        if keybind then
          opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end

        return {
          type = "button",
          val = text,
          on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
          end,
          opts = opts,
        }
      end


      local config = {
        layout = {
          { type = "padding", val = vim.fn.max({ 4, vim.fn.floor(vim.fn.winheight(0) * 0.225) }) },
          {
            type = "terminal",
            command = vim.fn.expand "$HOME" .. "/dotfiles/thisisfine.sh",
            width = 46,
            height = 25,
            opts = {
              redraw = true,
              window_config = {},
            },
          },
          { type = "padding", val = 4 },
          {
            type = "text",
            val = function()
              local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
              local date = thingy:read "*a"
              return "· Today is " .. date .. " ·"
            end,
            opts = {
              position = "center",
              -- hl = "Folded",
            },
          },
          { type = "padding", val = 2 },
          {
            type = "group",
            val = {
              button("t", "📅 Journal", ":ObsidianToday<CR>"),
              button("n", "  New File", ":ene | startinsert<CR>"),
              button("u", "  Lazy", ":Lazy<CR>"),
              button("m", "󱌣  Mason", ":Mason<CR>"),
              button("p", "󰄉  Profile", ":Lazy profile<CR>"),
              button("c", "  Config", ":e /Users/pwntester/.config/nvim/init.lua<CR>"),
              button("q", "  Quit", ":qa<CR>"),
            },
            opts = {
              position = "center",
              spacing = 1,
            },
          },
          { type = "padding", val = 1 },
          {
            type = "text",
            val = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
            opts = {
              position = "center",
              -- hl = "Folded",
            },
          },
        },
        opts = {
          margin = margin_fix,
        },
      }

      alpha.setup(config)
    end,
  },
}
