local utils = require("tge.utils")

local cancel_table = {}

local function register_cancel_tags(cancel_tags, sequence)
	if type(cancel_tags) == "table" then
		for _, tag in ipairs(cancel_tags) do
			cancel_table[tag] = sequence
		end
	elseif type(cancel_tags) == "string" then
		cancel_table[cancel_tags] = sequence
	end
end

local function perform_cancel_tags(cancel_tags)
	if type(cancel_tags) == "table" then
		for _, tag in ipairs(cancel_tags) do
			if cancel_table[tag] then
				utils.clear_timer(cancel_table[tag])
			end
		end
	elseif type(cancel_tags) == "string" then
		if cancel_table[cancel_tags] then
			utils.clear_timer(cancel_table[cancel_tags])
		end
	end
end
--- @type fun(game: Game, frames_intervals: number[], brief_sequences: Brief[], cancel_tags: string | string[] | nil, unlocked: boolean | nil): fun(): nil
local function create_sequence(game, frames_intervals, brief_sequences, cancel_tags, unlocked)
	perform_cancel_tags(cancel_tags)

	local timeout
	local cancel_function
	local cycle = 0
	local brief = 0

	local function set_next()
		timeout = utils.set_timeout(frames_intervals[cycle + 1], function()
			game.queue.enqueue(brief_sequences[brief + 1], { unlocked = unlocked })
			set_next()
			set_next()
			register_cancel_tags(cancel_tags, timeout)
		end)
		cancel_function = function()
			utils.clear_timer(timeout)
		end
		cycle = cycle == #frames_intervals and 0 or cycle + 1
		brief = brief == #brief_sequences and 0 or brief + 1
	end

	return cancel_function
end

--- @type fun(cancel_tags: string | string[] | nil): nil
local function cancel_sequences(cancel_tags)
	if not cancel_tags then
		for _, seq in pairs(cancel_table) do
			utils.clear_timer(seq)
		end
	else
		perform_cancel_tags(cancel_tags)
	end
end

return {
	create_sequence = create_sequence,
	cancel_sequences = cancel_sequences,
	register_cancel_tags = register_cancel_tags,
	cancel_tags = perform_cancel_tags,
}
