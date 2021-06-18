local function setup()
  require "format".setup {
    ["*"] = {
      {cmd = {"sed -i 's/[ \t]*$//'"}} -- remove trailing whitespace
    },
    vim = {
      {
        cmd = {"npx luafmt -w replace -i 2"},
        start_pattern = "^lua << EOF$",
        end_pattern = "^EOF$"
      }
    },
    vimwiki = {
      {
        cmd = {"npx prettier -w --parser babel"},
        start_pattern = "^{{{javascript$",
        end_pattern = "^}}}$"
      }
    },
    lua = {
      {
        cmd = {
          function(file)
            return string.format("npx luafmt -w replace -i 2 %s", file)
          end
        }
      }
    },
    go = {
      {
        cmd = {"gofmt -w", "goimports -w"},
        tempfile_postfix = ".tmp"
      }
    },
    javascript = {
      {cmd = {"npx prettier -w", "./node_modules/.bin/eslint --fix"}}
    },
    markdown = {
      {cmd = {"npx prettier -w"}},
      {
        cmd = {"black"},
        start_pattern = "^```python$",
        end_pattern = "^```$",
        target = "current"
      }
    }
  }
end

return {
  setup = setup
}
