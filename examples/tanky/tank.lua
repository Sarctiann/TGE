local console = require("examples.tanky.console").console
local box = require("luabox")
local cursor = box.cursor
local bulletlib = require("examples.tanky.bullet")
local Bullet, bullets = bulletlib.Bullet, bulletlib.bullets
local data = require("examples.tanky.data")
local directionOffsets, tankSprites, keyDirectionMapping, textures  = data.directionOffsets, data.tankSprites,
	data.keyDirectionMapping, data.textures
local pixel, border = textures.pixel, textures.border
local createEmptyRectangle = require("examples.tanky.mathutils").createEmptyRectangle

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

SHOW_COORDS = false
local x, y = console:getDimensions()
local mapBorders = createEmptyRectangle(x / 2, y)

local tankCoords = { math.floor(x / 4 + 1), math.floor(y / 2 + 1) }
local tankDirection = "north"

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
				tankCoords = wouldbecoords
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
