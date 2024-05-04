local tge = require("tge")
local SecondsFrames = require("tge.entities.seconds_frames")
local utils = require("tge.utils")

local game = tge.game.new({
	width = 160,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{
			"Do something with",
			"[\u{f037d}] | [Ctrl+c] \u{f0a48} | [c] \u{f1556} | [d] \u{f05a} | [a] \u{f11c4} | [\u{ea9b}] [\u{ea9a}] [\u{eaa1}] [\u{ea9c}] |",
		},
	},
	debug = true,
})

local ui = tge.entities.ui
local q = game.queue
local Text, ACTION, COLOR, DIRECTION = ui.Text, ui.ACTION, ui.COLOR, utils.DIRECTION

-- TODO: create a panel system
-- game.add_panel({1, 1 90, 38}, {id = "scene", with_border = "double", title = "My Game", title_align = "left"})
-- game.add_panel({91, 1 120, 38}, {id = "chat", with_border = "solid", title = "Chat", title_align = "left"})
-- game.add_panel({1, 39, 120, 40}, {id = "status", with_border = "line"})

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

local t = Text.new({
	text = get_text(),
	options = {
		color = { fg = COLOR.Cyan, bg = COLOR.LightBlack },
		lf = 7,
	},
}, Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game:exit()
	elseif e.char == "d" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				text = get_text(),
			},
		})
	elseif e.char == "a" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				options = { align = toggle_align() },
			},
		})
	elseif e.char == "c" then
		q:enqueue({
			action = ACTION.clear,
			when = game.sf + SecondsFrames.from_frames(15, 30),
			ui_element = t,
			data = {},
		})
	elseif e.key == "up" or e.key == "down" or e.key == "left" or e.key == "right" then
		q:enqueue({
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
			q:enqueue({
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
