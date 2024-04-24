local utils = require("tge.utils")

--- @class Brief
--- @field public element UI_Entity
--- @field public to Point
--- @field public from Point | nil
--- @field public when number
local Brief = {}

--- @param element UI_Entity The element to put in the screen
--- @param to Point The position for the element
--- @param from Point | nil The previous position of the element (required by the `move` method)
--- @param wait integer | nil The delay time before puting the element (in cents of seconds)
--- @return Brief brief # A new brief
function Brief.new(element, to, from, wait)
	local now = os.time()
	local when = wait and now + wait or 0
	return setmetatable({}, {
		__index = { element = element, to = to, from = from, when = when },
		__newindex = function()
			utils:exit_with_error("Brief are inmutables")
		end,
	})
end

return Brief
