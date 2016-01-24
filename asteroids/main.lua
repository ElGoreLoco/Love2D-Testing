local angle = -90
local position = { love.graphics.getWidth()/2, love.graphics.getHeight()/2 }
local change_angle_vel = 7
local change_pos_vel = 20
local change_pos_p = 0
local change_pos_n = 0
local change_angle_p = 0
local change_angle_n = 0

-- Utility functions
function move(x, y, r, velocity)
    x = x + math.cos(r)*(-velocity)
    y = y + math.sin(r)*(-velocity)
    return { x, y }
end


-- LOVE functions
function love.load()
    Ship = love.graphics.newImage("assets/ship.png")
end

function love.update()
    angle = angle + change_angle_p - change_angle_n
    position = move(position[1], position[2], angle*(math.pi/180), (change_pos_p - change_pos_n))
end

function love.draw()
    love.graphics.draw(Ship, position[1], position[2], angle*(math.pi/180), 1, 1, Ship:getWidth()/3, Ship:getHeight()/2)
end

function love.keypressed(key)
    if love.keyboard.isDown("lshift") == true then
        if love.keyboard.isDown("w") == true then
            change_pos_n = change_pos_vel*2
        elseif love.keyboard.isDown("s") == true then
            change_pos_p = change_pos_vel*2
        end
    else
        if love.keyboard.isDown("w") == true then
            change_pos_n = change_pos_vel
        elseif love.keyboard.isDown("s") == true then
            change_pos_p = change_pos_vel
        end
    end

    if key == "a" then
        change_angle_n = change_angle_vel
    elseif key == "d" then
        change_angle_p = change_angle_vel

    elseif key == "escape" then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == "w" then
        change_pos_n = 0
    elseif key == "s" then
        change_pos_p = 0
    elseif key == "lshift" then
        love.keypressed()

    elseif key == "a" then
        change_angle_n = 0
    elseif key == "d" then
        change_angle_p =0
    end
end
