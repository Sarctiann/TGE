local Unit = require("tge.entities.ui_entities.unit")

local function new()
	local self = Unit.new()
	return self
end

return { new = new }
