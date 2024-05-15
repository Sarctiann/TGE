local Unit = require("tge.entities.ui_entities.unit")

--- @param data { pair: string, options: UnitOptions }
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Sprite : Unit to put/move/remove symmetrical unit-based ui element on screen ( size: (2n*m)^o )
	local self = Unit.new(data, boundaries)
	return self
end

return { new = new }
