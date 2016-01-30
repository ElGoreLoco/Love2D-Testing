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
            running = false
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
    dude = newObject("assets/dude.png", 0, 0, "player")
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
    table.insert(all, dude)
    table.insert(all, caca)
end
function love.update()
    if dude.animation.running == true then
        dude.animation.now = love.timer.getTime()
        dude.animation.interval = dude.animation.now - dude.animation.start
        dude.relative_position.y = fall_animation(dude.animation.interval, 150)
        if dude.relative_position.y <= 0 then
            dude.animation.running = false
            dude.relative_position.y = 0
        end
    end
    dude.relative_position.x = dude.relative_position.x + dude.movement.x_p - dude.movement.x_n
    dude.relative_position.y = math.floor(dude.relative_position.y)
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
        if dude.animation.running == false then
            dude.animation = {}
            dude.animation.running = true
            dude.animation.start = love.timer.getTime()
        end
    elseif key == "a" then
        dude.movement.x_n = 2
--      if dude.animation.running == true then      -- When I can make this to
--          dude.movement.x_n = 0.75                -- reset when it falls to
--      else                                        -- the ground, I will
--          dude.movement.x_n = 2                   -- implement it.
--      end
    elseif key == "d" then
        dude.movement.x_p = 2
--      if dude.animation.running == true then
--          dude.movement.x_p = 0.75
--      else
--          dude.movement.x_p = 2
--      end
    elseif key == "escape" then
        love.event.push("quit")
    end
end
function love.keyreleased(key)
    if key == "a" then
        dude.movement.x_n = 0
    elseif key == "d" then
        dude.movement.x_p = 0
    end
end
