local SecondsFrames = require("tge.entities.seconds_frames")

local function enqueue(brief_queue, brief, unlocked)
	local uelu = brief.ui_element.locked_until
	local when = brief.when

	-- Check if the ui_element is locked
	if uelu and when and uelu > when then
		return
	end

	-- Apply the lock_frames to the ui_element
	brief.ui_element.locked_until = (when and not unlocked)
			and when + SecondsFrames.from_frames(brief.ui_element.lock_frames, when.frame_rate)
		or uelu

	-- Check if the brief_queue is empty or if the brief should be executed immediately
	table.insert(brief_queue, brief)
	-- Enqueue the brief and sort the queue
	if #brief_queue ~= 0 or not when then
		table.sort(brief_queue, function(a, b)
			return a.when < b.when
		end)
	end
end

local function dequeue(brief_queue, game_sf)
	local exec_brief_list = {}

	if #brief_queue == 0 then
		return nil
	end
	-- Check if the first brief should be executed and remove it from the queue if so.
	-- Since the queue is sorted, we can just check the first element every time.
	while #brief_queue > 0 do
		if brief_queue[1].when and brief_queue[1].when > game_sf then
			break
		end
		table.insert(exec_brief_list, table.remove(brief_queue, 1))
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
		--- @type fun(brief: Brief, unlocked: boolean | nil): nil
		--- @param brief Brief The brief to be queued
		--- @param unlocked boolean | nil If the brief should not lock the ui_element
		enqueue = function(brief, unlocked)
			enqueue(brief_queue, brief, unlocked)
		end,

		--- dequeues (and returns) the briefs that should be executed or nil if there is no brief to be executed yet.
		--- @type fun(game_sf: SecondsFrames): Brief[] | nil
		--- @param game_sf SecondsFrames The current game's seconds and frames
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
