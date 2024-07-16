return {
  "echasnovski/mini.surround",
  recommended = true,
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      add = "sa", -- sa{motion/textobject}{delimiter}
      delete = "sd", -- sd{delimiter}
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "sh", -- Highlight surrounding
      replace = "sr", --- sr{old}{new}
      update_n_lines = "sn", -- Update `n_lines`
    },
  },
}
