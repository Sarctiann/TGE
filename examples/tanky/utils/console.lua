local box = require("luabox")

local stdin, stdout = box.util.getHandles()

local console = box.Console.new(stdin, stdout)

local clearAll = function()
	console:write(box.clear.afterCursor)
	console:write(box.clear.beforeCursor)
end

return { console = console, clearAll = clearAll }
