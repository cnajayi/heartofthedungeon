-- Sound Dictionary / Table
local sounds = {}  -- create an empty table

sounds["music_adventure"] = love.audio.newSource("sounds/8-bit-dungeon.mp3","static")
sounds["music_adventure"]:setVolume(0.3)
sounds["music_surfrock"] = love.audio.newSource("sounds/timbeek/Surf_Rock_Light.wav","static")
sounds["music_surfrock"]:setVolume(0.3)
sounds["exploration"] = love.audio.newSource("sounds/exploration.mp3","static")
sounds["exploration"]:setVolume(0.3)
-- Add this to the file
sounds["attack"] = love.audio.newSource("sounds/leohpaz/Slash.wav","static")
sounds["mob_hurt"] = love.audio.newSource("sounds/kronbits/Impact_Punch.wav","static")
sounds["player_hurt"] = love.audio.newSource("sounds/kronbits/Punch_Hurt.wav","static")
sounds["die"] = love.audio.newSource("sounds/kronbits/Negative_Short.wav","static")
sounds["game_over"] = love.audio.newSource("sounds/kronbits/Negative_Melody.wav","static")

return sounds
