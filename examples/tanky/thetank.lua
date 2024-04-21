

local Tank = {
    coords = {},
    direction = {},
    --[[ move = function(self)
        self.coords = sumOffsetToCoords(self.coords, self.direction)
    end ]]
}

function Tank:new(coords, direction)
    local new_tank = {}
    setmetatable(new_tank, self)
    self.__index = self
    new_tank.coords = coords
    new_tank.direction = direction
    return new_tank
end

return { Tank = Tank }
