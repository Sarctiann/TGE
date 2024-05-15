local Unit = require("tge.entities.ui_entities.unit")

--- @param data { pair: string, options: UnitOptions }
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Box : Unit to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*(2o,p) )
	local self = Unit.new(data, boundaries)
	return self
end

return { new = new }
