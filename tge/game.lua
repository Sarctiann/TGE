--- @class Game
--- @field public connection Connection
--- @field public loader Loader
--- @field public state State
--- @field public utils Utils
--
--- @field public entities Entities
--- @field public queue Queue
--- @field public core Core
--
--- @field public dimensions {width: integer, height: integer} The dimensions of the game window in characters
--- @field public frame_rate integer The frames per second of the game
--- @field public on_event (fun(event: (keyboardEvent | mouseEvent)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
--- @field public sf SecondsFrames The seconds and frames of each second of the entire game life cycle
Game = {}

--- Creates a new game window.
--- @param init {width: integer, height: integer, frame_rate: integer}
--- @return Game game
function Game.New(init)
	local core = require("tge.core")
	local utils = require("tge.utils")

	if core.checkDimensions(init.width, init.height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end
	local entities = require("tge.entities")
	local queue = require("tge.queue")

	local self = setmetatable({
		connection = require("tge.connection"),
		loader = require("tge.loader"),
		state = require("tge.state"),

		entities = entities,
		queue = queue.New(),
		core = core,
		utils = utils,

		dimensions = entities.Dimensions.New(init.width, init.height),
		frame_rate = init.frame_rate,
		on_event = nil,
		sf = entities.SecondsFrames.new(init.frame_rate),
	}, {
		__index = Game,
	})

	return self
end

--- Starts the game.
function Game:run()
	if not self.on_event then
		self.utils:exit_with_error("The on_event hook is not defined.")
	end

	self.core:make_event_handler(self.on_event)
	self.core:start_main_loop(self.queue, self.sf)

	self.core:run()
end

--- Exits the game.
function Game:exit()
	self.core:exit()
end

return Game
