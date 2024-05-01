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
--- @field public wrap boolean | nil

--- Creates and draws a Text ui_element and return the instance
--- @param data {text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
function Text.new(data, boundaries)
	return setmetatable({
		text = data.text,
		color = data.options.color,
		lock_frames = data.options.lf,
		align = data.options.align,
		wrap = data.options.wrap,
		boundaries = boundaries,
	}, Text)
end

--- Creates and draws a Text ui_element and return the instance
--- @param data {pos: Point, text: string | string[], options: TextOptions}
--- @param boundaries Boundaries
function Text:draw(data, boundaries)
	self = {
		pos = data.pos,
		text = data.text,
		color = data.options.color,
		lock_frames = data.options.lf,
		align = data.options.align,
		wrap = data.options.wrap,
		boundaries = boundaries,
	}

	utils:puts(data.text, data.pos, boundaries, { color = data.options.color, align = data.options.align })

	return setmetatable(self, Text)
end

--- Moves the text instance to a.new location
--- @param data {pos: Point}
function Text:move(data)
	if self.pos then
		utils:puts(self.text, self.pos, self.boundaries, { clear = true, align = self.align })
	end
	self.pos = data.pos
	self:draw(
		{ pos = data.pos, text = self.text, color = self.color, lf = self.lock_frames, align = self.align },
		self.boundaries
	)
end

return Text
