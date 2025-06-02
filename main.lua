local Globals = require "src.Globals"
local Push = require "libs.push"
local Sounds = require "src.game.Sounds"
local Player = require "src.game.Player"
local Stage = require "src.game.Stage"
local createS1 = require "src.game.createS1" 
local tween = require "libs.tween"

function love.load()
    love.window.setTitle("Heart of the Dungeon")
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})
    math.randomseed(os.time())

    name = {x = 0, y = 0, text = "Created by: Crystal Ajayi"}
    local targetY = gameHeight - 30
    tweenAnim = tween.new(4, name, { y = targetY }, 'outBounce')

    
    --fade vars
    fadeAlpha = 0
    fadeTimer = 0
    fadeDuration = 2
    isFadingToGameOver = false

    gameState = "start"

    stage = createS1()
    for i = 1, #stage.mobs do
        local mob = stage.mobs[i]
        if mob.name == "minotaur" then
            minotaur = mob
            break
        end
    end    

    stage:playMusic()
    player = Player(stage.initialPlayerX, stage.initialPlayerY)

    startBackground = love.graphics.newImage("graphics/background/set.jpg")
    startFont = love.graphics.newFont("fonts/DragonHunter.otf", 20)
    smallFont = love.graphics.newFont("fonts/DragonHunter.otf", 12) 
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" or key == "space" then
        if gameState == "start" then
            gameState = "play"
        elseif gameState == "over" then
            restartGame()
        end
    end

    if gameState == "play" and player and player.keypressed then
        player:keypressed(key)
    end
end

function love.update(dt)
    if (player.hp <= 0 or (minotaur and minotaur.died)) and not isFadingToGameOver then
        isFadingToGameOver = true
        fadeTimer = 0
        stage:stopMusic()
        if Sounds["game_over"] then Sounds["game_over"]:play() end
    end
    

    if gameState == "start" then
        --start screen logic
    elseif gameState == "play" then
        player:update(dt, stage)
        stage:update(dt, player)

        if player.hp <= 0 and not isFadingToGameOver then
            isFadingToGameOver = true
            fadeTimer = 0
        end

        if isFadingToGameOver then
            fadeTimer = fadeTimer + dt
            fadeAlpha = math.min(fadeTimer / fadeDuration, 1)
            if fadeAlpha >= 1 then
                gameState = "over"
                isFadingToGameOver = false
                fadeAlpha = 0
            end
        end

    elseif gameState == "over" then
        -- Game over logic
    end

    if tweenAnim then
        tweenAnim:update(dt)
    end

end

function love.draw()
    Push:start()

    if gameState == "start" then
        drawStartScreen()
    elseif gameState == "play" then
        stage:draw()
        player:draw()
    elseif gameState == "over" then
        drawGameOverScreen()
    end

    if fadeAlpha > 0 then
        love.graphics.setColor(0, 0, 0, fadeAlpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
    end

    Push:finish()
end

function drawStartScreen()
    local scaleX = gameWidth / startBackground:getWidth()
    local scaleY = gameHeight / startBackground:getHeight()
    love.graphics.draw(startBackground, 0, 0, 0, scaleX, scaleY)

    love.graphics.setFont(startFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Heart of the Dungeon", 0, 100, gameWidth, "center")

    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press Enter to Start", 0, 130, gameWidth, "center")

    love.graphics.setFont(smallFont)
    local textWidth = smallFont:getWidth(name.text)
    local middle = (gameWidth - textWidth) / 2

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(name.text, middle, name.y)
end

function drawGameOverScreen()
    local scaleX = gameWidth / startBackground:getWidth()
    local scaleY = gameHeight / startBackground:getHeight()
    love.graphics.draw(startBackground, 0, 0, 0, scaleX, scaleY)

    love.graphics.setFont(startFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GAME OVER", 0, 100, gameWidth, "center")

    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press Enter to Restart", 0, 130, gameWidth, "center")
end

function restartGame()
    stage = createS1()
    stage:playMusic()
    player = Player(stage.initialPlayerX, stage.initialPlayerY)

    for i = 1, #stage.mobs do
        local mob = stage.mobs[i]
        if mob.name == "minotaur" then
            minotaur = mob
            break
        end
    end    

    fadeAlpha = 0
    fadeTimer = 0
    isFadingToGameOver = false
    gameState = "play"
end
