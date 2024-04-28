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
}

local call_action = {
	--- Draws the UI entity on the screen
	[1] = function(ui_element, data)
		ui_element["draw"](ui_element, data)
	end,
	--- Clears the UI entity from the screen
	[2] = function(ui_element)
		ui_element["clear"](ui_element)
	end,
	--- Moves the UI entity in the specified direction
	[3] = function(ui_element, data)
		ui_element["move"](ui_element, data)
	end,
	--- Creates a copy of the UI entity
	[4] = function(ui_element)
		ui_element["copy"](ui_element)
	end,
}

local function not_implemented(...)
	local _ = { ... }
	utils:exit_with_error("This action is not implemented by this UI Entity")
end

--- @class UIEntity
--- @field public draw fun(self, data: any): nil Draws the UI entity on the screen
--- @field public clear fun(self): nil Clears the UI entity from the screen
--- @field public move fun(self, data: any): nil Moves the UI entity in the specified direction
--- @field public copy fun(self): nil Creates a copy of the UI entity
local UIEntity = {
	draw = not_implemented,
	clear = not_implemented,
	move = not_implemented,
	copy = not_implemented,
}
UIEntity.__index = UIEntity

---------------------------------------------------------------------------------------------------------

--- @class Text : UIEntity to put/move/remove text on screen ( size: 1,1 )
--- @field public start_point Point
--- @field public end_point Point
local Text = {
	draw = function(self, data)
		self.start_point = data.start_point
		self.end_point = data.start_point.x + #data.text
		con:write(
			f("%s%s%s%s", cur.goTo(self.start_point.x, self.start_point.y), col.fg(data.color), data.text, col.resetFg)
		)
	end,
}
Text.__index = Text
setmetatable(Text, UIEntity)

--- Creates a new Text UI entity.
function Text.new()
	local self = setmetatable({
		start_point = nil,
		end_point = nil,
	}, Text)
	return self
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
	call_action = call_action,
	-- UI Entities
	Text = Text,
	Unit = Unit,
	Line = Line,
	Box = Box,
	Sprite = Sprite,
	NF_Icon = NF_Icon,
}
