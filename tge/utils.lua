local clock = os.clock
local utf8 = require("utf8")
local uv = require("luv")
local luabox = require("luabox")

--- @alias Timer {start: function, stop: function, close: function}

local initial_console = luabox.Console.new(luabox.util.getHandles())

--- This class holds the modules of the luabox library
--- @class Utils
local Utils = {
	clear = luabox.clear,
	colors = luabox.colors,
	console = initial_console,
	cursor = luabox.cursor,
	event = luabox.event,
	scroll = luabox.scroll,
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
		status_len = status_len + utf8.len(entry[1]) + utf8.len(tostring(entry[2])) + 7
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

--- Write in the screen checking the given boundaries
--- @param data string
--- @param pos Point
--- @param bound Boundaries
--- @param options {color: Color | nil, clear: boolean | nil} | nil
function Utils:simple_puts(data, pos, bound, options)
	local color = options and options.color or nil
	local clear = options and options.clear or false
	---@diagnostic disable-next-line: param-type-mismatch
	local fg = color and color.fg and self.colors.fg(color.fg) or ""
	---@diagnostic disable-next-line: param-type-mismatch
	local bg = color and color.bg and self.colors.bg(color.bg) or ""
	local rfg = color and color.fg and self.colors.resetFg or ""
	local rbg = color and color.bg and self.colors.resetBg or ""
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		-- TODO: take the background elements from the "state.static_collection.background"
		local fdata = clear and string.rep(" ", utf8.len(data) or 1) or data
		self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(pos.x, pos.y), fg, bg, fdata, rfg, rbg))
	end
end

--- Write in the screen checking the given boundaries
--- @param data string
--- @param from Point
--- @param to Point
--- @param options {color: Color | nil, clear: boolean | nil} | nil
function Utils:ortogonal_puts(data, from, to, options)
	local color = options and options.color or nil
	local clear = options and options.clear or false
	---@diagnostic disable-next-line: param-type-mismatch
	local fg = color and color.fg and self.colors.fg(color.fg) or ""
	---@diagnostic disable-next-line: param-type-mismatch
	local bg = color and color.bg and self.colors.bg(color.bg) or ""
	local rfg = color and color.fg and self.colors.resetFg or ""
	local rbg = color and color.bg and self.colors.resetBg or ""
	-- TODO: take the background elements from the "state.static_collection.background"
	local fdata = clear and string.rep(" ", utf8.len(data) or 1) or data
	-- If is a horizontal line
	if from.y == to.y then
		local line = string.rep(fdata, math.floor((to.x - from.x) / 2) + 1)
		self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(from.x, from.y), fg, bg, line, rfg, rbg))
	-- If is a vertical line
	elseif from.x == to.x then
		for i = from.y, to.y do
			self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(from.x, i), fg, bg, fdata, rfg, rbg))
		end
	-- else is a box
	else
		local line = string.rep(fdata, math.floor((to.x - from.x) / 2) + 1)
		self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(from.x, from.y), fg, bg, line, rfg, rbg))
		self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(from.x, to.y), fg, bg, line, rfg, rbg))
		for i = from.y + 1, to.y - 1 do
			self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(from.x, i), fg, bg, fdata, rfg, rbg))
			self.console:write(string.format("%s%s%s%s%s%s", self.cursor.goTo(to.x, i), fg, bg, fdata, rfg, rbg))
		end
	end
end

--- Write in the screen checking the given boundaries
--- @param data string | string[]
--- @param pos Point
--- @param bound Boundaries
--- @param options {color: Color | nil, align: boolean | nil, clear: boolean | nil} | nil
function Utils:puts(data, pos, bound, options)
	local color = options and options.color or nil
	local align = options and options.align or false
	local clear = options and options.clear or false
	---@diagnostic disable-next-line: param-type-mismatch
	local fg = color and color.fg and self.colors.fg(color.fg) or ""
	---@diagnostic disable-next-line: param-type-mismatch
	local bg = color and color.bg and self.colors.bg(color.bg) or ""
	local rfg = color and color.fg and self.colors.resetFg or ""
	local rbg = color and color.bg and self.colors.resetBg or ""
	local fpos = pos
	local fdata = {}
	if type(data) == "string" then
		table.insert(fdata, data)
	else
		fdata = { table.unpack(data) }
	end
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		if align then
			if pos.y + #fdata > bound.bottom then
				fpos.y = bound.bottom + 1 - #fdata
			end
		else
			for i, line in ipairs(fdata) do
				if pos.x + utf8.len(line) + 1 > bound.right then
					fdata[i] = string.sub(line, 1, bound.right + 1 - pos.x)
				end
			end
		end
		for i, line in ipairs(fdata) do
			-- TODO: take the background elements from the "state.static_collection.background"
			local fline = clear and string.rep(" ", utf8.len(line) or 1) or line
			local x = fpos.x
			if align and pos.x + utf8.len(line) > bound.right then
				x = bound.right + 1 - utf8.len(line)
			end
			if not align and fpos.y + i > bound.bottom + 1 then
				break
			end
			self.console:write(
				string.format("%s%s%s%s%s%s", self.cursor.goTo(x, fpos.y + i - 1), fg, bg, fline, rfg, rbg)
			)
		end
	end
end

return Utils
