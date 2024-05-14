local utils = require("tge.utils")

local function new_index(_, key, value)
	utils:exit_with_error("Attempt to modify Boundaries (%s = %s)", key, value)
end

local function to_string(self)
	return string.format(
		"Boundaries: { top %d, left %d, bottom %d, right %d }",
		self.top,
		self.left,
		self.bottom,
		self.right
	)
end

--- @param left integer
--- @param top integer
--- @param right integer
--- @param bottom integer
--- @return Boundaries boundaries
local function new(left, top, right, bottom)
	--- @class Boundaries
	--- @field top integer
	--- @field left integer
	--- @field bottom integer
	--- @field right integer
	return setmetatable({}, {
		__index = {
			top = top,
			left = left,
			bottom = bottom,
			right = right,
		},
		__newindex = new_index,
		__tostring = to_string,
	})
end

return { new = new }
