local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

local UIEntity, ACTION = base.UIEntity, base.ACTION

--- @class Text : UIEntity to put/move/remove text on screen ( size: 1,1 )
--- @field public pos Point | nil
--- @field public text string | string[]
--- @field public color Color | nil
--- @field public align boolean | nil
local Text = {}
Text.__index = Text
setmetatable(Text, UIEntity)

--- @class TextOptions
--- @field public color Color | nil
--- @field public lf integer | nil
--- @field public align boolean | nil

--- Creates a Text ui_element and return the instance
--- @param data {text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
function Text.new(data, boundaries)
	local self = {
		text = data.text,
		boundaries = boundaries,
	}
	if data.options then
		self.color = data.options.color
		self.lock_frames = data.options.lf and data.options.lf > 0 and data.options.lf
			or utils:exit_with_error("lock_frames should be grather or equal to 1")
		self.align = data.options.align
	end
	return setmetatable(self, Text)
end

--- Creates and draws a Text ui_element and return the instance
--- @param self Text
--- @param data {pos: Point, text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
Text[ACTION.draw] = function(self, data, boundaries)
	self = {
		pos = data.pos,
		text = data.text,
		boundaries = boundaries,
	}
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
		if data.options.align ~= nil then
			self.align = data.options.align
		end
	end

	utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })

	return setmetatable(self, Text)
end

--- Clear the ui element from the screen
--- @param self Text
Text[ACTION.clear] = function(self)
	if self.pos then
		utils:puts(self.text, self.pos, self.boundaries, { clear = true, align = self.align })
	end
end

--- Moves the text instance to a new location
--- @param self Text
--- @param data {pos: Point | DIRECTION}
Text[ACTION.move] = function(self, data)
	self[ACTION.clear](self)

	self.pos = utils:move_point_or_nil(self.pos, data.pos, 1, 1)
	if self.pos then
		self[ACTION.draw](self, {
			pos = self.pos,
			text = self.text,
			options = { color = self.color, lf = self.lock_frames, align = self.align },
		}, self.boundaries)
	end
end

--- Moves or Draw the Text instance in a new location, with the given data and return the instance
--- @param self Text
--- @param data {pos: Point, text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
Text[ACTION.move_or_draw] = function(self, data, boundaries)
	self[ACTION.clear](self)
	self.pos = data.pos
	self.text = data.text
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
		if data.options.align ~= nil then
			self.align = data.options.align
		end
	end
	self.boundaries = self.boundaries or boundaries
	utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })
	return self
end

--- Update the Text instance with the given data
--- @param self Text
--- @param data {pos: Point | nil, text: string | string[] | nil, options: TextOptions}
Text[ACTION.update] = function(self, data)
	self[ACTION.clear](self)
	self.pos = data.pos or self.pos
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

--- Update or Draw the Text instance with the given data and return the instance
--- @param self Text
--- @param data {pos: Point | nil, text: string | string[] | nil, options: TextOptions}
--- @param boundaries Boundaries
Text[ACTION.update_or_draw] = function(self, data, boundaries)
	self[ACTION.clear](self)
	self.pos = data.pos or self.pos
	self.text = data.text or self.text
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
		if data.options.align ~= nil then
			self.align = data.options.align
		end
	end
	self.boundaries = boundaries or self.boundaries
	utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })
	return self
end

--- Copy a Text instance and return the new instance
--- @param self Text
--- @param data {pos: Point | nil, text: string | string[] | nil, options: TextOptions}
--- @param boundaries Boundaries
Text[ACTION.copy] = function(self, data, boundaries)
	local new_text = {
		pos = data.pos or self.pos,
		text = data.text or self.text,
		boundaries = boundaries or self.boundaries,
	}
	if data.options then
		new_text.color = data.options.color or new_text.color
		new_text.lock_frames = data.options.lf or new_text.lock_frames
		if data.options.align ~= nil then
			new_text.align = data.options.align
		end
		utils:puts(new_text.text, new_text.pos, new_text.boundaries, { color = new_text.color, align = new_text.align })
		return setmetatable(new_text, Text)
	end
end

return Text
