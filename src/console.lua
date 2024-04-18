local box = require("luabox")
local util = box.util
local clear = box.clear
local stdin, stdout = util.getHandles()
local console = box.Console.new(stdin, stdout)
console.clearAll = function()
    console:write(clear.afterCursor)
    console:write(clear.beforeCursor)
end

return console
