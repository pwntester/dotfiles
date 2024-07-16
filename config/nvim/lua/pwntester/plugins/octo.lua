return {
  "pwntester/octo.nvim",
  dev = true,
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.treesitter.language.register("markdown", "octo")
  end,
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = true,
    suppress_missing_scope = {
      projects_v2 = true,
    },
    default_merge_method = "squash",
    picker = "telescope",
    use_local_fs = true,
  },
}
