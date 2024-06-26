local tge = require("tge")

local game = tge.Game.new({
	width = 80,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{
			"Do something with",
			"[\u{f037d}] | [Ctrl+c] \u{f0a48} | [c] \u{f1556} | [d] \u{f05a} | [a] \u{f11c4} | [\u{ea9b}] [\u{ea9a}] [\u{eaa1}] [\u{ea9c}] | hjkl |",
		},
	},
	-- This will consume some memory bytes
	debug = { "X", "Y", "QueuedBriefs", "ActiveBriefs", "MemoryUsage", "Ticks" },
})
game.add_layer("ui")

local SecondsFrames = tge.entities.SecondsFrames
local ui = tge.entities.ui
local ACTION, COLOR, DIRECTION = ui.ACTION, ui.COLOR, ui.DIRECTION
local Text, Line, Box = ui.Text, ui.Line, ui.Box
local q = game.queue

local details = false

local function get_text()
	local text = details
			and {
				"Terminal Game Engine",
				"Is a text based engine that provides a high",
				"level api to asynchronously read and write in to the terminal screen",
			}
		or "TGE"
	details = not details
	return text
end

local aligned = false

local function toggle_align()
	aligned = not aligned
	return aligned
end

-- CREATION OF THE UI ELEMENTS
local t = Text.new({
	text = get_text(),
	options = {
		color = { fg = COLOR.Cyan, bg = COLOR.LightBlack },
		lf = 7,
	},
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

local l1 = Line.new({
	unit = "  ",
	from = { x = 40, y = 10 },
	to = { x = 40, y = 30 },
	color = { bg = COLOR.Red },
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

local l2 = Line.new({
	unit = "  ",
	from = { x = 45, y = 24 },
	to = { x = 80, y = 24 },
	color = { bg = COLOR.Red },
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

local b = Box.new({
	unit = "  ",
	from = { x = 70, y = 10 },
	to = { x = 80, y = 20 },
	color = { bg = COLOR.Green },
}, tge.entities.Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

-- SCHDULE SOME UI ELEMENTS BRIEFS
q.enqueue({
	action = ACTION.draw,
	when = SecondsFrames.from_frames(30, game.frame_rate),
	ui_element = t,
	data = { pos = { x = 13, y = 5 } },
})

q.enqueue({
	action = ACTION.move,
	when = SecondsFrames.from_frames(90, game.frame_rate),
	ui_element = t,
	data = { pos = DIRECTION.down },
}, { unlocked = true })

q.enqueue({
	action = ACTION.draw,
	when = game.sf,
	ui_element = l1,
})

q.enqueue({
	action = ACTION.draw,
	when = game.sf,
	ui_element = l2,
})

q.enqueue({
	action = ACTION.clear,
	when = SecondsFrames.from_frames(120, game.frame_rate),
	ui_element = l1,
})

q.enqueue({
	action = ACTION.draw,
	when = SecondsFrames.from_frames(70, game.frame_rate),
	ui_element = b,
})

-- EVENT HANDLING
game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game.exit("Good Bye")
	elseif e.char == "d" then
		q.enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				text = get_text(),
			},
		})
	elseif e.char == "a" then
		q.enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				options = { align = toggle_align() },
			},
		})
	elseif e.char == "c" then
		q.enqueue({
			action = ACTION.clear,
			when = game.sf + SecondsFrames.from_frames(15, game.frame_rate),
			ui_element = t,
		})
	elseif e.key == "up" or e.key == "down" or e.key == "left" or e.key == "right" then
		q.enqueue({
			action = ACTION.move,
			when = game.sf,
			ui_element = t,
			data = {
				pos = DIRECTION[e.key],
			},
		})
	elseif e.event and e.event ~= "press" then
		local x, y = e.x, e.y
		if x > 0 and x <= game.dimensions.width and y <= game.dimensions.height - 2 then
			q.enqueue({
				action = ACTION.move,
				when = game.sf,
				ui_element = t,
				data = {
					pos = { x = x, y = y },
				},
			})
			-- else
			-- 	tge.utils:exit_with_error("Trying to write out of bound")
		end
	end
end

game:run()
