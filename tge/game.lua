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
--- @param init {width: integer, height: integer, frame_rate: integer}
function Game.New(init)
	local self = setmetatable({}, Game)
	local utils = require("tge.utils")

	if utils.checkDimensions(init.width, init.height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end

	self.entities = require("tge.entities")
	self.queues = require("tge.queues")
	self.connection = require("tge.connection")
	self.loader = require("tge.loader")
	self.state = require("tge.state")
	self.utils = utils

	self.dimensions = self.entities.Dimensions.New(init.width, init.height)

	return self
end

function Game:run()
	-- TODO: implement the main loop
	local lbc = self.utils.console
	lbc.run()
end

return Game
