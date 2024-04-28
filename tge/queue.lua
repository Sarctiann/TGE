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

--- queue a new report in its corresponding order based on its "when" attribute.
--- @param brief Brief
function Queue:enqueue(brief)
	if #self.brief_queue == 0 then
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

--- dequeues (and returns) the briefs that should be executed
-- TODO: document this func and pass the SeconsFrames to it
function Queue:dequeue(sf)
	local now = os.time()
	local exec_brief_list = {}

	if #self.brief_queue == 0 then
		return nil
	end
	for i, q_brief in ipairs(self.brief_queue) do
		if q_brief.when < now then
			table.insert(exec_brief_list, table.remove(self.brief_queue, i))
		end
	end
	if #exec_brief_list == 0 then
		return nil
	end

	return exec_brief_list
end

return Queue
