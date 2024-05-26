-- local SecondsFrames = require("tge.entities.seconds_frames")
local utils = require("tge.utils")
local ui = require("tge.entities.ui_entities")

-- local nsf = SecondsFrames.from_frames

--- @class SpriteSeqOptions
--- @field oriented boolean | nil
--- @field cancel_tags string | string[] | nil

local function _cancel_tags(cancel_tbl, cancel_tags)
	if type(cancel_tags) == "table" then
		for _, v in pairs(cancel_tags) do
			if cancel_tbl[v] then
				utils.clear_timer(cancel_tbl[v])
			end
		end
	elseif type(cancel_tags) == "string" then
		if cancel_tbl[cancel_tags] then
			utils.clear_timer(cancel_tbl[cancel_tags])
		end
	end
end

local function spawn(game, sprite, position, orientation)
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = position, orientation = orientation },
		action = ui.ACTION.draw,
	})
end

local function delete(game, cancel_tbl, sprite, cancel_tags)
	_cancel_tags(cancel_tbl, cancel_tags)

	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		action = ui.ACTION.clear,
	})
end

local function translate(game, cancel_tbl, sprite, x, y, options)
	local cancel_tags = options and options.cancel_tags
	_cancel_tags(cancel_tbl, cancel_tags)

	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = { x = x, y = y } },
		action = ui.ACTION.move,
	})
end

local function move_up_now(game, cancel_tbl, sprite, options)
	local cancel_tags = options and options.cancel_tags
	_cancel_tags(cancel_tbl, cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.north or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.up, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_down_now(game, cancel_tbl, sprite, options)
	local cancel_tags = options and options.cancel_tags
	_cancel_tags(cancel_tbl, cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.south or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.down, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_left_now(game, cancel_tbl, sprite, options)
	local cancel_tags = options and options.cancel_tags
	_cancel_tags(cancel_tbl, cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.west or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.left, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function move_right_now(game, cancel_tbl, sprite, options)
	local cancel_tags = options and options.cancel_tags
	_cancel_tags(cancel_tbl, cancel_tags)

	local orientation = options and options.oriented and ui.ORIENTATION.east or nil
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.right, orientation = orientation },
		action = ui.ACTION.move,
	})
end

local function hold_moving_up(game, cancel_tbl, sprite, frames, cancel_tags)
	_cancel_tags(cancel_tbl, cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.up, orientation = ui.ORIENTATION.north },
			action = ui.ACTION.move,
		}, { unlocked = true })
	end)

	if cancel_tags then
		cancel_tbl[cancel_tags] = seq
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_down(game, cancel_tbl, sprite, frames, cancel_tags)
	_cancel_tags(cancel_tbl, cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.down, orientation = ui.ORIENTATION.south },
			action = ui.ACTION.move,
		}, { unlocked = true })
	end)

	if cancel_tags then
		cancel_tbl[cancel_tags] = seq
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_left(game, cancel_tbl, sprite, frames, cancel_tags)
	_cancel_tags(cancel_tbl, cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.left, orientation = ui.ORIENTATION.west },
			action = ui.ACTION.move,
		}, { unlocked = true })
	end)

	if cancel_tags then
		cancel_tbl[cancel_tags] = seq
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function hold_moving_right(game, cancel_tbl, sprite, frames, cancel_tags)
	_cancel_tags(cancel_tbl, cancel_tags)

	local seq = utils.set_interval(math.floor(1000 / game.frame_rate * frames), function()
		game.queue.enqueue({
			ui_element = sprite,
			when = game.sf,
			data = { pos = ui.DIRECTION.right, orientation = ui.ORIENTATION.east },
			action = ui.ACTION.move,
		}, { unlocked = true })
	end)

	if cancel_tags then
		cancel_tbl[cancel_tags] = seq
	end

	return function()
		utils.clear_timer(seq)
	end
end

local function cancel_sequences(cancel_tbl, cancel_tags)
	if not cancel_tags then
		for _, v in pairs(cancel_tbl) do
			utils.clear_timer(v)
		end
	else
		_cancel_tags(cancel_tbl, cancel_tags)
	end
end

--- @param game Game
local function new(game)
	local cancel_table = {}

	local self = {
		--- @type fun(sprite: Sprite, position: Point, orientation: ORIENTATION): nil
		spawn = function(sprite, position, orientation)
			spawn(game, sprite, position, orientation)
		end,
		--- @type fun(sprite: Sprite, cancel_tags: string | nil): nil
		delete = function(sprite, cancel_tags)
			delete(game, cancel_table, sprite, cancel_tags)
		end,

		--

		--- @type fun(sprite: Sprite, x: number, y: number, options: SpriteSeqOptions | nil): nil
		translate = function(sprite, x, y, options)
			translate(game, cancel_table, sprite, x, y, options)
		end,

		--

		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_up_now = function(sprite, options)
			move_up_now(game, cancel_table, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_down_now = function(sprite, options)
			move_down_now(game, cancel_table, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_left_now = function(sprite, options)
			move_left_now(game, cancel_table, sprite, options)
		end,
		--- @type fun(sprite: Sprite, options: SpriteSeqOptions | nil): nil
		move_right_now = function(sprite, options)
			move_right_now(game, cancel_table, sprite, options)
		end,

		--

		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_up = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_up(game, cancel_table, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_down = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_down(game, cancel_table, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_left = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_left(game, cancel_table, sprite, frames, cancel_tags)
		end,
		--- @type fun(sprite: Sprite, frames: number, options: SpriteSeqOptions | nil): function
		--- @return function sequence_cleaner_function
		hold_moving_right = function(sprite, frames, options)
			local cancel_tags = options and options.cancel_tags
			return hold_moving_right(game, cancel_table, sprite, frames, cancel_tags)
		end,

		--

		--- Cancels all sequences if no `tag_or_tags` is provided
		--- @type fun(cancel_tags: string | string[] | nil): nil
		cancel_sequences = function(cancel_tags)
			cancel_sequences(cancel_table, cancel_tags)
		end,
	}

	return self
end

return { new = new }
