local utils = require("tge.utils")

local con = utils.console
local cur = utils.cursor
local col = utils.colors
local f = string.format

--- @enum ACTION
local ACTION = {
	draw = 1,
	clear = 2,
	move = 3,
	copy = 4,
	move_or_draw = 5,
	copy_or_draw = 6,
}

--- @enum COLOR
local COLOR = {
	Black = col.black,
	Red = col.red,
	Green = col.green,
	Yellow = col.yellow,
	Blue = col.blue,
	Magenta = col.magenta,
	Cyan = col.cyan,
	White = col.white,
	LightBlack = col.lightBlack,
	LightRed = col.lightRed,
	LightGreen = col.lightGreen,
	LightYellow = col.lightYellow,
	LightBlue = col.lightBlue,
	LightMagenta = col.LightMagenta,
	LightCyan = col.lightCyan,
	LightWhite = col.lightWhite,
}

--- @class Color
--- @field fg COLOR | nil
--- @field bg COLOR | nil
local Color = {}

local call_action = {
	[1] = function(ui_element, data)
		return ui_element["draw"](ui_element, data)
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
	[5] = function(ui_element, data)
		return ui_element["more_or_draw"](ui_element, data)
	end,
	[6] = function(ui_element, data)
		return ui_element["copy_or_draw"](ui_element, data)
	end,
}

local function not_implemented(action)
	utils:exit_with_error("%s action is not implemented by this UI Entity", action)
end

--- @class UIEntity
--- @field public is_locked boolean Especify if the entity is locked to add more briefs
--- @field public locked_frames integer The ammount of frames must wait to unlock
--- @field public draw fun(self, data: any): self Draws the UI entity on the screen and returns the instance
--- @field public clear fun(self): nil Clears the UI entity from the screen
--- @field public move fun(self, data: any): nil Moves the UI entity in the specified direction
--- @field public copy fun(self, data: any): nil Creates a copy of the UI entity
--- @field public move_or_draw fun(self, data: any): self Tries to move the instance or draws and returns it
--- @field public copy_or_draw fun(self, data: any): self Tries to copy the instance or draws and returns it
local UIEntity = {
	is_locked = false,
	locked_frames = 1,
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
--- @field public text string
--- @field public color Color | nil
--- @field public locked_frames integer
local Text = {}
Text.__index = Text
setmetatable(Text, UIEntity)

--- Creates a Text ui_element

--- Creates and draws a Text ui_element and return the instance
--- @param data {text: string, color: Color | nil}
function Text.New(data)
	return setmetatable({
		locked_frames = 5,
		text = data.text,
		color = data.color,
	}, Text)
end

--- Creates and draws a Text ui_element and return the instance
--- @param data {pos: Point, text: string, color: Color | nil, lf: integer | nil}
function Text:draw(data)
	self = {
		pos = data.pos,
		text = data.text,
		color = data.color,
		locked_frames = data.lf,
	}
	local fg = data.color.fg and col.fg(data.color.fg) or ""
	local bg = data.color.bg and col.bg(data.color.bg) or ""
	local rfg = data.color.fg and col.resetFg or ""
	local rbg = data.color.bg and col.resetBg or ""
	con:write(f("%s%s%s%s%s%s", cur.goTo(self.pos.x, self.pos.y), fg, bg, data.text, rfg, rbg))
	return setmetatable(self, Text)
end

--- Moves the text instance to a new location
--- @param data {pos: Point}
function Text:move(data)
	if self.pos then
		con:write(f("%s%s", cur.goTo(self.pos.x, self.pos.y), string.rep(" ", #self.text)))
	end
	self.pos = data.pos
	self:draw({ pos = data.pos, text = self.text, color = self.color, lf = self.locked_frames })
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
	call_action = call_action,
	Color = Color,
	-- UI Entities
	Text = Text,
	Unit = Unit,
	Line = Line,
	Box = Box,
	Sprite = Sprite,
	NF_Icon = NF_Icon,
}
