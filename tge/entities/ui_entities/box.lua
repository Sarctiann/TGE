local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")
local state = require("tge.state")

local UIEntity, ACTION, validate_pair, validate_boundaries =
	base.UIEntity, base.ACTION, base.validate_pair, base.validate_boundaries

local function validate_line(from, to)
	if from.x == to.x or from.y == to.y then
		utils:exit_with_error("Boxes require different x and y coordinates for origin and destination")
	end
end

local function draw(self)
	state.ortogonal_puts(self.pair, self.from, self.to, { color = self.color })
end

local function clear(self)
	state.ortogonal_puts("  ", self.from, self.to, { clear = true })
end

--- @param data { pair: string, from: Point, to: Point, color: Color | nil}
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Box : UIEntity to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*o )
	local self = UIEntity.new()

	self.pair = validate_pair(data.pair)
	validate_line(data.from, data.to)
	self.from, self.to = validate_boundaries(data.from, data.to, boundaries)
	self.boundaries = boundaries
	--- @type Color
	self.color = data.color

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear

	return self
end

return { new = new }
