local box = require("luabox")
local write_as_human = require("src/utils").write_as_human

local util = box.util
local event = box.event
local clear = box.clear
local cursor = box.cursor
local colors = box.colors

local f = string.format

local stdin, stdout = util.getHandles()

local console = box.Console.new(stdin, stdout)

console:setMode(1)
console:intoMouseMode()

console:write(f("%s%s", cursor.hide, clear.all))

local text = " TGE started \u{f0d3a}  "

console:write(cursor.goTo(2, 2))
write_as_human(function(t)
    console:write(t)
end, f("%s%s", colors.fg(colors.red), text), 200)

console:write(cursor.goTo(2, 2))
write_as_human(function(t)
    console:write(t)
end, f("%s%s%s", colors.fg(colors.black), colors.bg(colors.red), text), 50)

console:write(f("%s%s", colors.resetFg, colors.resetBg))

local pixelprint = function(x, y, element)
    console:write(f(element, cursor.goTo((x * 2) - 1, y)))
end

local printmatrix = function(matrix, topleftx, toplefty, element)
    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            if matrix[i][j] == 1 then
                console:write(f(element, cursor.goTo(topleftx + j - 1, toplefty + i - 1)))
            end
        end
    end
end

local pixelprintmatrix = function(matrix, topleftx, toplefty, element)
    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            if matrix[i][j] == 1 then
                pixelprint(topleftx + j - 1, toplefty + i - 1, element)
            end
        end
    end
end

local tankArrayNorth = { { 0, 1, 0 }, { 1, 1, 1 }, { 1, 0, 1 } }
local tankArrayEast = { { 1, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 } }
local tankArrayWest = { { 0, 1, 1 }, { 1, 1, 0 }, { 0, 1, 1 } }
local tankArraySouth = { { 1, 0, 1 }, { 1, 1, 1 }, { 0, 1, 0 } }
local currentTankArray = tankArrayNorth

local tankx, tanky = 32, 16

local pixel = "%s\u{2588}\u{2588}"

console.onData = function(data)
    local first
    local rest = {}

    for char in data:gmatch(".") do
        if not first then
            first = char
        else
            table.insert(rest, char)
        end
    end

    local iter = util.StringIterator(table.concat(rest))

    local keyData = event.parse(first, iter)

    if keyData ~= nil then
        if keyData.key == "ctrl" and keyData.char == "c" then
            console:write(cursor.show)
            console:setMode(0)
            console:exitMouseMode()
            console:close()

            os.exit()
        elseif keyData.key == "char" then
            console:write(clear.afterCursor)
            console:write(clear.beforeCursor)
            if keyData.char == "c" then
                console:write(clear.all)
            elseif keyData.char == "w" then
                if currentTankArray == tankArrayNorth then
                    tanky = tanky - 1
                else
                    currentTankArray = tankArrayNorth
                end
            elseif keyData.char == "a" then
                if currentTankArray == tankArrayWest then
                    tankx = tankx - 1
                else
                    currentTankArray = tankArrayWest
                end
            elseif keyData.char == "s" then
                if currentTankArray == tankArraySouth then
                    tanky = tanky + 1
                else
                    currentTankArray = tankArraySouth
                end
            elseif keyData.char == "d" then
                if currentTankArray == tankArrayEast then
                    tankx = tankx + 1
                else
                    currentTankArray = tankArrayEast
                end
            end
            pixelprintmatrix(currentTankArray, tankx - 1, tanky - 1, pixel)
            -- to show the coords of the tank
            -- console:write(f(tankx) .. ';' .. f(tanky))
        end
    end
end

console.run()
