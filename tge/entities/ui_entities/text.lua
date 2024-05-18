local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

local UIEntity, ACTION = base.UIEntity, base.ACTION

--- @class TextOptions
--- @field public lf integer | nil
--- @field public align boolean | nil
--- @field public color Color | nil

--- Draws a Text ui_element and return the instance
--- @param self Text
--- @param data {pos: Point,  options: TextOptions}
local draw = function(self, data)
	self.pos = data.pos
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
		if data.options.align ~= nil then
			self.align = data.options.align
		end
	end

	utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })
end

--- Clear the ui element from the screen
--- @param self Text
local clear = function(self)
	if self.pos then
		utils:puts(self.text, self.pos, self.boundaries, { clear = true, align = self.align })
	end
end

--- Moves the text instance to a new location
--- @param self Text
--- @param data {pos: Point | DIRECTION}
local move = function(self, data)
	clear(self)

	base.try_move(self.pos, data.pos, 1, 1, self.boundaries)
	if self.pos then
		draw(self, {
			pos = self.pos,
			options = { color = self.color, lf = self.lock_frames, align = self.align },
		})
	end
end

--- Update the Text instance with the given data
--- @param self Text
--- @param data {pos: Point | nil, text: string | string[] | nil, options: TextOptions}
local update = function(self, data)
	clear(self)

	base.try_move(self.pos, data.pos, 1, 1, self.boundaries)
	self.text = data.text or self.text
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
		if data.options.align ~= nil then
			self.align = data.options.align
		end
	end
	if self.pos then
		utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })
	end
end

--- Creates a Text ui_element
--- @param data {text: string | string[], options: TextOptions | nil}
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Text : UIEntity to put/move/remove text on screen ( size: 1,1 )
	local self = UIEntity.new()

	--- @type string | string[] text to be displayed
	self.text = data.text
	--- @type Boundaries the boundaries of the text
	self.boundaries = boundaries
	--- @type Point | nil the position of the text
	self.pos = nil

	if data.options then
		--- @type Color | nil the color to be used to display the text
		self.color = data.options.color
		self.lock_frames = data.options.lf and data.options.lf > 0 and data.options.lf
			or utils:exit_with_error("lock_frames should be grather or equal to 1")
		--- @type boolean | nil if true, text will be always in the screen
		self.align = data.options.align
	end

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear
	self[ACTION.move] = move
	self[ACTION.update] = update

	return self
end

return { new = new }
