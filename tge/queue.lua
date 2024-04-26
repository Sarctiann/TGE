--- @class Queue
--- @field private queue Brief[]
Queue = {}

--- @return Queue queue
function Queue.New()
	return setmetatable({
		queue = {},
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
	if #self.queue == 0 then
		table.insert(self.queue, brief)
	else
		for i, q_brief in ipairs(self.queue) do
			if brief.when < q_brief then
				table.insert(self.queue, i, brief)
				break
			end
			if i == #self.queue then
				table.insert(self.queue, brief)
			end
		end
	end
end

--- dequeues (and returns) the briefs that should be executed
function Queue:dequeue()
	local now = os.time()
	local exec_brief_list = {}

	if #self.queue == 0 then
		return nil
	end
	for i, q_brief in ipairs(self.queue) do
		if q_brief.when < now then
			table.insert(exec_brief_list, table.remove(self.queue, i))
		end
	end
	if #exec_brief_list == 0 then
		return nil
	end

	return exec_brief_list
end

return Queue
