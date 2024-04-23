local console = require("examples.tanky.utils.console").console
local bulletlib = require("examples.tanky.bullet")
local Bullet, bullets = bulletlib.Bullet, bulletlib.bullets
local Tank = require("examples.tanky.thetank").Tank
local data = require("examples.tanky.data")
local directionOffsets, tankSprites, keyDirectionMapping, textures  = data.directionOffsets, data.tankSprites,
	data.keyDirectionMapping, data.textures
local pixel, border, bulletTexture = textures.pixel, textures.border, textures.bullet
local mathutils = require("examples.tanky.utils.math")
local createEmptyRectangle, sumOffsetToCoords, spaceIncludesPoint = mathutils.createEmptyRectangle, mathutils.sumOffsetToCoords, mathutils.spaceIncludesPoint
local renderutils = require("examples.tanky.utils.render")
local pixelprint, pixelprintmatrix = renderutils.pixelprint, renderutils.pixelprintmatrix

table.insert(bullets, Bullet:new({ 14, 18 }, { 1, 0 }))

local f = string.format

SHOW_COORDS = false
local consoleX, consoleY = console:getDimensions()
local mapX, mapY = consoleX / 2, consoleY
local mapBorders = createEmptyRectangle(mapX, mapY)

local function isOutOfBounds(coords)
	local x, y = coords[1], coords[2]
	return x < 1 or x > mapX or y < 1 or y > mapY
end

local tanks = {}
table.insert(tanks, Tank:new({ math.floor(mapX / 2 + 1), math.floor(mapY / 2 + 1) }, "north"))

local function verifCollisions(tanksParam, bulletsParam)
    for i, tank in ipairs(tanksParam) do
        for j, bullet in ipairs(bulletsParam) do
			local tankTopleft = sumOffsetToCoords(tank.coords, {- 1, - 1})
			local tankBottomRight = sumOffsetToCoords(tank.coords, {1, 1})
			local isCollision = spaceIncludesPoint(bullet.coords, tankTopleft, tankBottomRight)
			if isCollision then
                table.remove(bulletsParam, j)
                table.remove(tanksParam, i)
				table.insert(tanks, Tank:new({ math.floor(mapX / 2 + 1), math.floor(mapY / 2 + 1) }, "north"))
            end
			if isOutOfBounds(bullet.coords) then
                table.remove(bulletsParam, j)
			end
        end
    end
end

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
	for _, tank in ipairs(tanks) do
		pixelprintmatrix(tankSprites[tank.direction], sumOffsetToCoords(tank.coords, {- 1, - 1}), pixel)
		if SHOW_COORDS then
			console:write(f(tank.coords[1]) .. ";" .. f(tank.coords[2]))
		end
	end

	for _, bullet in ipairs(bullets) do
		pixelprint(bullet.coords, bulletTexture)
		bullet:move()
	end
end

return function(keyChar)
	if keyDirectionMapping[keyChar] then
		local keyDirection = keyDirectionMapping[keyChar]
		local playerTank = tanks[1]
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
		local playerTank = tanks[1]
		shotBullet(playerTank.direction, playerTank.coords)
	elseif keyChar == "h" then
		SHOW_COORDS = not SHOW_COORDS
	end
	verifCollisions(tanks, bullets)

	render()
end
