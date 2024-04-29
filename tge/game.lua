local core = require("tge.core")
local utils = require("tge.utils")
local entities = require("tge.entities")

--- @class Game
--- @field public queue Queue
--- @field public dimensions {width: integer, height: integer} The dimensions of the game window in characters
--- @field public frame_rate integer The frames per second of the game
--- @field public on_event (fun(event: (keyboardEvent | mouseEvent)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
--- @field public sf SecondsFrames The seconds and frames of each second of the entire game life cycle
--- @field public show_status boolean
--- @field public debug boolean | table
Game = {}

--- Creates a new game window.
--- @param init {width: integer, height: integer, frame_rate: integer, show_status: boolean | table | nil, debug: boolean | nil}
--- @return Game game
function Game.New(init)
	if core.checkDimensions(init.width, init.height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end
	local queue = require("tge.queue")

	return setmetatable({
		queue = queue.New(),
		dimensions = entities.Dimensions.New(init.width, init.height),
		frame_rate = init.frame_rate,
		on_event = nil,
		sf = entities.SecondsFrames.new(init.frame_rate),
		show_status = init.show_status and init.show_status or false,
		debug = init.debug and init.debug or false,
	}, {
		__index = Game,
	})
end

--- Starts the game.
function Game:run()
	if not self.on_event then
		utils:exit_with_error("The on_event hook is not defined.")
	end

	core:make_event_handler(self.on_event)
	core:start_main_loop(self)

	core:run()
end

--- Exits the game.
function Game:exit()
	core:exit()
end

return Game
