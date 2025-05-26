local Class = require "libs.hump.class"
local Tile = require "src.game.Tile"

local Tileset = Class{}
function Tileset:init(img, tilesize)
    self.tileImage = img -- tileset image
    self.tileSize = 32
    
    -- the number of rows & cols this tileset has
    self.rowCount = self.tileImage:getHeight() / self.tileSize
    self.colCount = self.tileImage:getWidth() / self.tileSize
    
    self.tiles = {} -- store the tiles as a dictionary/table
    self:createTiles()
end

function Tileset:createTiles() -- converts img to dict of tiles
    local index = 1
    for row = 1, self.rowCount do
        for col = 1, self.colCount do
            self.tiles[index] = self:newTile(row,col,index)  
            index = index + 1 
        end -- end for col
    end -- end for row
end

function Tileset:newTile(row, col, index)
    local q = love.graphics.newQuad(
        (col - 1) * self.tileSize,
        (row - 1) * self.tileSize,
        self.tileSize, self.tileSize,                            
        self.tileImage:getWidth(), self.tileImage:getHeight() 
    )
    return Tile(index, q)
end

function Tileset:get(index)
    return self.tiles[index]
end

function Tileset:getImage()
    return self.tileImage
end

function Tileset:setNotSolid(tilelist)
    for _, tid in ipairs(tilelist) do
        local tile = self.tiles[tid]
        if tile then
            tile.solid = false 
        end
    end
end

return Tileset