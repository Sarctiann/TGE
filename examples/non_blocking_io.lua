local tge = require("tge")

local game = tge.game.New({
	width = 120,
	height = 40,
	frame_rate = 30,
})

local ui = tge.entities.ui
local q = game.queue
local Text, ACTION, COLOR = ui.Text, ui.ACTION, ui.COLOR

-- TODO: create a panel system
-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})
-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})
-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

local t = Text.New({
	text = "TGE\n",
	color = { fg = COLOR.Black, bg = COLOR.Yellow },
})

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game:exit()
	elseif e.event and e.event ~= "press" then
		local x, y = e.x, e.y
		q:enqueue({
			action = ACTION.move,
			ui_element = t,
			data = {
				pos = { x = x - 1, y = y },
			},
		})
	end
end

game:run()
