local ls = require("luasnip")

local s = ls.s -- snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node


local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {}

local myFirstSnippet = s("myFirstSnippet", {
  t "My first snippet (",
  i(1, "foo"),
  t ")! ",
  i(2, "bar"),
  t { "", "second line" }, -- t can take a table as its argument and empty strings are trated as newlines
})
table.insert(snippets, myFirstSnippet)

-- fmt is a helper function that formats a string with text nodes and given arguments
local mySecondSnippet = s("mySecondSnippet", fmt([[
local {} = function ({})
  {}
end
]], {
  i(1, "myVar"),
  c(2, { t("foo"), t("bar") }),
  i(3, "-- TODO"),
}))
table.insert(snippets, mySecondSnippet)
-- autosnippets are triggered automatically when the trigger is typed
local myFirstAutosnippet = s("auto-", { t("This was auto triggered") })
table.insert(autosnippets, myFirstAutosnippet)

-- we can use lua regexps in the trigger
local mySecondAutosnippet = s({ trig = "auto%d", regTrig = true }, { t("This was auto triggered") })
table.insert(autosnippets, mySecondAutosnippet)

-- function nodes
local myThirdSnippet = s({ trig = "digit(%d%d)", regTrig = true }, {
  f(function(_, snip)
    return snip.captures[1]
  end)
})
table.insert(autosnippets, myThirdSnippet)

-- we can also base the function node return value on other nodes
local myFourthSnippet = s({ trig = "args(%d%d)", regTrig = true }, {
  i(1, "myVar"),
  f(function(args)
    return args[1][1]:upper()
  end, 1)
})
table.insert(autosnippets, myFourthSnippet)

local repSnippet = s("repSnippet", {
  i(1, "foo"),
  rep(1)
})
table.insert(snippets, repSnippet)

return snippets, autosnippets
