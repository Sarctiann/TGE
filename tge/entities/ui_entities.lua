local utils = require("tge.utils")

--- @enum ACTION
local ACTION = {
	draw = 1,
	clear = 2,
	move = 3,
	move_or_draw = 4,
	update = 5,
	update_or_draw = 6,
	copy = 7,
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
	[4] = function(ui_element, data, boundaries)
		return ui_element["move_or_draw"](ui_element, data, boundaries)
	end,
	[5] = function(ui_element, data)
		ui_element["update"](ui_element, data)
	end,
	[6] = function(ui_element, data, boundaries)
		return ui_element["update_or_draw"](ui_element, data, boundaries)
	end,
	[7] = function(ui_element, data, boundaries)
		return ui_element["copy"](ui_element, data, boundaries)
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

return {
	-- Other
	ACTION = ACTION,
	COLOR = COLOR,
	truecolor = utils.colors.truecolor,
	call_action = call_action,
	-- UI Entities
	Text = require("tge.entities.ui_entities.text"),
	Unit = require("tge.entities.ui_entities.unit"),
	Line = require("tge.entities.ui_entities.line"),
	Box = require("tge.entities.ui_entities.box"),
	Sprite = require("tge.entities.ui_entities.sprite"),
	NFIcon = require("tge.entities.ui_entities.nf_icon"),
}
