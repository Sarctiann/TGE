local utils = require("tge.utils")

--- @class Dimensions
--- @field public width integer
--- @field public height integer
--- @usage
--- ```lua
--- local d = Dimensions.New(100, 40)
--- print(d)
--- d.width = 120 -- This should throw an error
--- print(d)
--- ```
Dimensions = {}

--- @param width integer
--- @param height integer
--- @return {width: integer, height: integer} inmutable
function Dimensions.New(width, height)
	return setmetatable({}, {
		__index = {
			width = width,
			height = height,
		},
		__newindex = function(_, key, value)
			utils:exit_with_error("Attempt to modify game dimensions (%s = %s)", key, value)
		end,
		__tostring = function(self)
			return string.format("Dimensions: %dx%d", self.width, self.height)
		end,
	})
end

return Dimensions
