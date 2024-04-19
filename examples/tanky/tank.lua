local box = require("luabox")
local console = require("examples.tanky.console").console

local cursor = box.cursor
local colors = box.colors

local f = string.format

local pixelprint = function(x, y, element)
	console:write(f(element, cursor.goTo((x * 2) - 1, y)))
end

local printmatrix = function(matrix, topleftx, toplefty, element)
	for i = 1, #matrix do
		for j = 1, #matrix[i] do
			if matrix[i][j] == 1 then
				console:write(f(element, cursor.goTo(topleftx + j - 1, toplefty + i - 1)))
			end
		end
	end
end

local pixelprintmatrix = function(matrix, topleftx, toplefty, element)
	for i = 1, #matrix do
		for j = 1, #matrix[i] do
			if matrix[i][j] == 1 then
				pixelprint(topleftx + j - 1, toplefty + i - 1, element)
			end
		end
	end
end

local pixel = "%s\u{2588}\u{2588}"

local tankArrayNorth = { { 0, 1, 0 }, { 1, 1, 1 }, { 1, 0, 1 } }
local tankArrayEast = { { 1, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 } }
local tankArrayWest = { { 0, 1, 1 }, { 1, 1, 0 }, { 0, 1, 1 } }
local tankArraySouth = { { 1, 0, 1 }, { 1, 1, 1 }, { 0, 1, 0 } }
local currentTankArray = tankArrayNorth

local x, y = console:getDimensions()
local coords = { math.floor(x / 4 + 1), math.floor(y / 2 + 1) }
SHOW_COORDS = false

return function(keyChar)
	if keyChar == "w" then
		if currentTankArray == tankArrayNorth then
			-- coords[2] = 2 < coords[2] ? coords[2] - 1 : coords[2]
			coords[2] = 2 < coords[2] and coords[2] - 1 or coords[2]
		else
			currentTankArray = tankArrayNorth
		end
	elseif keyChar == "a" then
		if currentTankArray == tankArrayWest then
			coords[1] = 2 < coords[1] and coords[1] - 1 or coords[1]
		else
			currentTankArray = tankArrayWest
		end
	elseif keyChar == "s" then
		if currentTankArray == tankArraySouth then
			coords[2] = y - 1 > coords[2] and coords[2] + 1 or coords[2]
		else
			currentTankArray = tankArraySouth
		end
	elseif keyChar == "d" then
		if currentTankArray == tankArrayEast then
			coords[1] = x / 2 - 1 > coords[1] and coords[1] + 1 or coords[1]
		else
			currentTankArray = tankArrayEast
		end
	elseif keyChar == "h" then
		SHOW_COORDS = not SHOW_COORDS
	end
	console:write(cursor.goTo(2, 2))
	console:write(
		f(
			'%s(Move it with WASD | press "h" to show/hide coords | [Ctrl]+[C] to quit)%s',
			colors.fg(colors.yellow),
			colors.resetFg
		)
	)
	pixelprintmatrix(currentTankArray, coords[1] - 1, coords[2] - 1, pixel)
	if SHOW_COORDS then
		console:write(f(coords[1]) .. ";" .. f(coords[2]))
	end
end
