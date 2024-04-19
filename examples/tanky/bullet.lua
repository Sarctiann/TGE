local directionOffsets = {
    ["north"] = { 0, -1 },
    ["west"] = { -1, 0 },
    ["south"] = { 0, 1 },
    ["east"] = { 1, 0 }
}

Bullet = {
    coords = {},
    direction = {},
    move = function(self)
        self.coords[1] = self.coords[1] + self.direction[1]
        self.coords[2] = self.coords[2] + self.direction[2]
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

-- Creación de una instancia de Bullet
local bullet1 = Bullet:new({ 14, 17 }, { 1, 0 })

-- Llamada al método move de la instancia
bullet1:move()

-- Creación de un array para almacenar las instancias de Persona
local bullets = {}
--[[
table.insert(bullets, Bullet:new({ 14, 17 }, { 1, 0 }))

for _, bullet in ipairs(bullets) do
    bullet:move()
end
]]
return { Bullet = Bullet, bullets = bullets }
