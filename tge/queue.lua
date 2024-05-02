local SecondsFrames = require("tge.entities.seconds_frames")

--- @class Queue
--- @field private brief_queue Brief[]
Queue = {}

--- @return Queue queue
function Queue.new()
	-- This is only accesible inside of the classs
	local brief_queue = {}

	local self = setmetatable({}, {
		__index = Queue,
		__tostring = function(self)
			return string.format("The Queue has %d briefs", #self.queue)
		end,
		__len = function()
			return #brief_queue
		end,
	})

	--- queue a.new brief in its corresponding order based on its "when" attribute.
	--- @param brief Brief
	function Queue:enqueue(brief)
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

	--- dequeues (and returns) the briefs that should be executed or nil if there is no brief to be executed yet.
	--- @param game_sf SecondsFrames
	--- @return Brief[] | nil
	function Queue:dequeue(game_sf)
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

	return self
end

return Queue
