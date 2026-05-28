local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup()
npairs.add_rule(Rule("<", ">"))

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
