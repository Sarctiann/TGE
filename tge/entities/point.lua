--- @class Point
--- @field x integer
--- @field y integer
local Point = {}

--- @param x integer
--- @param y integer
function Point.new(x, y)
	return setmetatable({}, {
		__index = { x = x, y = y },
	})
end

return Point
