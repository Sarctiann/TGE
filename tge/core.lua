local uv = require("luv")
local luabox = require("luabox")

--- @class Core
--- @field private create_main_loop fun(self: self, interval: integer, callback: function)
--- @field private clear_main_loop fun(self: self)
Core = {}

Core.clear = luabox.clear
Core.colors = luabox.colors
Core.console = luabox.Console.new(luabox.util.getHandles())
Core.cursor = luabox.cursor
Core.event = luabox.event
Core.scroll = luabox.scroll
Core.luabox_util = luabox.util

--- Creates the Main loop
function Core:create_main_loop(interval, callback)
	self.timer = uv.new_timer()
	self.timer:start(0, interval, function()
		callback()
	end)
end

--- Stops the Main Loop
function Core:clear_main_loop()
	self.timer:stop()
	self.timer:close()
end

--- function that chacks if there are space to create the game window
--- @param width integer width of the window in characters
--- @param height integer height of the window in characters
function Core.checkDimensions(width, height)
	local term_width, term_height = Core.console:getDimensions()
	if width > term_width or height > term_height then
		return false
	end
	return true
end

--- function that print the error and exit the program
--- @param err string error message
function Core:exit_with_error(err, ...)
	local f_err = string.format(err, ...)
	io.stderr:write(string.format("%sError: %s%s\n", self.colors.fg(self.colors.red), f_err, self.colors.resetFg))
	os.exit(1)
end

--- Initialize the envent handler
--- @param handler fun(event: (keyboardEvent | mouseEvent)): nil
function Core:make_event_handler(handler)
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
		local iter = self.luabox_util.StringIterator(table.concat(rest))
		local event = self.event.parse(first, iter)

		if event == nil then
			return
		end

		handler(event)
	end
	self.console.onData = event_loop
end

--- starts the main buble to handle incoming events and brief queue
--- @param frame_rate integer frames per second
--- @param queue Queue
--- @param sf SecondsFrames
function Core:start_main_loop(frame_rate, queue, sf)
	self:create_main_loop(math.floor(1000 / frame_rate), function()
		-- TODO: implement the real callback that draws on the screen

		print(sf)

		sf:increment()
	end)
end

--- Run uv
function Core:run()
	self.console:setMode(1)
	self.console:intoMouseMode()
	self.console:write(string.format("%s%s", self.cursor.hide, self.clear.all))

	uv.run()
end

--- Exits the game.
function Core:exit()
	local cons = self.console
	local curs = self.cursor

	cons:setMode(0)
	cons:exitMouseMode()
	cons:write("\x1b[2j\x1b[H") -- Clear the screen and returns the prompt to the top

	curs.goTo(1, 1)

	cons:write("\n")
	cons:write(curs.show)

	self:clear_main_loop()
	cons:close()

	os.exit()
end

return Core
