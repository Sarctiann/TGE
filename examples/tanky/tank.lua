local box = require("luabox")
local console = require("examples.tanky.console").console
local bulletlib = require("examples.tanky.bullet")
local Bullet, bullets = bulletlib.Bullet, bulletlib.bullets

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

local x, y = console:getDimensions()
local tankCoords = { math.floor(x / 4 + 1), math.floor(y / 2 + 1) }
local tankDirection = "north"
SHOW_COORDS = false

local directionOffsets = {
	["north"] = { 0, -1 },
	["west"] = { -1, 0 },
	["south"] = { 0, 1 },
	["east"] = { 1, 0 }
}

local tankSpriteNorth = { { 0, 1, 0 }, { 1, 1, 1 }, { 1, 0, 1 } }
local tankSpriteEast = { { 1, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 } }
local tankSpriteWest = { { 0, 1, 1 }, { 1, 1, 0 }, { 0, 1, 1 } }
local tankSpriteSouth = { { 1, 0, 1 }, { 1, 1, 1 }, { 0, 1, 0 } }

local tankSprites = {
	["north"] = tankSpriteNorth,
	["west"] = tankSpriteWest,
	["south"] = tankSpriteSouth,
	["east"] = tankSpriteEast
}

local keyDirectionMapping = {
	["w"] = "north",
	["a"] = "west",
	["s"] = "south",
	["d"] = "east"
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

local function shotBullet(TDirection, TCoords)
	local Offset = directionOffsets[TDirection]
	local bulletCoords = {}
	bulletCoords[1] = TCoords[1] + (Offset[1] * 2)
	bulletCoords[2] = TCoords[2] + (Offset[2] * 2)
	table.insert(bullets, Bullet:new(bulletCoords, directionOffsets[TDirection]))
end

return function(keyChar)
	if keyDirectionMapping[keyChar] then
		local keyDirection = keyDirectionMapping[keyChar]
		if tankDirection == keyDirection then
			local wouldbecoords = {}
			local Offset = directionOffsets[keyDirection]
			wouldbecoords[1] = tankCoords[1] + Offset[1]
			wouldbecoords[2] = tankCoords[2] + Offset[2]
			local collisiontopleft = mapBorders[wouldbecoords[2] - 1][wouldbecoords[1] - 1]
			local collisionbottomright = mapBorders[wouldbecoords[2] + 1][wouldbecoords[1] + 1]

			local dotopleftcolide = collisiontopleft == 1
			local dobottomrightcolide = collisionbottomright == 1
			if (not dotopleftcolide and not dobottomrightcolide) then
				tankCoords[1] = wouldbecoords[1]
				tankCoords[2] = wouldbecoords[2]
			end
		else
			tankDirection = keyDirection
		end
	elseif keyChar == "k" then
		shotBullet(tankDirection, tankCoords)
	elseif keyChar == "h" then
		SHOW_COORDS = not SHOW_COORDS
	end

	pixelprintmatrix(mapBorders, 1, 1, border)
	pixelprintmatrix(tankSprites[tankDirection], tankCoords[1] - 1, tankCoords[2] - 1, pixel)

	for _, bullet in ipairs(bullets) do
		pixelprint(bullet.coords[1], bullet.coords[2], border)
		bullet:move()
	end
	if SHOW_COORDS then
		console:write(f(tankCoords[1]) .. ";" .. f(tankCoords[2]))
	end
end
