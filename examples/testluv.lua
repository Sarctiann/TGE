--- @see DOCS https://github.com/luvit/luv/blob/master/docs.md#libuv-in-lua
local uv = require("luv")

-- Creating a simple setTimeout wrapper
local function setTimeout(timeout, callback)
	local timer = uv.new_timer()
	timer:start(timeout, 0, function()
		timer:stop()
		timer:close()
		callback()
	end)
	return timer
end

-- Creating a simple setInterval wrapper
local function setInterval(interval, callback)
	local timer = uv.new_timer()
	timer:start(interval, interval, function()
		callback()
	end)
	return timer
end

-- And clearInterval
local function clearInterval(timer)
	timer:stop()
	timer:close()
end

-------------
-- Testing it
-------------

local callback_loop = setInterval(1000, function()
	print("hello")
end)

local function close()
	clearInterval(callback_loop)
	print("Done.")
end

setTimeout(5000, close)

print("This should be printed first")

uv.run()
