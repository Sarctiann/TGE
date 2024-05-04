local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

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
	ACTION = base.ACTION,
	DIRECTION = utils.DIRECTION,
	COLOR = COLOR,
	truecolor = utils.colors.truecolor,
	-- UI Entities
	Text = require("tge.entities.ui_entities.text"),
	Unit = require("tge.entities.ui_entities.unit"),
	Line = require("tge.entities.ui_entities.line"),
	Box = require("tge.entities.ui_entities.box"),
	Sprite = require("tge.entities.ui_entities.sprite"),
	NFIcon = require("tge.entities.ui_entities.nf_icon"),
}
