local tge = require("tge")
local SecondsFrames = require("tge.entities.seconds_frames")

local game = tge.game.new({
	width = 160,
	height = 40,
	frame_rate = 30,
	status_bar = {
		{
			"Listen Keys",
			"Ctrl+c \u{f0a48} | c \u{f1da} 10fr \u{eabf} | h \u{f13a7} | H \u{f13a3} | a \u{f038} | A \u{f036} |",
		},
	},
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
	options = {
		color = { fg = COLOR.Cyan, bg = COLOR.LightBlack },
		lf = 1,
	},
}, Boundaries.new(1, 1, game.dimensions.width, game.dimensions.height - 2))

local message = {
	"Terminal Game Engine",
	"Is a text based engine that provides a high",
	"level api to asynchronously read and write in to the terminal screen",
}

game.on_event = function(e)
	if e.key == "ctrl" and e.char == "c" then
		game:exit()
	elseif e.char == "H" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				text = "TGE",
			},
		})
	elseif e.char == "h" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				text = message,
			},
		})
	elseif e.char == "A" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				options = { align = false },
			},
		})
	elseif e.char == "a" then
		q:enqueue({
			action = ACTION.update,
			when = game.sf,
			ui_element = t,
			data = {
				options = { align = true },
			},
		})
	elseif e.char == "c" then
		q:enqueue({
			action = ACTION.clear,
			when = game.sf + SecondsFrames.from_frames(15, 30),
			ui_element = t,
			data = {},
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
