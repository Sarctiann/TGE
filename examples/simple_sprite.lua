local tge = require("tge")

local game = tge.Game.new({
	width = 90,
	height = 45,
	debug = { "Key", "MemoryUsage", "Ticks", "Char" },
	frame_rate = 30,
})

local ent = tge.entities
local Sprite, ACTION = ent.ui.Sprite, ent.ui.ACTION
local cu = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Cyan), "  ", tge.utils.colors.resetFg)

local s = Sprite.new({
	graph = {
		{ "", cu, "" },
		{ cu, cu, cu },
		{ cu, "", cu },
	},
	orientation = ent.ui.ORIENTATION.north,
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 1))

game.queue.enqueue({
	action = ACTION.draw,
	data = { pos = { x = 40, y = 20 } },
	when = game.sf,
	ui_element = s,
})

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game.exit()
	elseif e.char == "w" then
		game.queue.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = s,
			data = { pos = ent.ui.DIRECTION.up },
		})
	end
end

game:run()
