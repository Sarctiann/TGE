local utils = require("tge.utils")

--- @class Boundaries
--- @field public top integer
--- @field public left integer
--- @field public bottom integer
--- @field public right integer
Boundaries = {}

--- @param left integer
--- @param top integer
--- @param right integer
--- @param bottom integer
--- @return Boundaries boundaries
function Boundaries.new(left, top, right, bottom)
	return setmetatable({}, {
		__index = {
			top = top,
			left = left,
			bottom = bottom,
			right = right,
		},
		__newindex = function(_, key, value)
			utils:exit_with_error("Attempt Boundaries (%s = %s)", key, value)
		end,
		__tostring = function(self)
			return string.format("Boundaries: %dx%d", self.width, self.height)
		end,
	})
end

return Boundaries
