function floor(image, y)
    if not y then
        y = 0
    end
    return love.graphics.getHeight()-image:getHeight()-y
end
function fall_animation(t, v_0)
    h = 0
    return h + v_0 * t - 10 * 9.8 * t^2
end
function love.load()
    Center = {
        love.graphics.getWidth()/2,
        love.graphics.getHeight()/2
    }
    animation = {}
    animation.running = false
    Dude = {
        position = {
            x = 0,
            y = 0
        },
        movement = {
            x = 0
        },
        image = love.graphics.newImage("assets/dude.png")
    }
end
function love.update()
    if animation.running == true then
        animation.now = love.timer.getTime()
        animation.interval = animation.now - animation.start
        Dude.position.y = fall_animation(animation.interval, 100)
        if Dude.position.y <= 0 then
            animation.running = false
            Dude.position.y = 0
        end
        print(Dude.position.y)
    end
    Dude.position.x = Dude.position.x + Dude.movement.x
end
function love.draw()
    love.graphics.draw(Dude.image, Center[1]+Dude.position.x, floor(Dude.image, Dude.position.y))
end
function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "space" then
        animation = {}
        animation.running = true
        animation.start = love.timer.getTime()
    elseif key == "a" then
        --Dude.position.x = Dude.position.x - 5
        Dude.movement.x = -1
    elseif key == "d" then
        --Dude.position.x = Dude.position.x + 5
        Dude.movement.x = 1
    end
end
function love.keyreleased(key)
    if key == "a" or key == "d" then
        Dude.movement.x = 0
    end
end
