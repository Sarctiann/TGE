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

local function sumOffsetToCoords(coords, offset)
    local resultCoords = {}
    resultCoords[1] = coords[1] + offset[1]
    resultCoords[2] = coords[2] + offset[2]
    return resultCoords
end

local function spaceIncludesPoint(pointCoords, spaceTopleftCoords, spaceBottomrightCoord)
	local pointX, pointY = pointCoords[1], pointCoords[2]
	local topleftX, topleftY = spaceTopleftCoords[1], spaceTopleftCoords[2]
	local bottomrightX, bottomrightY = spaceBottomrightCoord[1], spaceBottomrightCoord[2]
	return pointX >= topleftX and pointX <= bottomrightX and pointY >= topleftY and pointY <= bottomrightY
end

return { createEmptyRectangle = createEmptyRectangle, sumOffsetToCoords = sumOffsetToCoords, spaceIncludesPoint = spaceIncludesPoint }
