--- @class Queue
--- @field private brief_queue Brief[]
Queue = {}

--- @return Queue queue
function Queue.New()
	return setmetatable({
		brief_queue = {},
	}, {
		__index = Queue,
		__tostring = function(self)
			return string.format("The Queue has %d briefs", #self.queue)
		end,
	})
end

-- TODO: implement the locking system base on the ui_element's Lock_frames and locked_until fileds

--- queue a new report in its corresponding order based on its "when" attribute.
--- @param brief Brief
function Queue:enqueue(brief)
	if #self.brief_queue == 0 or not brief.when then
		table.insert(self.brief_queue, brief)
	else
		for i, q_brief in ipairs(self.brief_queue) do
			if brief.when < q_brief.when then
				table.insert(self.brief_queue, i, brief)
				break
			end
			if i == #self.brief_queue then
				table.insert(self.brief_queue, brief)
			end
		end
	end
end

--- dequeues (and returns) the briefs that should be executed or nil if there is no brief to be executed yet.
--- @param game_sf SecondsFrames
--- @return Brief[] | nil
function Queue:dequeue(game_sf)
	local exec_brief_list = {}

	if #self.brief_queue == 0 then
		return nil
	end
	for i, q_brief in ipairs(self.brief_queue) do
		if not q_brief.when or q_brief.when <= game_sf then
			table.insert(exec_brief_list, table.remove(self.brief_queue, i))
		end
	end
	if #exec_brief_list == 0 then
		return nil
	end

	return exec_brief_list
end

return Queue
