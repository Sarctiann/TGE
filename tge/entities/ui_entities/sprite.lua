local Unit = require("tge.entities.ui_entities.unit")

--- @class Sprite : Unit to put/move/remove symmetrical unit-based ui element on screen ( size: (2n*m)^o )
local Sprite = {}
Sprite.__index = Sprite
setmetatable(Sprite, Unit)

return Sprite
