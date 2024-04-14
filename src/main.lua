local term = require("plterm")
local sleep = require("./src/utils").sleep
local write_as_human = require("./src/utils").write_as_human

local text = "  Hello Terminal Game Engine \u{f256}  "

term.setrawmode()

term.hide()
term.clear()

local l, c = term.getscrlc()
local nl = math.floor(l / 2 + 4)
local nc = math.floor(c / 2 - #text / 2)

term.golc(nl, nc)

term.color(term.colors.cyan, term.colors.bgblack)
write_as_human(term.outf, text, 200)

sleep(50)
term.golc(nl, nc)
term.color(term.colors.black, term.colors.bgyellow, term.colors.bold)
write_as_human(term.outf, text, 50)

sleep(300)
term.golc(l, c)

-- term.reset()
term.setsanemode()
print("")
