local Unit = require("tge.entities.ui_entities.unit")

local function new()
	--- @class Sprite : Unit to put/move/remove symmetrical unit-based ui element on screen ( size: (2n*m)^o )
	local self = Unit.new()
	return self
end

return { new = new }
