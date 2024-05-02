local UIEntity = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

--- @class Text : UIEntity to put/move/remove text on screen ( size: 1,1 )
--- @field public pos Point | nil
--- @field public text string | string[]
--- @field public color Color | nil
--- @field public lock_frames integer
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
		self.lock_frames = data.options.lf
		self.align = data.options.align
	end
	return setmetatable(self, Text)
end

--- Creates and draws a Text ui_element and return the instance
--- @param data {pos: Point, text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
function Text:draw(data, boundaries)
	self = {
		pos = data.pos,
		text = data.text,
		lock_frames = self.lock_frames,
		boundaries = boundaries,
	}
	if data.options then
		self.color = data.options.color
		self.lock_frames = data.options.lf
		self.align = data.options.align
	end

	utils:puts(self.text, self.pos, self.boundaries, { color = self.color, align = self.align })

	return setmetatable(self, Text)
end

--- Clear the ui element from the screen
function Text:clear()
	if self.pos then
		utils:puts(self.text, self.pos, self.boundaries, { clear = true, align = self.align })
	end
end

--- Moves the text instance to a.new location
--- @param data {pos: Point}
function Text:move(data)
	self:clear()
	self.pos = data.pos
	self:draw({
		pos = self.pos,
		text = self.text,
		options = { color = self.color, lf = self.lock_frames, align = self.align },
	}, self.boundaries)
end

--- Update the Text instance with the given data
--- @param data {pos: Point | nil, text: string | string[] | nil, options: TextOptions}
function Text:update(data)
	self:clear()
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

return Text
