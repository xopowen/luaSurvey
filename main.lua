require("vector")
require("obstacle")
require('ray')
require('radiant')
require('radiantUnique')
require('survey')
function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- local location = Vector:create(width/2 -100, height/2)
    obstacles = {}

    local points = {{0, 0}, {width, 0}, {width, height}, {0, height}, {0, 0}}
    obstacles[1] = Obstacle:create(points)
    
    points = {{100, 100}, {100, 200}, {200, 200}, {200, 100}, {100, 100}}
    obstacles[2] = Obstacle:create(points)
    
    points = {{500, 100}, {650, 100}, {650, 300}, {500, 100}}
    obstacles[3] = Obstacle:create(points)

    points = {{450, 400}, {650, 500}, {480, 600}, {380, 420}, {450, 400}}
    obstacles[4] = Obstacle:create(points)

    points = {{80, 300}, {140, 300}, {140, 470}, {120, 470}, {80, 300}}
    obstacles[5] = Obstacle:create(points)
    radiant = Survey:create(obstacles)
    -- ray = Ray:create({width/2, height/2})


    -- local mouse = {0,0}
   
end

function love.update(dt)
    -- local x,y =  love.mouse:getPosition() 
    radiant:update()
    down = love.keyboard.isDown( 'w' )
    if(down) then
        radiant:forward()
    end
    -- ray:lineTo( { x,y},segmants)

end

function love.draw()
    for i=1,  #obstacles  do
        obstacles[i]:draw()
    end
    radiant:draw()
    -- ray:draw()
end

function love.keypressed(key,True)
    if(key =='w' )then
      
    end
end

function love.mousepressed(x, y,button,istouch,pressed)
    if button == 1 then
            mouse = {x,y}
    end
end

