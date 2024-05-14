local UIEntity = require("tge.entities.ui_entities.base_ui_entity")

local function new()
	--- @class NFIcon : UIEntity to put/move/remove icons on screen ( size: [ 1,1 | 2,1 ] )
	local self = UIEntity.new()
	return self
end

return { new = new }
