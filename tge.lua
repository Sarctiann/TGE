--- TGE - Terminal Game Engine

--- @alias UNIT_WIDTH 1 | 2

--- This global constant is used to set the weight of a unit.
--- @type UNIT_WIDTH
_G.__UNIT_WIDTH = 2 -- Default value for normal fonts

return {
	Game = require("tge.game"),
	core = require("tge.core"),
	utils = require("tge.utils"),
	entities = require("tge.entities"),
	Queue = require("tge.queue"),
	connection = require("tge.connection"),
	loader = require("tge.loader"),
	state = require("tge.state"),
	sequences = require("tge.sequences"),
}
