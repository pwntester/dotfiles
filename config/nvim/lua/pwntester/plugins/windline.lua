local windline = require "windline"
local cache_utils = require "windline.cache_utils"
local basic = require "windline.components.basic"
local lsp_comps = require "windline.components.lsp"
local lspconfig = require "pwntester.lsp"
local _, Job = pcall(require, "plenary.job")

local function relpath(P, start)
  local split, min, append = vim.split, math.min, table.insert
  local compare = function(v)
    return v
  end
  local startl, Pl = split(start, "/"), split(P, "/")
  local n = min(#startl, #Pl)
  local k = n + 1 -- default value if this loop doesn't bail out!
  for i = 1, n do
    if compare(startl[i]) ~= compare(Pl[i]) then
      k = i
      break
    end
  end
  local rell = {}
  for i = 1, #startl - k + 1 do
    rell[i] = ".."
  end
  if k <= #Pl then
    for i = k, #Pl do
      append(rell, Pl[i])
    end
  end
  return table.concat(rell, "/")
end

local config = {}

config.lsp = {
  name = "lsp",
  hl_colors = {
    red = { "red", "line_bg" },
    green = { "green", "line_bg" },
  },
  text = function()
    local clients = vim.lsp.get_active_clients()
    local bufnr = vim.api.nvim_get_current_buf()
    local client_id = lspconfig.clients[bufnr]
    if client_id then
      for _, client in ipairs(clients) do
        if client.id == client_id[1] then
          return { " " .. client.name .. " (" .. client.id .. ") ", "green" }
        end
      end
    end
    return {
      { " ", "red" },
    }
  end,
}

config.lsp_name = {
  name = "lsp_name",
  hl_colors = {
    red = { "red", "line_bg" },
    green = { "green", "line_bg" },
    orange = { "orange", "line_bg" },
  },
  text = function(bufnr)
    if lsp_comps.check_lsp(bufnr) then
      local error = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
      local warning = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
      local components = {
        { lsp_comps.lsp_name(), "green" },
      }
      if #error > 0 then
        table.insert(components, { "  ", "red" })
        table.insert(components, { lsp_comps.lsp_error(), "red" })
      end
      if #warning > 0 then
        table.insert(components, { "  ", "orange" })
        table.insert(components, { lsp_comps.lsp_warning(), "orange" })
      end
      table.insert(components, { " ", "orange" })
      return components
    end
    return {
      { " ", "red" },
    }
  end,
}

config.github_repo = {
  name = "github_repo",
  hl_colors = {
    blue = { "light_blue", "bg" },
  },
  text = cache_utils.cache_on_buffer("BufEnter", "wl_github_repo", function()
    local ok, outils = pcall(require, "octo.utils")
    if not ok then
      return { " " }
    end
    local name = outils.get_remote_name()
    if type(name) == "string" and name ~= "" then
      return {
        { "  " .. name, "blue" },
      }
    end
    return ""
  end),
}

config.git_branch = {
  name = "git_branch",
  hl_colors = {
    grey = { "grey", "bg" },
  },
  text = cache_utils.cache_on_buffer("BufEnter", "wl_git_branch", function()
    if not Job then
      return ""
    end
    local j = Job:new {
      command = "git",
      args = { "branch", "--show-current" },
      cwd = vim.fn.getcwd(),
    }

    local ok, result = pcall(function()
      return vim.trim(j:sync()[1])
    end)

    if ok then
      return {
        { "  " .. result, "grey" },
      }
    end
  end),
}

config.cwd = {
  name = "cwd",
  hl_colors = {
    yellow = { "yellow", "bg" },
  },
  text = function()
    return {
      { " " .. vim.fn.getcwd(), "yellow" },
    }
  end,
}

config.divider = { basic.divider, "" }

config.file = {
  name = "file",
  hl_colors = {
    yellow = { "yellow", "bg" },
  },
  text = cache_utils.cache_on_buffer("BufEnter", "wl_file_name", function()
    local bufname = vim.fn.bufname()
    if vim.startswith(bufname, "octo:") or vim.startswith(bufname, "codeql:") or vim.startswith(bufname, "docker:") then
      return {
        { " " .. bufname, "yellow" },
      }
    else
      return {
        { " " .. relpath(vim.fn.fnamemodify(bufname, ":p"), vim.fn.getcwd()), "yellow" },
      }
    end
  end),
}

config.position = {
  name = "position",
  hl_colors = {
    grey = { "grey", "bg" },
  },
  text = function()
    return {
      { " ", "grey" },
      { vim.fn.col "." .. ":" .. vim.fn.line ".", "grey" },
      { " ", "grey" },
      { tostring(math.floor(vim.fn.line "." / vim.fn.line "$" * 100)), "grey" },
      { "%%", "grey" },
    }
  end,
}

config.filetype = {
  name = "filetype",
  hl_colors = {
    blue = { "light_blue", "bg" },
  },
  text = function()
    return {
      { " ", "blue" },
      { basic.cache_file_type { icon = true, default = " " }, "blue" },
      { " ", "blue" },
    }
  end,
}

local default = {
  filetypes = { "default" },
  active = {
    config.github_repo,
    config.git_branch,
    config.cwd,
    config.divider,
    config.file,
    config.position,
    config.filetype,
    config.lsp_name,
  },
  inactive = {},
  floatline_show_float = false,
  floatline_show_both = false,
  always_active = false,
  show_last_status = false,
}

local special_buffers = {
  filetypes = g.special_buffers,
  active = {},
  inactive = {},
  floatline_show_float = false,
  floatline_show_both = false,
  always_active = false,
  show_last_status = false,
}

local floatline_active = {
  filetypes = { "floatline" },
  active = {
    {
      function(_, _, width)
        return string.rep("▁", math.floor(width - 1))
      end,
      { "vert_split", "line_bg" },
    },
    {
      "▁",
      {
        "vert_split",
        "line_bg",
      },
    },
  },
  inactive = {
    {
      function(_, _, width)
        -- TODO: seems like the width passed here is the width of the active window, not the inactive one
        return string.rep("▁", math.floor(width - 1))
      end,
      { "vert_split", "line_bg" },
    },
    {
      "▁",
      {
        "vert_split",
        "line_bg",
      },
    },
  },
}

windline.setup {
  colors_name = function(colors)
    local c = require("nautilus.theme").colors
    local palette = {
      bg = c.bg,
      line_bg = c.bg,
      grey = c.grey,
      yellow = c.yellow,
      light_blue = c.blue_dim,
      dark_blue = c.bg,
      green = c.green,
      orange = c.orange,
      red = c.red,
      vert_split = c.base01,
    }
    -- local c = require("nightfox.colors").load()
    -- local palette = {
    --   bg = c.bg,
    --   line_bg = c.bg_statusline,
    --   grey = c.fg_alt,
    --   yellow = c.yellow,
    --   light_blue = c.blue_br,
    --   dark_blue = c.blue,
    --   green = c.green,
    --   orange = c.orange,
    --   red = c.error,
    --   vert_split = c.bg_alt,
    -- }
    return vim.tbl_extend("force", colors, palette)
  end,
  statuslines = {
    default,
    special_buffers,
    floatline_active,
  },
}
require("wlfloatline").setup {
  interval = 300,
  -- ui = {
  --   active_char = "▁",
  --   active_color = "red",
  --   active_hl = "Error",
  -- },
  skip_filetypes = {
    "Yanil",
  },
  -- by default it skip all floating window but you can change it
  --floating_show_filetypes = {},
}
