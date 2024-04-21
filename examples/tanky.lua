local box = require("luabox")
local write_as_human = require("tge.utils").write_as_human

local c = require("examples.tanky.console")
local tanky = require("examples.tanky.tank")

local console, clearAll = c.console, c.clearAll

local util = box.util
local event = box.event
local clear = box.clear
local cursor = box.cursor
local colors = box.colors

local f = string.format

local init = function()
	console:setMode(1)
	console:intoMouseMode()

	console:write(f("%s%s", cursor.hide, clear.all))

	local text = " TGE started \u{f0d3a} "

	console:write(cursor.goTo(2, 2))
	write_as_human(function(t)
		console:write(t)
	end, f("%s%s", colors.fg(colors.red), text), 200)

	console:write(cursor.goTo(2, 2))
	write_as_human(function(t)
		console:write(t)
	end, f("%s%s%s", colors.fg(colors.black), colors.bg(colors.red), text), 50)

	console:write(f("%s%s", colors.resetFg, colors.resetBg))

	console:write(cursor.goTo(2, 3))
	console:write(
		f(
			'%s(Press any key to spawn tank | move it with WASD | press "h" to show/hide coords)%s',
			colors.fg(colors.yellow),
			colors.resetFg
		)
	)
end

init()

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
			console:write("\x1b[2j\x1b[H") -- Clear the screen and returns the prompt to the top
			cursor.goTo(1, 1)
			console:write("\n")
			console:write(cursor.show)
			console:setMode(0)
			console:exitMouseMode()
			console:close()

			os.exit()
		elseif keyData.key == "char" then
			clearAll()
			tanky(keyData.char)
		end
	end
end

console.run()
