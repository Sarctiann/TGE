local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

local UIEntity, ACTION = base.UIEntity, base.ACTION

--- @class UnitOptions
--- @field lf number
--- @field color Color

--- Creates and draws a Text ui_element and return the instance
--- @param self Unit
--- @param data {pos: Point, pair: string, options: UnitOptions}
local draw = function(self, data)
	self = {
		pos = data.pos,
		text = data.pair,
	}
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
	end

	utils:simple_puts(self.text, self.pos, self.boundaries, { color = self.color })
	return self
end

--- Clear the ui element from the screen
--- @param self Unit
local clear = function(self)
	if self.pos then
		utils:simple_puts(self.pair, self.pos, self.boundaries, { clear = true })
	end
end

--- Moves the text instance to a new location
--- @param self Unit
--- @param data {pos: Point | DIRECTION}
local move = function(self, data)
	clear(self)

	self.pos = base.move_point_or_nil(self.pos, data.pos, 1, 1)
	if self.pos then
		draw(self, {
			pos = self.pos,
			pair = self.pair,
			options = { color = self.color, lf = self.lock_frames },
		})
	end
end

--- Update the Text instance with the given data
--- @param self Unit
--- @param data {pos: Point | nil, pair: string | nil, options: UnitOptions}
local update = function(self, data)
	clear(self)
	self.pos = data.pos or self.pos
	self.pair = data.pair or self.pair
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
	end
	if self.pos then
		utils:simple_puts(self.pair, self.pos, self.boundaries, { color = self.color })
	end
end

--- @param data {pair: string, options: UnitOptions}
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Unit : UIEntity to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
	local self = UIEntity

	--- @type string the pair of the unit
	self.pair = data.pair
	--- @type Boundaries the boundaries of the unit
	self.boundaries = boundaries
	--- @type Point | nil the position of the unit
	self.pos = nil

	if data.options then
		--- @type Color
		self.color = data.options.color
		self.lock_frames = data.options.lf
	end

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear
	self[ACTION.move] = move
	self[ACTION.update] = update

	return self
end

return { new = new }
