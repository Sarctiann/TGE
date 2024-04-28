local uv = require("luv")
local Utils = require("tge.utils")

--- @class Core : Utils
--- @field private create_main_loop fun(self: self, interval: integer, callback: function)
--- @field private clear_main_loop fun(self: self)
Core = {}
Core.__index = Core
setmetatable(Core, Utils)

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
--- @param queue Queue
--- @param game_sf SecondsFrames
function Core:start_main_loop(queue, game_sf)
	self:create_main_loop(math.floor(1000 / game_sf.frame_rate), function()
		print(game_sf)

		local briefs = queue:dequeue(game_sf)
		if briefs then
			for _, brief in ipairs(briefs) do
				-- TODO: improve this part
				-- FIXME: Still not implemented go to ui_entities.lua
				brief.ui_element[brief.action](brief.data)
			end
		end

		game_sf:increment()
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
