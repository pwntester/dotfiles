return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Right>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = "#939ab7",
          cterm = 244,
        },
        -- disable_inline_completion = true, -- disables inline completion for use with cmp
        -- disable_keymaps = true            -- disables built in keymaps for more manual control
      })
    end,
  },
}
