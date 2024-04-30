local utils = require("tge.utils")

--- @enum ACTION
local ACTION = {
	draw = 1,
	clear = 2,
	move = 3,
	copy = 4,
	move_or_draw = 5,
	copy_or_draw = 6,
}

local call_action = {
	[1] = function(ui_element, data, boundaries)
		return ui_element["draw"](ui_element, data, boundaries)
	end,
	[2] = function(ui_element)
		ui_element["clear"](ui_element)
	end,
	[3] = function(ui_element, data)
		ui_element["move"](ui_element, data)
	end,
	[4] = function(ui_element, data)
		ui_element["copy"](ui_element, data)
	end,
	[5] = function(ui_element, data, boundaries)
		return ui_element["more_or_draw"](ui_element, data, boundaries)
	end,
	[6] = function(ui_element, data, boundaries)
		return ui_element["copy_or_draw"](ui_element, data, boundaries)
	end,
}

-- I had to rewrite this enum because the LS was not working properly identifying the values

--- @enum COLOR
local COLOR = {
	Black = 0,
	Red = 1,
	Green = 2,
	Yellow = 3,
	Blue = 4,
	Magenta = 5,
	Cyan = 6,
	White = 7,
	LightBlack = 8,
	LightRed = 9,
	LightGreen = 10,
	LightYellow = 11,
	LightBlue = 12,
	LightMagenta = 13,
	LightCyan = 14,
	LightWhite = 15,
}

--- @class TrueColor
--- @field sec integer
--- @field color {r: integer, g: integer, b: integer}

--- @class Color
--- @field fg COLOR | TrueColor | nil
--- @field bg COLOR | TrueColor | nil

local function not_implemented(action)
	utils:exit_with_error("%s action is not implemented by this UI Entity", action)
end

--- @class UIEntity
--- @field public boundaries Boundaries The boundaries of the UI entity
--- @field public lock_frames integer The ammount of frames must wait to unlock
--- @field public locked_until SecondsFrames | nil The time in seconds and frames until the entity is unlocked
--- @field public draw fun(self, data: any, boundaries: Boundaries): self Draws the UI entity on the screen and returns the instance
--- @field public clear fun(self, patch: any): nil Clears the UI entity from the screen
--- @field public move fun(self, data: any, patch: any): nil Moves the UI entity in the specified direction
--- @field public copy fun(self, data: any): nil Creates a copy of the UI entity
--- @field public move_or_draw fun(self, data: any, boundaries: Boundaries, patch: any): self Tries to move the instance or draws and returns it
--- @field public copy_or_draw fun(self, data: any, boundaries: Boundaries): self Tries to copy the instance or draws and returns it
local UIEntity = {
	locked_until = nil,
	lock_frames = 1,
	draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("DRAW")
	end,
	clear = function()
		not_implemented("CLEAR")
	end,
	move = function()
		not_implemented("MOVE")
	end,
	copy = function()
		not_implemented("COPY")
	end,
	move_or_draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("MOVE_OR_DRAW")
	end,
	copy_or_draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("COPY_OR_DRAW")
	end,
}
UIEntity.__index = UIEntity

---------------------------------------------------------------------------------------------------------

--- @class Text : UIEntity to put/move/remove text on screen ( size: 1,1 )
--- @field public pos Point | nil
--- @field public text string | string[]
--- @field public color Color | nil
--- @field public lock_frames integer
local Text = {}
Text.__index = Text
setmetatable(Text, UIEntity)

--- Creates a Text ui_element

--- Creates and draws a Text ui_element and return the instance
--- @param data {text: string | string[], color: Color | nil, lf: integer | nil}
--- @param boundaries Boundaries
function Text.new(data, boundaries)
	return setmetatable({
		text = data.text,
		color = data.color,
		lock_frames = data.lf,
		boundaries = boundaries,
	}, Text)
end

--- Creates and draws a Text ui_element and return the instance
--- @param data {pos: Point, text: string | string[], color: Color | nil, lf: integer | nil}
--- @param boundaries Boundaries
function Text:draw(data, boundaries)
	self = {
		pos = data.pos,
		text = data.text,
		color = data.color,
		lock_frames = data.lf,
		boundaries = boundaries,
	}

	utils:puts(data.text, data.pos, boundaries, { color = data.color })

	return setmetatable(self, Text)
end

--- Moves the text instance to a.new location
--- @param data {pos: Point}
function Text:move(data)
	if self.pos then
		-- TODO: take the background elements from the "state.static_collection.background"
		utils:puts(self.text, self.pos, self.boundaries, { clear = true })
	end
	self.pos = data.pos
	self:draw({ pos = data.pos, text = self.text, color = self.color, lf = self.lock_frames }, self.boundaries)
end

---------------------------------------------------------------------------------------------------------

--- @class Unit : UIEntity to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
local Unit = {}
Unit.__index = Unit
setmetatable(Unit, UIEntity)

---------------------------------------------------------------------------------------------------------

--- @class Line : Unit to put/move/remove/delimite unit-based lines on screen ( size: 2n,m )
local Line = {}
Line.__index = Line
setmetatable(Line, Unit)

---------------------------------------------------------------------------------------------------------

--- @class Box : Unit to put/move/remove/delimite unit-based spaces on screen ( size: (2n*m)*(2o,p) )
local Box = {}
Box.__index = Box
setmetatable(Box, Unit)

---------------------------------------------------------------------------------------------------------

--- @class Sprite : Unit to put/move/remove symmetrical unit-based ui element on screen ( size: (2n*m)^o )
local Sprite = {}
Sprite.__index = Sprite
setmetatable(Sprite, Unit)

---------------------------------------------------------------------------------------------------------

--- @class NF_Icon : UIEntity to put/move/remove icons on screen ( size: [ 1,1 | 2,1 ] )
local NF_Icon = {}
NF_Icon.__index = NF_Icon
setmetatable(NF_Icon, UIEntity)

---------------------------------------------------------------------------------------------------------

return {
	-- Other
	ACTION = ACTION,
	COLOR = COLOR,
	truecolor = utils.colors.truecolor,
	call_action = call_action,
	-- UI Entities
	Text = Text,
	Unit = Unit,
	Line = Line,
	Box = Box,
	Sprite = Sprite,
	NF_Icon = NF_Icon,
}
