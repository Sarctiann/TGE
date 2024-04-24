--- @class Game
--- @field public entities Entities
--- @field public queue Queue
--- @field public connection Connection
--- @field public loader Loader
--- @field public state State
--- @field public utils Utils
--
--- @field public dimensions {width: integer, height: integer} The dimensions of the game window in characters
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
		utils = utils,

		dimensions = entities.Dimensions.New(init.width, init.height),
		on_event = nil,
		queue = queue.New(),
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

	-- TODO: implement the main loop using `uv.run("nowait")`

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
