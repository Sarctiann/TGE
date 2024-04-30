local tge = require("tge")

local game = tge.game.new({
	width = 150,
	height = 40,
	frame_rate = 30,
	show_status = { Author = "Sarctiann" },
	debug = true,
})

local ui = tge.entities.ui
local q = game.queue
local Text, ACTION, COLOR = ui.Text, ui.ACTION, ui.COLOR

-- TODO: create a panel system
-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})
-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})
-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

local t = Text.new({
	text = "TGE",
	color = { fg = ui.truecolor(52, 52, 52), bg = COLOR.Yellow },
	lf = 10,
})

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game:exit()
	elseif e.event and e.event ~= "press" then
		local x, y = e.x, e.y
		if x <= game.dimensions.width and y <= game.dimensions.height then
			q:enqueue({
				action = ACTION.move,
				when = game.sf,
				ui_element = t,
				data = {
					pos = { x = x - 1, y = y - 1 },
				},
			})
		end
	end
end

game:run()
