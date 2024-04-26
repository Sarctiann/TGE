--- @class Game
--- @field public connection Connection
--- @field public loader Loader
--- @field public state State
--
--- @field public entities Entities
--- @field public queue Queue
--- @field public utils Utils
--
--- @field public dimensions {width: integer, height: integer} The dimensions of the game window in characters
--- @field public frame_rate integer The frames per second of the game
--- @field public on_event (fun(event: (keyboardEvent | mouseEvent)): nil) | nil The hook that is called when data from stdin is received. (Alias for luabux.Console -> console.onData).
Game = {}

--- Creates a new game window.
--- @param init {width: integer, height: integer, frame_rate: integer}
--- @return Game game
function Game.New(init)
	local utils = require("tge.utils")

	if utils.checkDimensions(init.width, init.height) == false then
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
		utils = utils,

		dimensions = entities.Dimensions.New(init.width, init.height),
		frame_rate = init.frame_rate,
		on_event = nil,
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
	local lbc = self.utils.console
	local cursor_hide = self.utils.cursor.hide
	local clear_all = self.utils.clear.all

	lbc:setMode(1)
	lbc:intoMouseMode()
	lbc:write(string.format("%s%s", cursor_hide, clear_all))
	self.utils:make_event_handler(self.on_event)
	self.utils:start_main_loop(self.frame_rate, self.queue)
	self.utils.run()
end

--- Exits the game.
function Game:exit()
	self.utils:exit()
end

return Game
