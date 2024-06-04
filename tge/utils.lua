local clock = os.clock
local utf8 = require("utf8")
local uv = require("luv")
local luabox = require("luabox")

--- @alias Timer {start: function, stop: function, close: function, is_active: function}

local initial_console = luabox.Console.new(luabox.util.getHandles())

--- This class holds the modules of the luabox library
--- @class Utils
local Utils = {
	clear = luabox.clear,
	colors = luabox.colors,
	console = initial_console,
	cursor = luabox.cursor,
	event = luabox.event,
	luabox_util = luabox.util,
}

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
	if timer and timer:is_active() then
		timer:stop()
		timer:close()
	end
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
	io.stderr:write(string.format("\n%sError: %s%s\n", self.colors.fg(self.colors.red), f_err, self.colors.resetFg))

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
--- @param data table
--- @param y_offset integer | nil
--- @param align 'left' | 'right' | 'center' | nil
function Utils:show_status(game, data, y_offset, align)
	local x, y = game.dimensions.width, game.dimensions.height
	if y_offset then
		y = y - y_offset
	end

	local position = self.cursor.goTo(1, y)
	local color = self.colors.fg(self.colors.cyan) .. self.colors.bg(self.colors.black)

	local status = {}
	local status_len = -3
	for _, entry in pairs(data) do
		table.insert(
			status,
			string.format(
				"%s %s: %s %s",
				self.colors.bg(self.colors.lightBlack),
				entry[1],
				self.colors.bg(self.colors.black),
				entry[2]
			)
		)
		status_len = status_len + utf8.len(tostring(entry[1])) + utf8.len(tostring(entry[2])) + 7
	end

	local status_str = table.concat(status, " | ")
	local line = string.rep(" ", x - 2 - status_len)
	local reset = self.colors.resetFg .. self.colors.resetBg
	if align and align == "left" then
		self.console:write(string.format("%s%s%s%s  %s", position, color, status_str, line, reset))
	elseif align and align == "center" then
		local half_l1 = string.sub(line, 1, math.floor(#line / 2))
		local half_l2 = string.sub(line, 1, math.ceil(#line / 2))
		self.console:write(string.format("%s%s%s%s%s  %s", position, color, half_l1, status_str, half_l2, reset))
	else
		self.console:write(string.format("%s%s%s%s  %s", position, color, line, status_str, reset))
	end
end

function Utils.has_value_or_nil(tab, val)
	for _, value in pairs(tab) do
		if value == val then
			return true
		end
	end
end

function Utils.flip_verticaly(graph)
	local new_graph = {}
	for i = 1, #graph do
		new_graph[i] = graph[#graph - i + 1]
	end
	return new_graph
end

function Utils.rotate_left(graph)
	local new_graph = {}
	for i = 1, #graph do
		new_graph[i] = {}
		for j = 1, #graph do
			table.insert(new_graph[i], graph[j][#graph - i + 1])
		end
	end
	return new_graph
end

function Utils.flip_horizontaly(graph)
	local new_graph = {}
	for i = 1, #graph do
		new_graph[i] = {}
		for j = 1, #graph do
			table.insert(new_graph[i], graph[i][#graph - j + 1])
		end
	end
	return new_graph
end

Utils.async_split_text_into_units = function(text)
	return coroutine.wrap(function()
		for i = 1, #text, 2 do
			local fst = text:sub(i, i)
			local scd = text:sub(i + 1, i + 1)
			coroutine.yield(fst .. (scd ~= "" and scd or " "))
		end
	end)
end

return Utils
