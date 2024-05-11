local SecondsFrames = require("tge.entities.seconds_frames")

local function enqueue(brief_queue, brief)
	local uelu = brief.ui_element.locked_until
	local when = brief.when

	-- Check if the ui_element is locked
	if uelu and when and uelu > when then
		return
	end

	-- Apply the lock_frames to the ui_element
	brief.ui_element.locked_until = when
			and when + SecondsFrames.from_frames(brief.ui_element.lock_frames, when.frame_rate)
		or nil

	-- Check if the brief_queue is empty or if the brief should be executed immediately
	if #brief_queue == 0 or not when then
		table.insert(brief_queue, brief)

		-- Enqueue the brief in the correct order
	else
		for i, q_brief in ipairs(brief_queue) do
			if when < q_brief.when then
				table.insert(brief_queue, i, brief)
				break
			end
			if i == #brief_queue then
				table.insert(brief_queue, brief)
			end
		end
	end
end

local function dequeue(brief_queue, game_sf)
	local exec_brief_list = {}

	if #brief_queue == 0 then
		return nil
	end
	for i, q_brief in ipairs(brief_queue) do
		if not q_brief.when or q_brief.when <= game_sf then
			table.insert(exec_brief_list, table.remove(brief_queue, i))
		end
	end
	if #exec_brief_list == 0 then
		return nil
	end

	return exec_brief_list
end

--- Creates a new Queue
local function new()
	-- This is only accesible inside of the classs
	--- @type Brief[]
	local brief_queue = {}

	--- @class Queue
	local self = {
		--- queue a.new brief in its corresponding order based on its "when" attribute.
		--- @type fun(brief: Brief): nil
		enqueue = function(brief)
			enqueue(brief_queue, brief)
		end,

		--- dequeues (and returns) the briefs that should be executed or nil if there is no brief to be executed yet.
		--- @type fun(game_sf: SecondsFrames): Brief[] | nil
		dequeue = function(game_sf)
			return dequeue(brief_queue, game_sf)
		end,
	}

	setmetatable(self, {
		__tostring = function()
			return string.format("The Queue has %d briefs", #brief_queue)
		end,
		__len = function()
			return #brief_queue
		end,
	})

	return self
end

return { new = new }
