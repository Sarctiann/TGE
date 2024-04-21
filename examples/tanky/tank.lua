local console = require("examples.tanky.utils.console").console
local bulletlib = require("examples.tanky.bullet")
local Bullet, bullets = bulletlib.Bullet, bulletlib.bullets
local Tank = require("examples.tanky.thetank").Tank
local data = require("examples.tanky.data")
local directionOffsets, tankSprites, keyDirectionMapping, textures  = data.directionOffsets, data.tankSprites,
	data.keyDirectionMapping, data.textures
local pixel, border = textures.pixel, textures.border
local mathutils = require("examples.tanky.utils.math")
local createEmptyRectangle, sumOffsetToCoords = mathutils.createEmptyRectangle, mathutils.sumOffsetToCoords
local renderutils = require("examples.tanky.utils.render")
local pixelprint, pixelprintmatrix = renderutils.pixelprint, renderutils.pixelprintmatrix

local f = string.format

SHOW_COORDS = false
local x, y = console:getDimensions()
local mapBorders = createEmptyRectangle(x / 2, y)

local playerTank = Tank:new({ math.floor(x / 4 + 1), math.floor(y / 2 + 1) }, "north")

local function shotBullet(TDirection, TCoords)
	local Offset = directionOffsets[TDirection]
	local bulletCoords = {}
	bulletCoords[1] = TCoords[1] + (Offset[1] * 2)
	bulletCoords[2] = TCoords[2] + (Offset[2] * 2)
	table.insert(bullets, Bullet:new(bulletCoords, directionOffsets[TDirection]))
end

local function doTankCollideWithBorders(wouldbecoords)
	local collisiontopleft = mapBorders[wouldbecoords[2] - 1][wouldbecoords[1] - 1]
	local collisionbottomright = mapBorders[wouldbecoords[2] + 1][wouldbecoords[1] + 1]

	local dotopleftcolide = collisiontopleft == 1
	local dobottomrightcolide = collisionbottomright == 1
    return (dotopleftcolide or dobottomrightcolide)
end

local function render()
	pixelprintmatrix(mapBorders, {1, 1}, border)
	pixelprintmatrix(tankSprites[playerTank.direction], sumOffsetToCoords(playerTank.coords, {- 1, - 1}), pixel)
	if SHOW_COORDS then
		console:write(f(playerTank.coords[1]) .. ";" .. f(playerTank.coords[2]))
	end

	for _, bullet in ipairs(bullets) do
		pixelprint(bullet.coords, border)
		bullet:move()
	end
end

return function(keyChar)
	if keyDirectionMapping[keyChar] then
		local keyDirection = keyDirectionMapping[keyChar]
		if playerTank.direction == keyDirection then
			local wouldbecoords = {}
			local Offset = directionOffsets[keyDirection]
			wouldbecoords = sumOffsetToCoords(playerTank.coords, Offset)
			local isCollision = doTankCollideWithBorders(wouldbecoords)
			if (not isCollision) then
				playerTank.coords = wouldbecoords
			end
		else
			playerTank.direction = keyDirection
		end
	elseif keyChar == "k" then
		shotBullet(playerTank.direction, playerTank.coords)
	elseif keyChar == "h" then
		SHOW_COORDS = not SHOW_COORDS
	end

	render()
end
