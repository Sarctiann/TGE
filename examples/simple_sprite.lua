local tge = require("tge")

local game = tge.Game.new({
	width = 110,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{ "Use the keys [w] [a] [s] [d] to move the tank", "and the mouse to teleport it to another location" },
	},
	debug = { "MemoryUsage", "Ticks", "Key", "Char", "X", "Y" },
})

local ent = tge.entities
local Sprite, ACTION = ent.ui.Sprite, ent.ui.ACTION
local c1 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Cyan), "  ", tge.utils.colors.resetBg)
local c2 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Green), "  ", tge.utils.colors.resetBg)
local c3 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Red), "  ", tge.utils.colors.resetBg)

local s = Sprite.new({
	graph = {
		{ c1, c1, "" },
		{ "", c1, c1 },
		{ c1, c1, "" },
	},
	orientation = ent.ui.ORIENTATION.east,
	options = { lf = 5 },
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

s:set_random_graph({
	graph = {
		{ "", c2, "" },
		{ c1, c2, c1 },
		{ c1, "", c1 },
	},
	orientation = ent.ui.ORIENTATION.north,
})

s:set_random_graph({
	graph = {
		{ c1, "", c1 },
		{ c1, c3, c1 },
		{ "", c3, "" },
	},
	orientation = ent.ui.ORIENTATION.south,
})

game.queue.enqueue({
	action = ACTION.draw,
	data = { pos = { x = 55, y = 20 }, orientation = ent.ui.ORIENTATION.north },
	when = game.sf,
	ui_element = s,
})

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game.exit("Just another step done")
	elseif e.char == "w" then
		game.queue.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = s,
			data = { pos = ent.ui.DIRECTION.up, orientation = ent.ui.ORIENTATION.north },
		})
	elseif e.char == "s" then
		game.queue.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = s,
			data = { pos = ent.ui.DIRECTION.down, orientation = ent.ui.ORIENTATION.south },
		})
	elseif e.char == "a" then
		game.queue.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = s,
			data = { pos = ent.ui.DIRECTION.left, orientation = ent.ui.ORIENTATION.west },
		})
	elseif e.char == "d" then
		game.queue.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = s,
			data = { pos = ent.ui.DIRECTION.right, orientation = ent.ui.ORIENTATION.east },
		})
	elseif e.event and (e.event == "press" or e.event == "hold") then
		local x, y = e.x, e.y
		if x > 2 and x <= game.dimensions.width - 2 and y > 1 and y <= game.dimensions.height - 3 then
			game.queue.enqueue({
				action = ACTION.move,
				when = game.sf,
				ui_element = s,
				data = {
					pos = { x = x - 2, y = y - 1 },
				},
			})
		end
	end
end

game:run()
