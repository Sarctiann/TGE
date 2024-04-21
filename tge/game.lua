--- @class Game
--- @field public entities Entities
--- @field public queues Queues
--- @field public connection Connection
--- @field public loader Loader
--- @field public state State
--- @field public utils Utils
--
--- @field public dimensions {width: integer, height: integer}
Game = {}

Game.__index = Game

--- Creates a new game window.
--- @param width integer The width of the game window in characters.
--- @param height integer The height of the game window in characters.
function Game.New(width, height)
	local self = setmetatable({}, Game)
	local utils = require("tge.utils")

	if utils.checkDimensions(width, height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end

	self.entities = require("tge.entities")
	self.queues = require("tge.queues")
	self.connection = require("tge.connection")
	self.loader = require("tge.loader")
	self.state = require("tge.state")
	self.utils = utils

	self.dimensions = self.entities.Dimensions.New(width, height)

	return self
end

return Game
