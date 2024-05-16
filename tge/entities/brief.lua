local utils = require("tge.utils")

local function new_index()
	utils:exit_with_error("Brief are inmutables")
end

--- @param ui_element UIEntity The element to put in the screen
--- @param action ACTION What the element should do
--- @param data table | nil The required data for the element's action.
--- @param when SecondsFrames | nil The delay time before puting the element
--- @return Brief brief # A.new brief
local function new(ui_element, action, data, when)
	--- @class Brief
	--- @field public ui_element UIEntity
	--- @field public action ACTION
	--- @field public data table | nil
	--- @field public when SecondsFrames | nil
	return setmetatable({}, {
		__index = { ui_element = ui_element, action = action, data = data, when = when },
		__newindex = new_index,
	})
end

return { new = new }
