local function fuzzy_files()
  local config = {
    selection_strategy = "reset";
    shorten_path = true;
    layout_strategy = "flex";
    prompt_position = "top";
    sorting_strategy = "ascending";
    preview_cutoff = 200;
    winblend = 3;
    border = false;
    borderchars = { '', '', '', '', '', '', '', ''};
    width = 50;
  }
  require"telescope.builtin".find_files(config)
end

local function fuzzy_mru()
  local config = {
    selection_strategy = "reset";
    shorten_path = true;
    layout_strategy = "flex";
    prompt_position = "top";
    sorting_strategy = "ascending";
    preview_cutoff = 200;
    winblend = 3;
    border = false;
    borderchars = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙'};
    width = 50;
  }
  require'telescope.builtin'.oldfiles(config)
end

return {
  fuzzy_files = fuzzy_files;
  fuzzy_mru = fuzzy_mru;
}
