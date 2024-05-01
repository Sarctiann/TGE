local Unit = require("tge.entities.ui_entities.unit")

--- @class Line : Unit to put/move/remove/delimite unit-based lines on screen ( size: 2n,m )
local Line = {}
Line.__index = Line
setmetatable(Line, Unit)

return Line
