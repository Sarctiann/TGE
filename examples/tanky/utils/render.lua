local console = require("examples.tanky.utils.console").console
local box = require("luabox")
local cursor = box.cursor
local mathutils = require("examples.tanky.utils.math")
local sumOffsetToCoords = mathutils.sumOffsetToCoords

local f = string.format

local pixelprint = function(coords, element)
	local x, y = coords[1], coords[2]
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

local pixelprintmatrix = function(matrix, topleft, element)
	for i = 1, #matrix do
		for j = 1, #matrix[i] do
			if matrix[i][j] == 1 then
				pixelprint(sumOffsetToCoords(topleft, {j - 1, i - 1}), element)
			end
		end
	end
end

return { pixelprint = pixelprint, printmatrix = printmatrix, pixelprintmatrix = pixelprintmatrix }
