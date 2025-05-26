local Stage = require "src.game.Stage"
local Tileset = require "src.game.Tileset"
local Minotaur = require "src.game.mobs.Minotaur"
local Wizard = require "src.game.mobs.Wizard"
local Sounds = require "src.game.Sounds"

local function createS1()
    local tilesetImage = love.graphics.newImage("graphics/stage/Dungeon_Tileset (1).png")
    local tileset = Tileset(tilesetImage, 32)

    tileset:setNotSolid({232})
    
    local stage = Stage(10, 10, tileset)

    local mapdata = require "src.game.map"
    stage:readMapData(mapdata)

    stage.initialPlayerX = 4 * 32
    stage.initialPlayerY = 4 * 32

    local mob1 = Minotaur()
    mob1:setCoord(6 * 32, 2 * 32)
    mob1:changeDirection()
    stage:addMob(mob1)

    --local mob2 = Wizard()
    --mob2:setCoord(6 * 32, 4 * 32)
    --mob2:changeDirection()
    --stage:addMob(mob2)

    stage:setMusic(Sounds["music_adventure"])

    return stage
end

return createS1
