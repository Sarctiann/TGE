local UIEntity = require("tge.entities.ui_entities.base_ui_entity")

--- @class Unit : UIEntity to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
local Unit = {}
Unit.__index = Unit
setmetatable(Unit, UIEntity)

return Unit
