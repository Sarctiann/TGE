local directionOffsets = {
    ["north"] = { 0, -1 },
    ["west"] = { -1, 0 },
    ["south"] = { 0, 1 },
    ["east"] = { 1, 0 }
}

local tankSpriteNorth = { { 0, 1, 0 }, { 1, 1, 1 }, { 1, 0, 1 } }
local tankSpriteEast = { { 1, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 } }
local tankSpriteWest = { { 0, 1, 1 }, { 1, 1, 0 }, { 0, 1, 1 } }
local tankSpriteSouth = { { 1, 0, 1 }, { 1, 1, 1 }, { 0, 1, 0 } }

local tankSprites = {
    ["north"] = tankSpriteNorth,
    ["west"] = tankSpriteWest,
    ["south"] = tankSpriteSouth,
    ["east"] = tankSpriteEast
}

local keyDirectionMapping = {
    ["w"] = "north",
    ["a"] = "west",
    ["s"] = "south",
    ["d"] = "east"
}

local pixel = "%s\u{2588}\u{2588}"
local border = "%s\u{2592}\u{2592}"
local bullet = "%s\u{0028}\u{0029}"
local bullet2 = "%s\u{25D6}\u{25D7}"
local bullet3 = "%s\u{0020}\u{2022}"
local bullet4 = "%s\u{0020}\u{1F785}"
local textures = { ["pixel"] = pixel, ["border"] = border, bullet = bullet }

return {
    directionOffsets = directionOffsets,
    tankSprites = tankSprites,
    keyDirectionMapping = keyDirectionMapping,
    textures = textures
}
