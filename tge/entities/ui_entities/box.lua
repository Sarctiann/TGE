local Unit = require("tge.entities.ui_entities.unit")

local function new()
	--- @class Box : Unit to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*(2o,p) )
	local self = Unit.new()
	return self
end

return { new = new }
