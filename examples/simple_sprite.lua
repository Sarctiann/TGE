local tge = require("tge")

local game = tge.Game.new({
	width = 130,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{ "[w] [a] [s] [d] moves the tank [D] holds moving to right [x] stops it", "Mouse to teleport the Tank" },
	},
	debug = { "MemoryUsage", "Ticks", "Key", "Char", "X", "Y" },
})

local sprite_seq = tge.sequences.SpriteSeqs.new(game)
local ent = tge.entities

local Sprite, ORIENTATION = ent.ui.Sprite, ent.ui.ORIENTATION
local c1 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Black), " ", tge.utils.colors.resetBg)
local c2 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Red), "  ", tge.utils.colors.resetBg)
local c3 = string.format("%s%s%s", tge.utils.colors.bg(ent.ui.COLOR.Yellow), " ", tge.utils.colors.resetBg)

local s = Sprite.new({
	graph = {
		{ "", c2, "" },
		{ c2, c2, c2 },
		{ c2, "", c2 },
	},
	orientation = ORIENTATION.north,
	options = { lf = 5 },
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

s:set_random_graph({
	graph = {
		{ c1, c1, "" },
		{ "", c2, c2 },
		{ c3, c3, "" },
	},
	orientation = ORIENTATION.east,
})

sprite_seq.spawn(s, { x = 55, y = 20 }, ORIENTATION.north)

local c -- cancel signal var/flag | alternatively this could be initialized as an empty function

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game.exit("Just another step done")
	elseif e.char == "w" then
		sprite_seq.move_up_now(s, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "s" then
		sprite_seq.move_down_now(s, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "a" then
		sprite_seq.move_left_now(s, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "d" then
		sprite_seq.move_right_now(s, { oriented = true, cancel_tag = "keep_moving" })
	elseif e.char == "D" then
		c = sprite_seq.hold_moving_right(s, 5, { cancel_tag = "keep_moving" })
	elseif e.char == "x" and c then -- here we are checking that `c` has been initialized with the cleaner function
		c()
	elseif e.event and (e.event == "press" or e.event == "hold") then
		local x, y = e.x, e.y
		if x > 2 and x <= game.dimensions.width - 2 and y > 1 and y <= game.dimensions.height - 3 then
			sprite_seq.translate(s, x - 2, y - 1)
		end
	end
end

game:run()
