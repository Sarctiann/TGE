--- @class Queue
--- @field private queue Brief[]
Queue = {}

function Queue.New()
	return setmetatable({}, {
		__index = Queue,
		__tostring = function(self)
			return string.format("The Queue has %d briefs", #self.queue)
		end,

		queue = {},
	})
end

function Queue:enqueue(brief)
	-- TODO: insert the vrief in before the brief with less "wait" and after the brief with more "wait"
	table.insert(self.queue, brief)
end

function Queue:dequeue()
	-- TODO: remove & return a list of briefs that have "wait" == 0
	if #self.queue == 0 then
		return nil
	end
	return table.remove(self.queue, 1)
end

return Queue
