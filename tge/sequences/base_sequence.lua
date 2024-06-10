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

--- @type fun(game: Game, frames_intervals: number[], briefs_or_sequences: Brief[], cancel_tags: string | string[] | nil, unlocked: boolean | nil): fun(): nil
local function create_sequence(game, frames_intervals, briefs_or_sequences, cancel_tags, unlocked)
	perform_cancel_tags(cancel_tags)

	local cancel_function
	local cycle = 1
	local brief = 1
	local timeout

	local function set_next()
		timeout = utils.set_timeout(math.floor(1000 / game.frame_rate * frames_intervals[cycle]), function()
			game.queue.enqueue(briefs_or_sequences[brief], { unlocked = unlocked })
			set_next()
			register_cancel_tags(cancel_tags, timeout)
		end)
		cycle = cycle == #frames_intervals and 1 or cycle + 1
		brief = brief == #briefs_or_sequences and 1 or brief + 1
		cancel_function = function()
			utils.clear_timer(timeout)
		end
	end
	set_next()

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
