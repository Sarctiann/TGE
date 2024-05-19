local uv = require("luv")
local utils = require("tge.utils")

--- This class holds the uv.timer instance and the methods to create and stop the main loop
--- @class Core
local Core = {
	--- @type Timer | nil
	timer = nil,
	--- @type (keyboardEvent | mouseEvent) | nil
	enent_monitor = nil,
}

--- @param interval integer time in milliseconds
--- @param callback function the function to be executed
--- Initialize and starts the Core.timer (the main loop)
local function create_main_loop(interval, callback)
	Core.timer = uv.new_timer()
	Core.timer:start(0, interval, function()
		callback()
	end)
end

--- Stops the Main Loop
local function clear_main_loop()
	Core.timer:stop()
	Core.timer:close()
end

--- function that chacks if there are space to create the game window
--- @param width integer width of the window in characters
--- @param height integer height of the window in characters
function Core.checkDimensions(width, height)
	local term_width, term_height = utils.console:getDimensions()
	if width > term_width or height > term_height then
		return false
	end
	return true
end

--- Initialize the envent handler
--- @param handler fun(event: (keyboardEvent | mouseEvent)): nil
function Core.make_event_handler(handler)
	local function event_loop(data)
		local first
		local rest = {}

		for char in data:gmatch(".") do
			if not first then
				first = char
			else
				table.insert(rest, char)
			end
		end
		local iter = utils.luabox_util.StringIterator(table.concat(rest))
		local event = utils.event.parse(first, iter)

		if event == nil then
			return
		end
		Core.event_monitor = event
		handler(event)
	end
	utils.console.onData = event_loop
end

--- @alias debug_key
--- | "Key"
--- | "Char"
--- | "Event"
--- | "Button"
--- | "X"
--- | "Y"
--- | "MemoryUsage"
--- | "QueuedBriefs"
--- | "ActiveBriefs"
--- | "Ticks"

local hv = utils.has_value_or_nil

local function _build_status_bar(game, briefs)
	if game.debug ~= nil then
		local e = Core.event_monitor
		local data = {
			hv(game.debug, "Key") and e and { "Key", string.format("%-9s", e.key) },
			hv(game.debug, "Char") and e and {
				"Char",
				string.format("%-3s", e.char == "\n" and "\\n" or e.char == "\t" and "\\t" or e.char),
			},
			hv(game.debug, "Event") and e and { "Event", string.format("%-7s", e.event) },
			hv(game.debug, "Button") and e and { "Button", string.format("%-9s", e.button) },
			hv(game.debug, "X") and e and { "X", string.format("%-3s", e.x) },
			hv(game.debug, "Y") and e and { "Y", string.format("%-3s", e.y) },
			hv(game.debug, "MemoryUsage")
				and { "Memory Usage", string.format("%-7d bytes", collectgarbage("count") * 1024) },
			hv(game.debug, "QueuedBriefs") and { "Queued Briefs", #game.queue },
			hv(game.debug, "ActiveBriefs") and { "Active Briefs", briefs and #briefs or 0 },
			hv(game.debug, "Ticks") and { "Ticks", game.sf },
		}
		utils:show_status(game, data)
	end
	if game.status_bar then
		local data = game.status_bar and game.status_bar or {}
		utils:show_status(game, data, game.debug and 1 or 0, "center")
	end
end

--- starts the main buble to handle incoming events and brief queue
--- @param game Game
function Core.start_main_loop(game)
	create_main_loop(math.floor(1000 / game.sf.frame_rate), function()
		local briefs = game.queue.dequeue(game.sf)
		if briefs then
			for _, brief in ipairs(briefs) do
				brief.ui_element:call_action(brief.action, brief.data)
			end
		end

		_build_status_bar(game, briefs)

		-- This is basically the clock of the game
		game.sf:increment()
	end)
end

--- Run uv
function Core.run()
	utils.console:setMode(1)
	utils.console:intoMouseMode()
	utils.console:write(string.format("%s%s", utils.cursor.hide, utils.clear.all))

	uv.run()
end

--- Exits the game.
function Core.exit(exit_message)
	local cons = utils.console
	local curs = utils.cursor

	cons:write("\x1b[2j\x1b[H") -- Clear the screen and returns the prompt to the top
	cons:setMode(0)
	cons:exitMouseMode()

	curs.goTo(1, 1)

	cons:write(curs.show)

	clear_main_loop()
	cons:close()

	if exit_message then
		print("\n" .. exit_message)
	end

	os.exit(0)
end

return Core
