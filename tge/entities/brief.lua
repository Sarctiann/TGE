local utils = require("tge.utils")

--- @class Brief
--- @field public ui_element UIEntity
--- @field public action ACTION
--- @field public data table
--- @field public when SecondsFrames | nil
--- @field public boundaries Boundaries | nil
local Brief = {}

--- @param ui_element UIEntity The element to put in the screen
--- @param action ACTION What the element should do
--- @param data table The required data for the element's action.
--- @param when SecondsFrames | nil The delay time before puting the element
--- @param boundaries Boundaries | nil The boundaries of the elemen
--- @return Brief brief # A.new brief
function Brief.new(ui_element, action, data, when, boundaries)
	return setmetatable({}, {
		__index = { ui_element = ui_element, action = action, data = data, when = when, boundaries = boundaries },
		__newindex = function()
			utils:exit_with_error("Brief are inmutables")
		end,
	})
end

return Brief
