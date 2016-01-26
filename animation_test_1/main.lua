function floor(image, y)
    if not y then
        y = 0
    end
    return love.graphics.getHeight()-image:getHeight()-y
end
function love.load()
    Center = {
        love.graphics.getWidth()/2,
        love.graphics.getHeight()/2
    }
    animation = {}
    animation.running = false
    Dudes_table = {
        [1] = {
            position = 0,
            image = love.graphics.newImage("assets/dude.png")
        },
        [2] = {
            position = 10,
            image = love.graphics.newImage("assets/dude.png")
        },
        [3] = {
            position = 20,
            image = love.graphics.newImage("assets/dude.png")
        }
    }
    Dude = Dudes_table[1]
end
function love.update()
    if animation.running == true then
        animation.now = love.timer.getTime()
        animation.interval = animation.now - animation.start
        print(animation.interval)
        if animation.interval < .5 then
            Dude = Dudes_table[2]
        elseif animation.interval > .5 and animation.interval < 1 then
            Dude = Dudes_table[3]
        elseif animation.interval > 1 and animation.interval < 1.5 then
            Dude = Dudes_table[2]
        elseif animation.interval > 1.5 then
            Dude = Dudes_table[1]
            animation = {}
            animation.running = false
        end
    end
end
function love.draw()
    love.graphics.draw(Dude.image, Center[1], floor(Dude.image, Dude.position))
end
function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "space" then
        animation = {}
        animation.running = true
        animation.start = love.timer.getTime()
    end
end
