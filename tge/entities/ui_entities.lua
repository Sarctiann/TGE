--- @enum ACTION
local ACTION = {
	draw = 1,
	clear = 2,
	move = 3,
	copy = 4,
}

--- @class UIEntity
local UIEntity = {}

-- TODO: create a `Text` object-like table as an entity
-- to put/move/remove text on screen ( size: 1,1 )

-- TODO: create a `Unit` object-like table as an entity
-- to put/move/remove the minimal symmetrical ui element
-- on screen ( size: 2,1 )

-- TODO: create a `Line` object-like table as an entity
-- to put/move/remove/delimite unit-based lines
-- on screen ( size: 2n,m )

-- TODO: create a `Box` object-like table as an entity
-- to put/move/remove/delimite unit-based spaces
-- on screen ( size: (2n*m)*(2o,p) )

-- TODO: create a `Strite` object-like table as an entity
-- to put/move/remove symmetrical unit-based ui element
-- on screen ( size:  (2n*m)^o )

-- TODO: create an `NF_Icon` object-like table as an entity
-- to put/more/remove text-based and unit-based icons on
-- screen ( size: [ 1,1 | 2,1 ] )

return {
	ACTION = ACTION,
	UIEntity = UIEntity,
}
