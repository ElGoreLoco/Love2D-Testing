function newObject(path, x, y, class)
    local x = x or 0
    local y = y or 0
    local class = class or "static"

    local object = {}

    object.class = class
    object.image = love.graphics.newImage(path)

    if class == "static" then
        object.position = {
            x = love.graphics.getWidth()/2 + x,
            y = love.graphics.getHeight() - object.image:getHeight() - y  -- -300
        }
    elseif class == "player" then
        object.relative_position = {
            x = x,
            y = y
        }
        object.movement = {
            x_p = 0,
            x_n = 0
        }
        object.animation = {
            jumping = {
                running = false
            },
            walking = {
                running = false
            }
        }
        object.position = function()
            return {
                x = love.graphics.getWidth()/2 + object.relative_position.x,
                y = love.graphics.getHeight() - object.image:getHeight() - object.relative_position.y  -- -300
            }
        end
    end

    return object
end
function fall_animation(t, v, h, k)
    local h = h or 0
    local k = k or 25

    return h + v * t - k * 9.8 * t^2
end
function love.load()
    -- Object creation
    player = newObject("assets/player.png", 0, 0, "player")
    caca = newObject("assets/caca.png", love.math.random(-9, 9), 0)
    plants = {}
    for i=1, love.graphics.getWidth()/10 do
        table.insert(plants, newObject("assets/plant.png", love.math.random(-love.graphics.getWidth()/2, love.graphics.getWidth()/2)))
    end

    -- Object assignment
    all = {}
    for i=1,#plants do
        table.insert(all, plants[i])
    end
    table.insert(all, player)
    table.insert(all, caca)
end
function love.update()
    -- ANIMATIONS
    --- Jump
    if player.animation.jumping.running == true then
        player.animation.jumping.now = love.timer.getTime()
        player.animation.jumping.interval = player.animation.jumping.now - player.animation.jumping.start
        player.relative_position.y = fall_animation(player.animation.jumping.interval, 150)
        if player.relative_position.y <= 0 then
            player.animation.jumping.running = false
            player.relative_position.y = 0
        end
    end

    -- Set position of player
    player.relative_position.x = player.relative_position.x + player.movement.x_p - player.movement.x_n
    player.relative_position.y = math.floor(player.relative_position.y)
end
function love.draw()
    for i=1,#all do
        if all[i].class == "static" then
            love.graphics.draw(all[i].image, all[i].position.x, all[i].position.y)
        elseif all[i].class == "player" then
            love.graphics.draw(all[i].image, all[i].position().x, all[i].position().y)
        end
    end
end
function love.keypressed(key)
    if key == "space" then
        if player.animation.jumping.running == false then
            player.animation.jumping.running = true
            player.animation.jumping.start = love.timer.getTime()
        end
    elseif key == "a" then
        player.movement.x_n = 2
--      if player.animation.jumping.running == true then      -- When I can make this to
--          player.movement.x_n = 0.75                -- reset when it falls to
--      else                                        -- the ground, I will
--          player.movement.x_n = 2                   -- implement it.
--      end
    elseif key == "d" then
        player.movement.x_p = 2
--      if player.animation.jumping.running == true then
--          player.movement.x_p = 0.75
--      else
--          player.movement.x_p = 2
--      end
    elseif key == "escape" then
        love.event.push("quit")
    end
end
function love.keyreleased(key)
    if key == "a" then
        player.movement.x_n = 0
    elseif key == "d" then
        player.movement.x_p = 0
    end
end
