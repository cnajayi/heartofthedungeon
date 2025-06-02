local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Timer = require "libs.hump.timer"
local Enemy = require "src.game.mobs.Enemy"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

-- Idle Animation Resources
local idleSprite = love.graphics.newImage("graphics/mobs/minotaur/Idle.png")
local idleGrid = Anim8.newGrid(128, 128, idleSprite:getWidth(), idleSprite:getHeight())
local idleAnim = Anim8.newAnimation(idleGrid('1-10',1),0.2)

-- Walk Animation Resources
local walkSprite = love.graphics.newImage("graphics/mobs/minotaur/Walk.png")
local walkGrid = Anim8.newGrid(128, 128, walkSprite:getWidth(), walkSprite:getHeight())
local walkAnim = Anim8.newAnimation(walkGrid('1-12',1),0.2)

-- Hurt Animation Resources
local hurtSprite = love.graphics.newImage("graphics/mobs/minotaur/Hurt.png")
local hurtGrid = Anim8.newGrid(128, 128, hurtSprite:getWidth(), hurtSprite:getHeight())
local hurtAnim = Anim8.newAnimation(hurtGrid('1-3',1),0.2)

-- attack
local attackSprite = love.graphics.newImage("graphics/mobs/minotaur/Attack.png")
local attackGrid = Anim8.newGrid(128, 128, attackSprite:getWidth(), attackSprite:getHeight())
local attackAnim = Anim8.newAnimation(attackGrid('1-5',1),0.2)

-- Dead
local deadSprite = love.graphics.newImage("graphics/mobs/minotaur/Dead.png")
local deadGrid = Anim8.newGrid(128, 128, deadSprite:getWidth(), deadSprite:getHeight())
local deadAnim = Anim8.newAnimation(deadGrid('1-5',1),0.2)

local Minotaur = Class{__includes = Enemy}
function Minotaur:init(type) Enemy.init(self)

    self.name = "minotaur"
    self.type = type
    if type == nil then self.type = "normal" end

    self.dir = "l"
    self.state = "idle"
    self.animations = {}
    self.sprites = {}
    self.hitboxes = {}
    self.hurtboxes = {}

    self.hp = 50
    self.score = 300
    self.damage = 15

    self:setAnimation("idle", idleSprite, idleAnim)
    self:setAnimation("walk", walkSprite, walkAnim)
    self:setAnimation("hurt", hurtSprite, hurtAnim)
    self:setAnimation("attack", attackSprite, attackAnim)
    self:setAnimation("dead", deadSprite, deadAnim)

    self:setHurtbox("idle", 32, 32, 64, 64)
    self:setHurtbox("walk", 32, 32, 64, 64)
    self:setHurtbox("hurt", 28, 28, 72, 72)
    self:setHurtbox("attack", 28, 28, 72, 72) 

    self:setHitbox("attack", 70, 30, 40, 60)

    Timer.every(5,function() self:changeState() end)
end

function Minotaur:changeState()
    if self.state == "idle" then
            self.state = "walk"
    elseif self.state == "walk" then
        self.state = "idle"
    end
end

function Minotaur:update(dt, stage)
    if self.state == "walk" then
        local moveSpeed = 32 * dt
        if self.dir == "l" then
            if stage:leftCollision(self, 0) then
                self:changeDirection()
            else
                self.x = self.x - moveSpeed
            end
        else -- on ground and walking right
            if stage:rightCollision(self, 0) then
                self:changeDirection()
            else
                self.x = self.x + moveSpeed
            end
        end -- end if bottom collision & dir 
    end -- end if walking state
    Timer.update(dt) -- attention, Timer.update uses dot, and not :
    self.animations[self.state]:update(dt)
end -- end function

    function Minotaur:hit(damage, direction)
        if self.invincible then return end
    
        self.invincible = true
        self.hp = self.hp - damage
        self.state = "hurt"
        Sounds["mob_hurt"]:play()
    
        local knockback = 10
        local push
        if direction == "l" then
            push = knockback
        else
            push = -knockback
        end
        local ogX = self.x
    
        Timer.tween(0.1, self, {x = self.x + push}, 'out-quad', function()
            Timer.tween(0.1, self, {x = ogX}, 'in-quad')
        end)
    
        if self.hp <= 0 then
            self.died = true
            self.state = "dead"
        end
    
        Timer.after(1, function() self:endHit(direction) end)
        Timer.after(0.9, function() self.invincible = false end)
    end
    

function Minotaur:endHit(direction)
    if self.dir == direction then
        self:changeDirection()
    end
    self.state = "walk"
end

return Minotaur
