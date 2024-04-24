--- @class Brief
local Brief = {}

--- @param element UI_Entity The element to put in the screen
--- @param to Point The position for the element
--- @param from Point | nil The previous position of the element (required by the `move` method)
--- @param wait integer | nil The delay time before puting the element (in cents of seconds)
--- @return Brief brief # A new brief
function Brief.new(element, to, from, wait)
	return setmetatable({}, {
		__index = { element = element, to = to, from = from, wait = wait },
	})
end

return Brief
