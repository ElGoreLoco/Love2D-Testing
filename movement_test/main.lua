function newCharacter(path)
    character = {
        relative_position = {
            x = 0,
            y = 0
        },
        movement = {
            x_p = 0,
            x_n = 0
        },
        animation = {
            running = false
        },
        image = love.graphics.newImage(path)
    }
    character.position = function()
        return {
            x = love.graphics.getWidth()/2 + character.relative_position.x,
            y = love.graphics.getHeight() - character.image:getHeight() - character.relative_position.y  -- -300
        }

    end
    return character
end
function fall_animation(t, v, h, k)
    h = h or 0
    k = k or 20

    return h + v * t - k * 9.8 * t^2
end
function love.load()
    Dude = newCharacter("assets/dude.png")
end
function love.update()
    if Dude.animation.running == true then
        Dude.animation.now = love.timer.getTime()
        Dude.animation.interval = Dude.animation.now - Dude.animation.start
        Dude.relative_position.y = fall_animation(Dude.animation.interval, 150)
        if Dude.relative_position.y <= 0 then
            Dude.animation.running = false
            Dude.relative_position.y = 0
        end
        print(Dude.relative_position.y)
    end
    Dude.relative_position.x = Dude.relative_position.x + Dude.movement.x_p - Dude.movement.x_n
end
function love.draw()
    love.graphics.draw(Dude.image, Dude.position().x, Dude.position().y)
end
function love.keypressed(key)
    if key == "space" then
        if Dude.animation.running == false then
            Dude.animation = {}
            Dude.animation.running = true
            Dude.animation.start = love.timer.getTime()
        end
    elseif key == "a" then
        Dude.movement.x_n = 2
--      if Dude.animation.running == true then      -- When I can make this to
--          Dude.movement.x_n = 0.75                -- reset when it falls to
--      else                                        -- the ground, I will
--          Dude.movement.x_n = 2                   -- implement it.
--      end
    elseif key == "d" then
        Dude.movement.x_p = 2
--      if Dude.animation.running == true then
--          Dude.movement.x_p = 0.75
--      else
--          Dude.movement.x_p = 2
--      end
    elseif key == "escape" then
        love.event.push("quit")
    end
end
function love.keyreleased(key)
    if key == "a" then
        Dude.movement.x_n = 0
    elseif key == "d" then
        Dude.movement.x_p = 0
    end
end
