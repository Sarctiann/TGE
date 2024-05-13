local core = require("tge.core")
local utils = require("tge.utils")
local entities = require("tge.entities")
local Queue = require("tge.Queue")

--- Creates a new game window.
--- @param init {width: integer, height: integer, frame_rate: integer, status_bar: table | nil, debug: boolean | nil}
local function new(init)
	if core.checkDimensions(init.width, init.height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end

	--- @class Game
	local self = {
		--- @type Dimensions {width: integer, height: integer} The dimensions of the game window in characters
		dimensions = entities.Dimensions.new(init.width, init.height),
		--- @type integer The frames per second of the game
		frame_rate = init.frame_rate,
		--- @type Queue The Brief queue of the game
		queue = Queue.new(),
		--- @type SecondsFrames The seconds and frames of each second of the entire game life cycle
		sf = entities.SecondsFrames.new(init.frame_rate),
		--- @type table | nil
		status_bar = init.status_bar and init.status_bar,
		--- @type boolean | nil
		debug = init.debug and init.debug or false,
	}
	--- @type (fun(event: (keyboardEvent | mouseEvent)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
	self.on_event = nil

	--- Starts the game.
	self.run = function()
		if not self.on_event then
			utils:exit_with_error("The on_event hook is not defined.")
		end

		core:make_event_handler(self.on_event)
		core:start_main_loop(self)

		core:run()
	end

	--- Exits the game.
	self.exit = function()
		core:exit()
	end

	return self
end

return { new = new }
