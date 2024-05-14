local utils = require("tge.utils")

local function new_index(_, key, value)
	utils:exit_with_error("Attempt to modify Dimensions (%s = %s)", key, value)
end

local function to_string(self)
	return string.format("Dimensions: %dx%d", self.width, self.height)
end

--- @param width integer
--- @param height integer
--- @return Dimensions dimensions
local function new(width, height)
	--- @class Dimensions
	--- @field public width integer
	--- @field public height integer
	return setmetatable({}, {
		__index = {
			width = width,
			height = height,
		},
		__newindex = new_index,
		__tostring = to_string,
	})
end

return { new = new }
