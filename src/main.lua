-- local term = require("plterm")
-- local sleep = require("./src/utils").sleep
-- local write_as_human = require("./src/utils").write_as_human
--
-- local text = "  Hello Terminal Game Engine \u{f256}  "
--
-- term.setrawmode()
--
-- term.hide()
-- term.clear()
--
-- local l, c = term.getscrlc()
-- local nl = math.floor(l / 2 + 4)
-- local nc = math.floor(c / 2 - #text / 2)
--
-- term.golc(nl, nc)
--
-- term.color(term.colors.cyan, term.colors.bgblack)
-- write_as_human(term.outf, text, 200)
--
-- sleep(50)
-- term.golc(nl, nc)
-- term.color(term.colors.black, term.colors.bgyellow, term.colors.bold)
-- write_as_human(term.outf, text, 50)
--
-- sleep(300)
-- term.golc(l, 0)
--
-- local nextc = term.input()
-- term.color(term.colors.reset)
-- io.write('Press "Q" (uppercase) to quit: ')
-- while true do
-- 	local i = nextc()
-- 	if i == string.byte("Q") then
-- 		break
-- 	end
-- 	io.write(string.char(i))
-- end
--
-- -- term.reset()
-- term.setsanemode()
-- print("")

local box = require("luabox")

local util = box.util
local event = box.event
local clear = box.clear
local cursor = box.cursor

local f = string.format

local stdin, stdout = util.getHandles()

local console = box.Console.new(stdin, stdout)

console:setMode(1)
console:intoMouseMode()

console:write(f("%s%s", cursor.hide, clear.all))

console.onData = function(data)
	local first
	local rest = {}

	for char in data:gmatch(".") do
		if not first then
			first = char
		else
			table.insert(rest, char)
		end
	end

	local iter = util.StringIterator(table.concat(rest))

	local keyData = event.parse(first, iter)

	if keyData.key == "ctrl" and keyData.char == "c" then
		console:write(cursor.show)
		console:setMode(0)
		console:exitMouseMode()
		console:close()

		os.exit()
	elseif keyData.key == "char" and keyData.char == "c" then
		console:write(clear.all)
	elseif keyData.event and keyData.event ~= "press" then
		local x, y = keyData.x, keyData.y

		console:write(f("%sX", cursor.goTo(x, y)))
	end
end

console.run()
