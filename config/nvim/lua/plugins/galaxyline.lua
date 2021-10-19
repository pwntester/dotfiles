return function()
  local theme = require'nautilus'.theme("grey")
  local gl = require'galaxyline'
  --local vcs = require'galaxyline.provider_vcs'
  local fileinfo = require'galaxyline.provider_fileinfo'
  local condition = require'galaxyline.condition'
  local buffer = require'galaxyline.provider_buffer'
  local gls = gl.section
  local _, Job = pcall(require, 'plenary.job')

  local function relpath(P, start)
    local split,min,append = vim.split, math.min, table.insert
    local compare = function(v) return v end
    local startl, Pl = split(start,'/'), split(P,'/')
    local n = min(#startl,#Pl)
    local k = n+1 -- default value if this loop doesn't bail out!
    for i = 1,n do
      if compare(startl[i]) ~= compare(Pl[i]) then
        k = i
        break
      end
    end
    local rell = {}
    for i = 1, #startl-k+1 do rell[i] = '..' end
    if k <= #Pl then
        for i = k,#Pl do append(rell,Pl[i]) end
    end
    return table.concat(rell,'/')
  end

  local repo_cache = {}

  local colors = {
    bg = tostring(theme.CursorColumn.bg),
    line_bg = tostring(theme.Normal.bg),
    grey = tostring(theme.Normal.fg),
    yellow = tostring(theme.Identifier.fg),
    light_blue = tostring(theme.NonText.fg),
    green = tostring(theme.String.fg),
    orange = tostring(theme.Constant.fg),
    red = tostring(theme.ErrorMsg.fg),
  }

  -- special filetypes that show a short statusline
  gl.short_line_list = vim.tbl_filter(
    function(item) return item ~= "octo" end,
    vim.fn.deepcopy(g.special_buffers)
  )

  gls.left[1] = {
    Space = {
      provider = function()
        return " "
      end,
      highlight = {colors.bg, colors.yellow}
    }
  }

  gls.left[2] = {
    mode = {
      provider = function()
        local alias = {
          n = "NORMAL",
          i = "INSERT",
          c = "COMMAND",
          V = "VISUAL",
          [""] = "VISUAL",
          v = "VISUAL",
          R = "REPLACE"
        }
        return alias[vim.fn.mode()] .. " "
      end,
      separator = " ",
      highlight = {colors.bg, colors.yellow},
      separator_highlight = {colors.fg, colors.bg}
    }
  }

  gls.left[3] = {
    GitHubRepo = {
      provider = function()
        if repo_cache[vim.fn.getcwd()] then
          return repo_cache[vim.fn.getcwd()]
        else
          local repo_name = require"octo.utils".get_remote_name()
          repo_cache[vim.fn.getcwd()] = repo_name
          return repo_name
        end
      end,
      icon = " ",
      condition = function()
        if vim.tbl_contains(gl.short_line_list, vim.bo.ft) then return end
        local name = require"octo.utils".get_remote_name()
        return type(name) == "string" and name ~=""
      end,
      highlight = {colors.light_blue, colors.bg},
      separator = " ",
      separator_highlight = {colors.fg, colors.bg}
    }
  }

  gls.left[4] = {
    GitBranch = {
      --provider = "GitBranch",
      --condition = vcs.check_git_workspace,
      provider = function()
        if not Job then return end
        local j = Job:new({
          command = "git",
          args = {"branch", "--show-current"},
          cwd = vim.fn.getcwd(),
        })

        local ok, result = pcall(function()
          return vim.trim(j:sync()[1])
        end)

        if ok then
          return result
        end
      end,
      icon = " ",
      highlight = {colors.grey, colors.bg},
      separator = " ",
      separator_highlight = {colors.fg, colors.bg}
    }
  }

  gls.left[5] = {
    cwd = {
      provider = function()
        return vim.fn.getcwd()
      end,
      highlight = {colors.yellow, colors.bg},
      separator_highlight = {colors.yellow, colors.bg}
    }
  }

  gls.right[1] = {
    FileName = {
      provider = function()
        local bufname = vim.fn.bufname()
        if vim.startswith(bufname, "octo:") or
           vim.startswith(bufname, "codeql:") or
           vim.startswith(bufname, "docker:") then
          return bufname
        else
          return relpath(vim.fn.fnamemodify(bufname, ':p'), vim.fn.getcwd())
        end
      end,
      condition = condition.buffer_not_empty,
      highlight = {colors.yellow, colors.bg},
      separator = " ",
      separator_highlight = {colors.fg, colors.bg}
    }
  }


  gls.right[2] = {
    Column = {
      icon = "‣",
      provider = function()
        return vim.fn.col(".")
      end,
      highlight = {colors.grey, colors.bg},
      separator = " ",
      separator_highlight = {colors.fg, colors.bg}
    }
  }

  gls.right[3] = {
    PerCent = {
      icon = "Ξ",
      provider = function()
        return fileinfo.current_line_percent()
      end,
      highlight = {colors.grey, colors.bg},
      separator = " ",
      separator_highlight = {colors.fg, colors.bg}
    }
  }

  gls.right[6] = {
    FileIcon = {
      provider = function()
        return fileinfo.get_file_icon()
      end,
      highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg},
    }
  }

  gls.right[4] = {
    Filetype = {
      provider = function()
        return string.lower(buffer.get_buffer_filetype())
      end,
      highlight = {colors.grey, colors.bg},
    }
  }

  gls.right[5] = {
    Space2 = {
      provider = function()
        return " "
      end,
      highlight = {colors.fg, colors.bg}
    }
  }
--   gls.right[8] = {
--     LSPClient= {
--       icon = " ",
--       provider = function()
--         return get_lsp_client()
--       end,
--       condition = function()
--         return  "" ~= get_lsp_client("")
--       end,
--       highlight = {colors.green, colors.bg},
--       separator = " ",
--       separator_highlight = {colors.fg, colors.bg}
--     }
--   }
--   gls.right[9] = {
--     DiagnosticError = {
--       provider = "DiagnosticError",
--       icon = " ",
--       highlight = {colors.red, colors.bg},
--       separator = " ",
--       separator_highlight = {colors.fg, colors.bg}
--     }
--   }
-- 
--   gls.right[10] = {
--     DiagnosticWarn = {
--       provider = "DiagnosticWarn",
--       icon = " ",
--       highlight = {colors.orange, colors.bg},
--     }
--   }

  -- local checkwidth = function()
  --     local squeeze_width = vim.fn.winwidth(0) / 2
  --     if squeeze_width > 40 then
  --         return true
  --     end
  --     return false
  -- end
  --
  -- gls.left[6] = {
  --     DiffAdd = {
  --         provider = "DiffAdd",
  --         condition = checkwidth,
  --         icon = "   ",
  --         highlight = {colors.greenYel, colors.line_bg}
  --     }
  -- }
  --
  -- gls.left[7] = {
  --     DiffModified = {
  --         provider = "DiffModified",
  --         condition = checkwidth,
  --         icon = " ",
  --         highlight = {colors.orange, colors.line_bg}
  --     }
  -- }
  --
  -- gls.left[8] = {
  --     DiffRemove = {
  --         provider = "DiffRemove",
  --         condition = checkwidth,
  --         icon = " ",
  --         highlight = {colors.red, colors.line_bg}
  --     }
  -- }
  --
end

