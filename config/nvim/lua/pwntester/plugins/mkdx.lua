local function setup()
  vim.g['mkdx#settings'] = {
    highlight = {
      enable = 1;
      frontmatter = {
        yaml = 1;
        toml = 0;
        json = 0;
      };
    };
    tokens = {
      fence = '`',
      enter = {"-"},
      list = '-'
    };
    gf_on_steroids = 0;
    restore_visual = 1;
    map = {
      prefix = "<leader>",
      enable = 1
    },
    enter = {
      enable = 1; -- enter: adds new item
      shift = 0;  -- shift + enter: adds new item indented
    };
    checkbox = {
      toggles = {' ', 'x'}
    },
    link = {
      external = {
        enable = 0
      }
    }
  }
  --- <leader>t: prepends checkbox
  --- <leader>ll: toggle list tokens
  --- <leader>lt: toggle list tokens + checkboxes
  --- <leader> =: checks a checkbox ->
  --- <leader> -: checks a checkbox <-
  --- <leader>]: Promote header
  --- <leader>[: Demote header
  --- <leader>': Toggle quotes (`>`)
  --- <leader>ln: wrap word or visual selection in `[word](|)`
  --- <leader>/:  italic
  --- <leader>b: bold
  --- <leader>`: inline code
  --- <leader>s: strikethrough
  --- <leader>,: cvs -> table
  --- <leader>I: open TOC in QF
end

return {
  setup = setup
}
