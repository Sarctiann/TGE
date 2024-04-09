local term = require("plterm")

local text = "Hello Terminal Game Engine\n"

term.setrawmode()

term.hide()
term.clear()

local l, c = term.getscrlc()
local nl = math.floor(l / 2 + 4)
local nc = math.floor(c / 2 - #text / 2)

term.golc(nl, nc)
term.out(text)
term.golc(l, c)
term.show()

term.setsanemode()
print("")
