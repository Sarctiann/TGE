local tge = require("tge")

local game = tge.Game.new({
	width = 130,
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

local sprite_seq = tge.sequences.SpriteSeqs.new(game)
local ent = tge.entities

local Sprite, ORIENTATION = ent.ui.Sprite, ent.ui.ORIENTATION
local cc = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.White), "  ", tge.utils.colors.resetBg)
local c1 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Black), " ", tge.utils.colors.resetBg)
local c2 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Red), " ", tge.utils.colors.resetBg)
local c3 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Yellow), " ", tge.utils.colors.resetBg)

local function new_tank()
	local tank = Sprite.new({
		graph = {
			{ "", cc, "" },
			{ cc, cc, cc },
			{ cc, "", cc },
		},
		orientation = ORIENTATION.north,
		options = { lf = 5 },
	}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

	tank:set_random_graph({
		graph = {
			{ c1, c1, "" },
			{ "", c2, c2 },
			{ c3, c3, "" },
		},
		orientation = ORIENTATION.east,
	})

	local rand_x = math.random(1, game.dimensions.width - 6)
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
		sprite_seq.move_up_now(tank, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "s" then
		sprite_seq.move_down_now(tank, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "a" then
		sprite_seq.move_left_now(tank, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "d" then
		sprite_seq.move_right_now(tank, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "W" then
		cs = sprite_seq.hold_moving_up(tank, 5, { cancel_tag = "keep_moving" })
	elseif e.char == "A" then
		cs = sprite_seq.hold_moving_left(tank, 5, { cancel_tag = "keep_moving" })
	elseif e.char == "S" then
		cs = sprite_seq.hold_moving_down(tank, 5, { cancel_tag = "keep_moving" })
	elseif e.char == "D" then
		cs = sprite_seq.hold_moving_right(tank, 5, { cancel_tag = "keep_moving" })
	elseif e.char == "x" and cs then -- here we are checking that `c` has been initialized with the cleaner function
		cs()
	elseif e.char == "X" then
		sprite_seq.delete(tank, "keep_moving")
	elseif e.char == "n" and not tank.is_present then
		tank = new_tank()
	elseif e.event and (e.event == "press" or e.event == "hold") then
		local x, y = e.x, e.y
		if x > 2 and x <= game.dimensions.width - 2 and y > 1 and y <= game.dimensions.height - 3 then
			sprite_seq.translate(tank, x - 2, y - 1)
		end
	end
end

game:run()
