local box = require("luabox")
local write_as_human = require("src/utils").write_as_human

local text = "  Hello Terminal Game Engine \u{f256}  "

local util = box.util
local event = box.event
local clear = box.clear
local cursor = box.cursor
local colors = box.colors

local f = string.format

local stdin, stdout = util.getHandles()

local console = box.Console.new(stdin, stdout)

console:setMode(1)
console:intoMouseMode()

console:write(f("%s%s", cursor.hide, clear.all))

console:write(cursor.goTo(3, 2))
write_as_human(function(t)
	console:write(t)
end, f("%s%s", colors.fg(colors.blue), text), 200)

console:write(cursor.goTo(3, 2))
write_as_human(function(t)
	console:write(t)
end, f("%s%s%s", colors.fg(colors.black), colors.bg(colors.yellow), text), 50)

console:write(f("%s%s", colors.resetFg, colors.resetBg))

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

	if keyData ~= nil then
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
end

console.run()
