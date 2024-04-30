local clock = os.clock
local uv = require("luv")
local luabox = require("luabox")

--- @alias Timer {start: function, stop: function, close: function}

--- @class Utils
local Utils = {}
Utils.__index = Utils

Utils.clear = luabox.clear
Utils.colors = luabox.colors
Utils.console = luabox.Console.new(luabox.util.getHandles())
Utils.cursor = luabox.cursor
Utils.event = luabox.event
Utils.scroll = luabox.scroll
Utils.luabox_util = luabox.util

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

--- Initialize a timer to call a function periodically
--- @param interval integer time in milliseconds
--- @param callback function the function to be executed
--- @param asap boolean | nil (as soon as possible) will run the callback once
--- @return Timer timer a luv Timer userdata (pass it to clear_timer to terminate it)
function Utils.set_interval(interval, callback, asap)
	local timer = uv.new_timer()
	timer:start(asap and 0 or interval, interval, function()
		callback()
	end)
	return timer
end

--- Terminates a Timer
--- @param timer Timer the timer to be terminated
--- @return nil
function Utils.clear_timer(timer)
	timer:stop()
	timer:close()
end

--- Waits for the given time to run the callback
--- @param timeout integer the time before the callback execution
--- @param callback function the function to be executed
--- @return Timer timer a luv Timer userdata (pass it to clear_timer to terminate it)
function Utils.set_timeout(timeout, callback)
	local timer = uv.new_timer()
	timer:start(timeout, 0, function()
		timer:stop()
		timer:close()
		callback()
	end)
	return timer
end

--- function that print the error and exit the program
--- @param err string error message
function Utils:exit_with_error(err, ...)
	local f_err = string.format(err, ...)
	io.stderr:write(string.format("%sError: %s%s\n", self.colors.fg(self.colors.red), f_err, self.colors.resetFg))

	local cons = self.console
	local curs = self.cursor

	cons:setMode(0)
	cons:exitMouseMode()
	cons:write("\n")
	cons:write(curs.show)
	cons:close()

	os.exit(1)
end

--- @param game Game
--- @vararg any
function Utils:show_status(game, data)
	local x, y = game.dimensions.width, game.dimensions.height
	local position = self.cursor.goTo(1, y)
	local color = self.colors.fg(self.colors.black) .. self.colors.bg(self.colors.white)

	local status = {}
	local status_len = 0
	for k, v in pairs(data) do
		table.insert(
			status,
			string.format(
				"%s %s: %s %s",
				self.colors.bg(self.colors.lightWhite),
				k,
				self.colors.bg(self.colors.white),
				v
			)
		)
		status_len = status_len + #k + #tostring(v) + 6
	end

	local status_str = table.concat(status, " | ")
	local line = string.rep(" ", x - 6 - status_len)
	local reset = self.colors.resetFg .. self.colors.resetBg

	self.console:write(string.format("%s%s%s| %s |  %s", position, color, line, status_str, reset))
end

-- TODO: create secure writer (that checks the game dimensions before write)

--- Write in the screen checking the given boundaries
--- @param data string -- TODO: should be string[]
--- @param pos Point
--- @param bound Boundaries
--- @param align boolean | nil
function Utils:puts(data, pos, bound, align)
	align = align or false
	local fpos = pos
	local fdata = data
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		if align then
			fpos.x = bound.right - pos.x <= #data and pos.x or bound.right - #data
			-- TODO: align pos.y
			fdata = string.sub(data, 1, bound.right)
		else
			fdata = string.sub(data, 1, bound.right - pos.x + 1)
		end
		self.console:write(string.format("%s%s", self.cursor.goTo(fpos.x, fpos.y), fdata))
	else
		self:exit_with_error("trying to write out of bound")
	end
end

return Utils
