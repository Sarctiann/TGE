local clock = os.clock

local utils = {}

--- function that sleep for the given cents of seconds
--- @param n number duration in cents of seconds
utils.sleep = function(n)
	local t0 = clock()
	while clock() - t0 <= n / 100 do
	end
end

--- function that write the text on the given time in cents of seconds
--- @param write_fn function to put the text in the screen
--- @param text string to put in the screen
--- @param speed number in cents of seconds to write the text
utils.write_as_human = function(write_fn, text, speed)
	for char = 1, #text - 1 do
		write_fn(text:sub(char, char))
		utils.sleep(speed / #text)
	end
	write_fn(text:sub(#text, #text) .. "\n")
end

return utils
