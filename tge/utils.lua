local clock = os.clock
local uv = require("luv")
local luabox = require("luabox")

--- @class Utils
--- @field private create_main_loop fun(self: Utils, interval: integer, callback: function)
--- @field private clear_main_loop fun(self: Utils)
Utils = {}

Utils.clear = luabox.clear
Utils.colors = luabox.colors
Utils.console = luabox.Console.new(luabox.util.getHandles())
Utils.cursor = luabox.cursor
Utils.event = luabox.event
Utils.scroll = luabox.scroll
Utils.luabox_util = luabox.util

--- Creates the Main loop
function Utils:create_main_loop(interval, callback)
	self.timer = uv.new_timer()
	self.timer:start(interval, interval, function()
		callback()
	end)
end

--- Stops the Main Loop
function Utils:clear_main_loop()
	self.timer:stop()
	self.timer:close()
end

--- A simple setTimeout wrapper
function Utils.setTimeout(timeout, callback)
	local timer = uv.new_timer()
	timer:start(timeout, 0, function()
		timer:stop()
		timer:close()
		callback()
	end)
	return timer
end

--- Run uv
function Utils.run()
	uv.run()
end

--- @deprecated
--- function that sleep for the given cents of seconds
--- @param n number duration in cents of seconds
function Utils.sleep(n)
	local t0 = clock()
	while clock() - t0 <= n / 100 do
	end
end

--- @deprecated
--- function that write the text on the given time in cents of seconds
--- @param write_fn function to put the text in the screen
--- @param text string to put in the screen
--- @param speed number in cents of seconds to write the text
function Utils.write_as_human_old(write_fn, text, speed)
	for char = 1, #text - 1 do
		write_fn(text:sub(char, char))
		--- @diagnostic disable-next-line: deprecated
		Utils.sleep(speed / #text)
	end
	write_fn(text:sub(#text, #text) .. "\n")
end

--- function that chacks if there are space to create the game window
--- @param width integer width of the window in characters
--- @param height integer height of the window in characters
function Utils.checkDimensions(width, height)
	local term_width, term_height = Utils.console:getDimensions()
	if width > term_width or height > term_height then
		return false
	end
	return true
end

--- function that print the error and exit the program
--- @param err string error message
function Utils:exit_with_error(err, ...)
	local f_err = string.format(err, ...)
	io.stderr:write(string.format("%sError: %s%s\n", self.colors.fg(self.colors.red), f_err, self.colors.resetFg))
	os.exit(1)
end

--- Initialize the envent handler
--- @param handler fun(event: (keyboardEvent | mouseEvent)): nil
function Utils:make_event_handler(handler)
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
--- @param queue Brief[]
function Utils:start_main_loop(frame_rate, queue)
	-- TODO: implement the real callback that draws on the screen
	local count = 0
	self:create_main_loop(math.floor(1000 / frame_rate), function()
		print(string.format("frame: %.4d", count))
		count = count + 1
	end)
end

--- Exits the game.
function Utils:exit()
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

return Utils
