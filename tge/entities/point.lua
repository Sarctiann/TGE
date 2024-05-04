--- @class Point
--- @field public x integer
--- @field public y integer
local Point = {}

--- @param x integer
--- @param y integer
function Point.new(x, y)
	return setmetatable({ x = x, y = y }, {
		__index = Point,
	})
end

return Point
