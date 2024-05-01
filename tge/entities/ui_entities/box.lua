local Unit = require("tge.entities.ui_entities.unit")

--- @class Box : Unit to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*(2o,p) )
local Box = {}
Box.__index = Box
setmetatable(Box, Unit)

return Box
