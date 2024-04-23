--- @class Game
--- @field public entities Entities
--- @field public queues Queues
--- @field public connection Connection
--- @field public loader Loader
--- @field public state State
--- @field public utils Utils
--
--- @field public dimensions {width: integer, height: integer} The dimensions of the game window in characters
--- @field public on_event (fun(data: (keyboardEvent | mouseEvent | nil)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
--
--- @field private __index Game
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
	self.on_event = nil

	return self
end

--- Starts the game.
function Game:run()
	if not self.on_event then
		self.utils:exit_with_error("The on_event hook is not defined.")
	end
	local lbc = self.utils.console
	self.utils:make_event_handler(self.on_event)

	-- TODO: implement the main loop

	lbc.run()
end

--- Exits the game.
function Game:exit()
	local console = self.utils.console
	local cursor = self.utils.cursor

	console:write("\x1b[2j\x1b[H") -- Clear the screen and returns the prompt to the top
	cursor.goTo(1, 1)
	console:write("\n")
	console:write(cursor.show)
	console:setMode(0)
	console:exitMouseMode()
	console:close()

	os.exit()
end

return Game
