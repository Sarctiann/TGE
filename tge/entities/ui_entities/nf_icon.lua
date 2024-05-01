local UIEntity = require("tge.entities.ui_entities.base_ui_entity")

--- @class NFIcon : UIEntity to put/move/remove icons on screen ( size: [ 1,1 | 2,1 ] )
local NFIcon = {}
NFIcon.__index = NFIcon
setmetatable(NFIcon, UIEntity)

return NFIcon
