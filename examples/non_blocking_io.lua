local tge = require("tge")

local game = tge.New({
	width = 120,
	height = 40,
	frame_rate = 30,
})

-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})

-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})

-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

game.on_event = function(event)
	if event.key == "ctrl" and event.char == "c" then
		game:exit()
	end
end

game:run()
