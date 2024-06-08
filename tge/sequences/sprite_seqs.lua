-- local SecondsFrames = require("tge.entities.seconds_frames")
local utils = require("tge.utils")
local ui = require("tge.entities.ui_entities")
local base = require("tge.sequences.base_sequence")

-- local nsf = SecondsFrames.from_frames

--- @class SpriteSeqOptions
--- @field oriented boolean | nil
--- @field cancel_tags string | string[] | nil

local function spawn(game, sprite, position, orientation)
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = position, orientation = orientation },
		action = ui.ACTION.draw,
	})
end

local function delete(game, sprite, cancel_tags)
	base.cancel_tags(cancel_tags)

	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		action = ui.ACTION.clear,
	})
end

local function translate(game, sprite, x, y, options)
	local cancel_tags = options and options.cancel_tags
	base.cancel_tags(cancel_tags)

	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = { x = x, y = y } },
		action = ui.ACTION.move,
	})
end

local function move_up_now(game, sprite, options)
	local cancel_tags = options and options.cancel_tags
	base.cancel_tags(cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.north or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.up, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_down_now(game, sprite, options)
	local cancel_tags = options and options.cancel_tags
	base.cancel_tags(cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.south or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.down, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_left_now(game, sprite, options)
	local cancel_tags = options and options.cancel_tags
	base.cancel_tags(cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.west or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.left, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_right_now(game, sprite, options)
	local cancel_tags = options and options.cancel_tags
	base.cancel_tags(cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.east or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.right, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function hold_moving_up(game, sprite, frames, cancel_tags)
	base.cancel_tags(cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.up, orientation = ui.ORIENTATION.north },
			action = ui.ACTION.move,
		})
	end, true)

	if cancel_tags then
		base.register_cancel_tags(cancel_tags, seq)
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_down(game, sprite, frames, cancel_tags)
	base.cancel_tags(cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.down, orientation = ui.ORIENTATION.south },
			action = ui.ACTION.move,
		})
	end, true)

	if cancel_tags then
		base.register_cancel_tags(cancel_tags, seq)
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_left(game, sprite, frames, cancel_tags)
	base.cancel_tags(cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.left, orientation = ui.ORIENTATION.west },
			action = ui.ACTION.move,
		})
	end, true)

	if cancel_tags then
		base.register_cancel_tags(cancel_tags, seq)
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_right(game, sprite, frames, cancel_tags)
	base.cancel_tags(cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.right, orientation = ui.ORIENTATION.east },
			action = ui.ACTION.move,
		})
	end, true)

	if cancel_tags then
		base.register_cancel_tags(cancel_tags, seq)
	end

	return function()
		utils.clear_timer(seq)
	end
end

--- @param game Game
local function new(game)
	--- @class SpriteSequences
	local self = {
		--- @type fun(sprite: Sprite, position: Point, orientation: ORIENTATION): nil
		spawn = function(sprite, position, orientation)
			spawn(game, sprite, position, orientation)
		end,
		--- @type fun(sprite: Sprite, cancel_tags: string | nil): nil
		delete = function(sprite, cancel_tags)
			delete(game, sprite, cancel_tags)
		end,

		--

		--- @type fun(sprite: Sprite, x: number, y: number, options: SpriteSeqOptions | nil): nil
		translate = function(sprite, x, y, options)
			translate(game, sprite, x, y, options)
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

		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_up = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_up(game, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_down = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_down(game, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_left = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_left(game, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_right = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_right(game, sprite, frames, cancel_tags)
		end,

		--

		--- Cancels all sequences if no `tag_or_tags` is provided
		--- @type fun(cancel_tags: string | string[] | nil): nil
		cancel_sequences = base.cancel_sequences,
	}

	return self
end

return { new = new }
