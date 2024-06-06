local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")
local state = require("tge.state")

local UIEntity, ACTION, validate_unit, validate_boundaries =
	base.UIEntity, base.ACTION, base.validate_unit, base.validate_boundaries

local function validate_line(from, to)
	if from.x ~= to.x and from.y ~= to.y then
		utils:exit_with_error("Lines must be horizontal or vertical")
	end
	if from.x == to.x and from.y == to.y then
		utils:exit_with_error("Lines requires at different coordinates for origin and destination")
	end
end

local function draw(self)
	state.ortogonal_puts(self.unit, self.from, self.to, { color = self.color, target_layer = self.target_layer })
end

local function clear(self)
	state.ortogonal_puts("  ", self.from, self.to, { clear = true, target_layer = self.target_layer })
end

--- @param data { unit: string, from: Point, to: Point, color: Color | nil, target_layer: string | nil }
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Line : UIEntity to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*o )
	local self = UIEntity.new()

	self.unit = validate_unit(data.unit)
	validate_line(data.from, data.to)
	self.from, self.to = validate_boundaries(data.from, data.to, boundaries)
	self.boundaries = boundaries
	--- @type Color
	self.color = data.color
	self.target_layer = data.target_layer

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear

	return self
end

return { new = new }
