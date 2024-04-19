local box = require("luabox")
local console = require("examples.tanky.console").console

local cursor = box.cursor

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
local border = "%s\u{2592}\u{2592}"

local tankSpriteNorth = { { 0, 1, 0 }, { 1, 1, 1 }, { 1, 0, 1 } }
local tankSpriteEast = { { 1, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 } }
local tankSpriteWest = { { 0, 1, 1 }, { 1, 1, 0 }, { 0, 1, 1 } }
local tankSpriteSouth = { { 1, 0, 1 }, { 1, 1, 1 }, { 0, 1, 0 } }
local currentTankSprite = tankSpriteNorth

local x, y = console:getDimensions()
local coords = { math.floor(x / 4 + 1), math.floor(y / 2 + 1) }
SHOW_COORDS = false

local directionArrays = {
	["w"] = { sprite = tankSpriteNorth, offset = { 0, -1 } },
	["a"] = { sprite = tankSpriteWest, offset = { -1, 0 } },
	["s"] = { sprite = tankSpriteSouth, offset = { 0, 1 } },
	["d"] = { sprite = tankSpriteEast, offset = { 1, 0 } }
}

local function createEmptyRectangle(m, n)
	local matrix = {}
	for i = 1, n do
		matrix[i] = {}
		for j = 1, m do
			if i == 1 or i == n or j == 1 or j == m then
				matrix[i][j] = 1
			else
				matrix[i][j] = 0
			end
		end
	end
	return matrix
end

local mapBorders = createEmptyRectangle(x / 2, y)

return function(keyChar)
	if directionArrays[keyChar] then
		local direction = directionArrays[keyChar]
		if currentTankSprite == direction.sprite then
			local wouldbecoords = {}
			wouldbecoords[1] = coords[1] + direction.offset[1]
			wouldbecoords[2] = coords[2] + direction.offset[2]
			local collisiontopleft = mapBorders[wouldbecoords[2] - 1][wouldbecoords[1] - 1]
			local collisionbottomright = mapBorders[wouldbecoords[2] + 1][wouldbecoords[1] + 1]

			local dotopleftcolide = collisiontopleft == 1
			local dobottomrightcolide = collisionbottomright == 1
			if (not dotopleftcolide and not dobottomrightcolide) then
				coords[1] = wouldbecoords[1]
				coords[2] = wouldbecoords[2]
			end
		else
			currentTankSprite = direction.sprite
		end
	elseif keyChar == "h" then
		SHOW_COORDS = not SHOW_COORDS
	end

	pixelprintmatrix(mapBorders, 1, 1, border)
	pixelprintmatrix(currentTankSprite, coords[1] - 1, coords[2] - 1, pixel)
	if SHOW_COORDS then
		console:write(f(coords[1]) .. ";" .. f(coords[2]))
	end
end
