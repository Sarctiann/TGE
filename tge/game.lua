local core = require("tge.core")
local utils = require("tge.utils")
local entities = require("tge.entities")
local Queue = require("tge.queue")
local sequences = require("tge.sequences")
local state = require("tge.state")

local function init_dimensions(width, height)
	if core.checkDimensions(width, height) == false then
		utils:exit_with_error("The terminal is too small to create the game window.")
	end
	return entities.Dimensions.new(width, height)
end

local init_seconds_frames = function(fr)
	return entities.SecondsFrames.new(fr)
end

local initial_queue = Queue.new()

local function run(game)
	if not game.on_event then
		utils:exit_with_error("The on_event hook is not defined.")
	end

	core.make_event_handler(game.on_event)
	core.start_main_loop(game)

	core.run()
end

--- Creates a new game window.
--- @param init {width: integer, height: integer, frame_rate: integer, status_bar: table | nil, debug: debug_key[] | nil, set_unit_width: UNIT_WIDTH | nil}
--- @return Game
local function new(init)
	--- @class Game
	local self = {
		--- @type integer The frames per second of the game
		frame_rate = init.frame_rate,
		--- @type table | nil
		status_bar = init.status_bar and init.status_bar,
		--- @type debug_key[] | nil
		debug = init.debug and init.debug,
	}

	if init.set_unit_width then
		_UNIT_WIDTH = init.set_unit_width or 2
	end

	--- @type Dimensions {width: integer, height: integer} The dimensions of the game window in characters
	self.dimensions = init_dimensions(init.width, init.height)
	state.init_screen_repr(init.height)

	--- @type Queue The Brief queue of the game
	self.queue = initial_queue

	--- @type SecondsFrames The seconds and frames of each second of the entire game life cycle
	self.sf = init_seconds_frames(init.frame_rate)

	--- @type (fun(event: (keyboardEvent | mouseEvent)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
	self.on_event = nil

	--- Starts the game.
	--- @type fun(self: Game): nil
	self.run = run

	--- @type fun(layer_name: string): nil
	--- Add a new line to the status bar
	self.add_layer = state.add_layer

	--- Exits the game.
	--- @type fun(exit_message: string | nil): nil
	self.exit = core.exit

	-- Sequences Hooks

	--- Initialize the collection of sprite sequences
	--- @type fun(): SpriteSequences
	self.get_sprite_seqs = function()
		return sequences.SpriteSeqs.new(self)
	end

	return self
end

return { new = new }
