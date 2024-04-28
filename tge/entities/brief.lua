local utils = require("tge.utils")

--- @class Brief
--- @field public ui_element UIEntity
--- @field public action ACTION
--- @field public where Point
--- @field public when number | nil
local Brief = {}

--- @param ui_element UIEntity The element to put in the screen
--- @param action ACTION What the element should do
--- @param where Point The position for the element
--- @param when SecondsFrames | nil The delay time before puting the element
--- @return Brief brief # A new brief
function Brief.new(ui_element, action, where, when)
	return setmetatable({}, {
		__index = { ui_element = ui_element, action = action, where = where, when = when },
		__newindex = function()
			utils:exit_with_error("Brief are inmutables")
		end,
	})
end

return Brief
