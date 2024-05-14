--- @param x integer
--- @param y integer
local function new(x, y)
	--- @class Point
	local self
	self.x = x
	self.y = y
	return self
end

return { new = new }
