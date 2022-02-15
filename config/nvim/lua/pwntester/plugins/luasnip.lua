local ls = require "luasnip"

-- snippet creator
-- s(<trigger>, <node>)
local s = ls.s

-- format node
-- fmt(<format str>,  {... nodes})
local fmt = require("luasnip.extras.fmt").fmt

-- insert node
-- It takes a position in the snippet and optionally a default value.
-- i(<position>, [default value])
local i = ls.insert_node
-- repeats a node
-- rep(<position>)
local rep = require("luasnip.extras").rep

local function define_snippets()
  ls.snippets = {
    all = {
      ls.parser.parse_snippet("expand", "testtesttest"),
    },
    ql = {
      ls.parser.parse_snippet(
        "tc",
        'import java\nimport DataFlow::PathGraph\n\nclass $1 extends TaintTracking::Configuration {\n\t$1() { this = "$1" }\n\toverride predicate isSource(DataFlow::Node source) {\n\t\t$2\n\t}\n\n\toverride predicate isSink(DataFlow::Node sink) {\n\t\t$3\n\t}\n}\n\nfrom $1 conf, DataFlow::PathNode source, DataFlow::PathNode sink\nwhere conf.hasFlowPath(source, sink)\nselect sink, source, sink, "$4"'
      ),
      s("test", fmt("test {} - {}", { i(1, "default"), rep(1) })),
    },
  }
end

local M = {}

function M.setup()
  ls.config.set_config {
    history = true, -- last snippet is kept around so we can jump back to it even from outside of the snippet
    updateevents = "TextChanged,TextChangedI", -- so dynamic snippets are updated when the text changes
    enable_autosnippets = true,
  }
  require("luasnip/loaders/from_vscode").lazy_load()
  define_snippets()
end

return M
