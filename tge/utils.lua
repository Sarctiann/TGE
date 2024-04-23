local clock = os.clock
local luabox = require("luabox")

--- @class Utils
Utils = {}

Utils.clear = luabox.clear
Utils.colors = luabox.colors
Utils.console = luabox.Console.new(luabox.util.getHandles())
Utils.cursor = luabox.cursor
Utils.event = luabox.event
Utils.scroll = luabox.scroll
Utils.luabox_util = luabox.util

--- function that sleep for the given cents of seconds
--- @param n number duration in cents of seconds
Utils.sleep = function(n)
	local t0 = clock()
	while clock() - t0 <= n / 100 do
	end
end

--- function that write the text on the given time in cents of seconds
--- @param write_fn function to put the text in the screen
--- @param text string to put in the screen
--- @param speed number in cents of seconds to write the text
Utils.write_as_human = function(write_fn, text, speed)
	for char = 1, #text - 1 do
		write_fn(text:sub(char, char))
		Utils.sleep(speed / #text)
	end
	write_fn(text:sub(#text, #text) .. "\n")
end

--- function that chacks if there are space to create the game window
--- @param width integer width of the window in characters
--- @param height integer height of the window in characters
Utils.checkDimensions = function(width, height)
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

return Utils
