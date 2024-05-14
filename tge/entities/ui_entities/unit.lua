local UIEntity = require("tge.entities.ui_entities.base_ui_entity")

local function new()
	--- @class Unit : UIEntity to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
	local self = UIEntity.new()
	return self
end

return { new = new }
