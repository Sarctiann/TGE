local tge = require("tge")

local game = tge.New({
	width = 120,
	height = 40,
	frame_rate = 30,
})
-- We Also need to pass the frame rate

print(game.dimensions)
-- print(game.frame_rate)

-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})

-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})

-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

-- game.on_init = function() my_game_init() end

-- game.on_events = function(event) my_game_handle(event) end

-- game.run()
