local utils = require("tge.utils")

--- @class Dimensions
--- @field public width integer
--- @field public height integer
Dimensions = {}

--- @param width integer
--- @param height integer
--- @return Dimensions dimensions
function Dimensions.new(width, height)
	return setmetatable({}, {
		__index = {
			width = width,
			height = height,
		},
		__newindex = function(_, key, value)
			utils:exit_with_error("Attempt Dimensions (%s = %s)", key, value)
		end,
		__tostring = function(self)
			return string.format("Dimensions: %dx%d", self.width, self.height)
		end,
	})
end

return Dimensions
