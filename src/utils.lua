local clock = os.clock

--- function that sleep for the given cents of seconds
--- @param n number duration in cents of seconds
local function sleep(n)
	local t0 = clock()
	while clock() - t0 <= n / 100 do
	end
end

return {
	sleep = sleep,

	-- -- Coroutine based sleep function (need to be tested)
	-- coro_sleep = function(time, func, ...)
	-- 	local now = os.time()
	-- 	local thread = coroutine.create(func)
	-- 	repeat
	-- 	until os.time() - now > time
	-- 	coroutine.resume(thread, ...)
	-- end,

	-- -- Coroutine based async sleep function (need to be tested)
	-- coro_asleep = function(time, func)
	-- 	coroutine.wrap(function(...)
	-- 		local now = os.time()
	-- 		local thread = coroutine.create(func)
	-- 		repeat
	-- 		until os.time() - now > time
	-- 		coroutine.resume(thread, ...)
	-- 	end)()
	-- end,

	--- function that write the text on the given time in cents of seconds
	--- @param write_fn function to put the text in the screen
	--- @param text string to put in the screen
	--- @param speed number in cents of seconds to write the text
	write_as_human = function(write_fn, text, speed)
		for char = 1, #text - 1 do
			write_fn(text:sub(char, char))
			sleep(speed / #text)
		end
		write_fn(text:sub(#text, #text) .. "\n")
	end,
}
