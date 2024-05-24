-- local SecondsFrames = require("tge.entities.seconds_frames")
local utils = require("tge.utils")
local ui = require("tge.entities.ui_entities")

-- local nsf = SecondsFrames.from_frames

--- @class SpriteSeqOptions
--- @field oriented boolean | nil

local function spawn(game, sprite, position, orientation)
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = position, orientation = orientation },
		action = ui.ACTION.draw,
	})
end

local function translate(game, sprite, x, y)
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = { x = x, y = y } },
		action = ui.ACTION.move,
	})
end

local function move_up_now(game, sprite, options)
	local orientation = options and options.oriented and ui.ORIENTATION.north or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.up, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_down_now(game, sprite, options)
	local orientation = options and options.oriented and ui.ORIENTATION.south or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.down, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_left_now(game, sprite, options)
	local orientation = options and options.oriented and ui.ORIENTATION.west or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.left, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_right_now(game, sprite, options)
	local orientation = options and options.oriented and ui.ORIENTATION.east or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.right, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function hold_moving_right(game, sprite, frames)
	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.right, orientation = ui.ORIENTATION.east },
			action = ui.ACTION.move,
		}, { unlocked = true })
	end)

	return function()
		utils.clear_timer(seq)
	end
end

--- @param game Game
local function new(game)
	local self = {
		--- @type fun(sprite: Sprite, position: Point, orientation: ORIENTATION): nil
		spawn = function(sprite, position, orientation)
			spawn(game, sprite, position, orientation)
		end,

		--

		--- @type fun(sprite: Sprite, x: number, y: number): nil
		translate = function(sprite, x, y)
			translate(game, sprite, x, y)
		end,

		--

		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_up_now = function(sprite, options)
			move_up_now(game, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_down_now = function(sprite, options)
			move_down_now(game, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_left_now = function(sprite, options)
			move_left_now(game, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_right_now = function(sprite, options)
			move_right_now(game, sprite, options)
		end,

		--

		--- @type fun(sprite: Sprite, frames: number): function Returns the timer clear function
		hold_moving_right = function(sprite, frames)
			return hold_moving_right(game, sprite, frames)
		end,
	}

	return self
end

return { new = new }
