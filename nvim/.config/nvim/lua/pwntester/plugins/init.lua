--# selene: allow(mixed_table)
return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
  -- nio 
  { "nvim-neotest/nvim-nio", lazy = true }

  -- {
  --   "chaoren/vim-wordmotion",
  --   event = "VeryLazy",
  --   cond = vim.g.vscode,
  --   config = function()
  --     vim.g.wordmotion_prefix = "_"
  --   end,
  -- },
  -- {
  --   "pwntester/octo-notifications.nvim",
  --   dev = true,
  --   enabled = false,
  --   dependencies = "pwntester/octo.nvim",
  -- },
  -- { "sindrets/diffview.nvim" },
  -- {
  --   'mrjones2014/op.nvim',
  --   build = "make install",
  -- },
  -- {
  --   "pwntester/telescope-zip.nvim",
  --   dev = true,
  -- },
  -- {
  --   'pwntester/fortify.nvim',
  --   dev = true,
  --   config = function()
  --     require 'pwntester.plugins.fortify'.setup()
  --   end,
  -- },
  -- {
  --   "pwntester/crane.nvim",
  --   dev = true,
  --   enabled = false,
  --   config = function()
  --     require("crane").setup()
  --   end,
  -- },
}
