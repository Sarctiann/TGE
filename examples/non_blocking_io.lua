local tge = require("tge")

local game = tge.game.New({
	width = 120,
	height = 40,
	frame_rate = 30,
})

local colors = tge.utils.colors
local q = game.queue
local t = tge.entities.ui.Text.new()
local ACTION = tge.entities.ui.ACTION

-- TODO: create a panel system
-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})
-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})
-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game:exit()
	elseif e.event and e.event ~= "press" then
		local x, y = e.x, e.y
		q:enqueue({
			action = ACTION.draw,
			ui_element = t,
			data = {
				start_point = { x = x, y = y },
				text = "Hello, World!",
				color = colors.blue,
			},
		})
	end
end

game:run()
