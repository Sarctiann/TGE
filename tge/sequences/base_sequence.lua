local utils = require("tge.utils")

local cancel_table = {}

local function register_cancel_tags(cancel_tags, sequence)
	if type(cancel_tags) == "table" then
		for _, tag in ipairs(cancel_tags) do
			if cancel_table[tag] then
				cancel_table[tag] = sequence
			end
		end
	elseif type(cancel_tags) == "string" then
		if cancel_table[cancel_tags] then
			cancel_table[cancel_tags] = sequence
		end
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

-- TODO: implement this function
local function create_sequence(frames_intervals, briefs_sequence, cancel_tags) end

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
	register_cancel_tags = register_cancel_tags,
	cancel_sequences = cancel_sequences,
}
