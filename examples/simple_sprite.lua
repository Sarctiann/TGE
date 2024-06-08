local tge = require("tge")

local game = tge.Game.new({
	width = 70,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{ "[wasd]", "moves the tank" },
		{ "[WASD]", "keep the tank moving" },
		{ "[x]", "stops it" },
		{ "Mouse", "teleports the Tank" },
	},
	debug = { "MemoryUsage", "Ticks", "Key", "Char", "X", "Y" },
})
game.add_layer("BGLayer")
game.add_layer("PlayerLayer")
game.add_layer("FGLayer")

local sprite_seq = game.get_sprite_seqs()
local ui = tge.entities.ui

local Sprite, Line, ORIENTATION, ACTION = ui.Sprite, ui.Line, ui.ORIENTATION, ui.ACTION
local cc = string.format("%s%s%s", tge.utils.colors.bg(ui.COLOR.LightRed), "  ", tge.utils.colors.resetBg)
local c1 = string.format("%s%s%s", tge.utils.colors.bg(ui.COLOR.Black), " ", tge.utils.colors.resetBg)
local c2 = string.format("%s%s%s", tge.utils.colors.bg(ui.COLOR.Red), " ", tge.utils.colors.resetBg)
local c3 = string.format("%s%s%s", tge.utils.colors.bg(ui.COLOR.Yellow), " ", tge.utils.colors.resetBg)

local line1 = Line.new({
	unit = "  ",
	from = { x = 1, y = 20 },
	to = { x = 70, y = 20 },
	color = { bg = ui.COLOR.LightGreen },
	target_layer = "BGLayer",
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

local line2 = Line.new({
	unit = "  ",
	from = { x = 35, y = 1 },
	to = { x = 35, y = 38 },
	color = { bg = ui.COLOR.LightBlue },
	target_layer = "FGLayer",
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

game.queue.enqueue({
	ui_element = line1,
	action = ACTION.draw,
	when = game.sf,
})

game.queue.enqueue({
	ui_element = line2,
	action = ACTION.draw,
	when = game.sf,
})

local function new_tank()
	local tank = Sprite.new({
		graph = {
			{ "", cc, "" },
			{ cc, cc, cc },
			{ cc, "", cc },
		},
		orientation = ORIENTATION.north,
		options = { lf = 5, target_layer = "PlayerLayer" },
	}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

	tank:set_random_graph({
		graph = {
			{ c1, c1, "" },
			{ "", c2, c2 },
			{ c3, c3, "" },
		},
		orientation = ORIENTATION.east,
	})

	local rand_x = math.random(1, game.dimensions.width - 7)
	local rand_y = math.random(1, game.dimensions.height - 7)
	local rand_orientation = math.random(1, 4)
	sprite_seq.spawn(tank, { x = rand_x, y = rand_y }, rand_orientation)
	return tank
end

local tank = new_tank()
local cs -- cancel signal var/flag | alternatively this could be initialized as an empty function

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game.exit("Not a game yet")
	elseif e.char == "w" then
		sprite_seq.move_up_now(tank, { oriented = true, cancel_tags = "keep_moving" })
	elseif e.char == "s" then
		sprite_seq.move_down_now(tank, { oriented = true, cancel_tags = "keep_moving" })
	elseif e.char == "a" then
		sprite_seq.move_left_now(tank, { oriented = true, cancel_tags = "keep_moving" })
	elseif e.char == "d" then
		sprite_seq.move_right_now(tank, { oriented = true, cancel_tags = "keep_moving" })
	elseif e.char == "W" then
		cs = sprite_seq.hold_moving_up(tank, 5, { cancel_tags = "keep_moving" })
	elseif e.char == "A" then
		cs = sprite_seq.hold_moving_left(tank, 5, { cancel_tags = "keep_moving" })
	elseif e.char == "S" then
		cs = sprite_seq.hold_moving_down(tank, 5, { cancel_tags = "keep_moving" })
	elseif e.char == "D" then
		cs = sprite_seq.hold_moving_right(tank, 5, { cancel_tags = "keep_moving" })
	elseif e.char == "x" and cs then -- here we are checking that `c` has been initialized with the cleaner function
		cs()
	elseif e.char == "X" then
		sprite_seq.delete(tank, "keep_moving")
	elseif e.char == "G" then
		game.create_sequence({ 7, 9, 5 }, {
			{ ui_element = tank, action = ACTION.move, when = game.sf, data = { pos = 1, orientation = 1 } },
			{ ui_element = tank, action = ACTION.move, when = game.sf, data = { pos = 2, orientation = 2 } },
			{ ui_element = tank, action = ACTION.move, when = game.sf, data = { pos = 3, orientation = 3 } },
			{ ui_element = tank, action = ACTION.move, when = game.sf, data = { pos = 4, orientation = 4 } },
		}, nil, true)
	elseif e.char == "n" and not tank.is_present then
		tank = new_tank()
	elseif e.event and (e.event == "press" or e.event == "hold") then
		local x, y = e.x, e.y
		if x > 2 and x <= game.dimensions.width - 1 and y > 1 and y <= game.dimensions.height - 3 then
			sprite_seq.translate(tank, x - 1, y - 1)
		end
	end
end

game:run()
