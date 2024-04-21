local sumOffsetToCoords = require("examples.tanky.utils.math").sumOffsetToCoords

Bullet = {
    coords = {},
    direction = {},
    move = function(self)
        self.coords = sumOffsetToCoords(self.coords, self.direction)
    end
}

-- Función para crear una nueva instancia de Bullet
function Bullet:new(coords, direction)
    local new_bullet = {}
    setmetatable(new_bullet, self)
    self.__index = self
    new_bullet.coords = coords
    new_bullet.direction = direction
    return new_bullet
end

-- Creación de un array para almacenar las instancias de Bullet
local bullets = {}

return { Bullet = Bullet, bullets = bullets }
