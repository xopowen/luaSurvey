Survey = {}
Survey.__index = Survey

function Survey:create(obstacles)
    local radiant = {}
    setmetatable(radiant, Survey)
    radiant.n = n or 4
    -- стартовая позиция. нужно минять при движении
    radiant.position = {width / 2, height / 2 }
    radiant.dxdy = {}
    radiant.rays = {}
    radiant.unique = nil
    radiant.obstacles = obstacles
    radiant.segmants = {}
    radiant.center_ray = Ray:create(radiant.position,{0,0})
    for i=1, #obstacles do
        local points = obstacles[i].points
        for j=2,#points do
            table.insert(radiant.segmants,{{points[j],points[j-1]},i})   
        end
    end 
    print("total segmants = "..tostring(#radiant.segmants))

    return radiant
end

function Survey:getActiveSegment()
   
    local x, y = love.mouse.getPosition()
 
   
    for i=1, #self.obstacles do
        self.obstacles[i].is_draw = false
        local sig ={}
        local points = self.obstacles[i].points

        for j=2,#points do
            table.insert(sig,{{points[j],points[j-1]},i})   
        end
        
        for r=1,#self.rays do
            self.rays[r]:lineTo(self.rays[r].to,sig)
            if( #self.rays[r].intersections >1  ) then
                if( self.obstacles[i].is_draw ~= true) then
                    self.obstacles[i].is_draw = true
                end
            end
        end
        if( self.obstacles[i].is_draw == true) then
            break
        end
      
    end 
end


function Survey:forward()
 local distance = math.sqrt( math.pow(self.center_ray.to[2]-self.position[2],2 ) + math.pow(self.center_ray.to[1] - self.position[1],2))
 local angle = math.atan2( self.position[2] - self.center_ray.to[2],
                         self.position[1]- self.center_ray.to[1])


if( self.center_ray.closest ~= nil) then
      distance = math.sqrt( math.pow(self.center_ray.closest.y-self.position[2],2 ) + math.pow(self.center_ray.closest.x - self.position[1],2))
      angle = math.atan2( self.position[2] - self.center_ray.closest.y, 
                                self.position[1]-  self.center_ray.closest.x)
end
local dx = math.cos(angle)   
local dy = math.sin(angle)  
if(distance >10) then
    self.position = {self.position[1] - dx, self.position[2] - dy}
end
end


function Survey:update()
    self.rays = {}
    local x, y = love.mouse.getPosition()
    self.center_ray = Ray:create(radiant.position,{ x ,y })
    local angle_main = math.atan2( radiant.position[2] -y, radiant.position[1]-x)
    table.insert(self.rays,self.center_ray)

    for i = 1,10 do
        local anglem = angle_main -   0.52 / i  -3.14
        local anglep = angle_main +  0.52 / i -3.14

        local dx = math.cos(anglem)  *  500
        local dy = math.sin(anglem)  * 500
        local dxp = math.cos(anglep) * 500
        local dyp = math.sin(anglep) * 500
      
        table.insert(self.rays,Ray:create(radiant.position,{x+dx, y+dy}))
        table.insert(self.rays,Ray:create(radiant.position,{x+dxp, y+dyp}))

    end
    self:getActiveSegment()

end

function Survey:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.circle("fill", self.position[1], 
                         self.position[2], 5)
    -- table.sort(self.rays, 
    --             function(a, b) return (a.angle - b.angle) < 0 end)
    local closest = {}
    for i, ray in ipairs(self.rays) do
        ray:draw()
        -- if (ray.closest ~= nil) then
        --     table.insert(closest, ray.closest.x)
        --     table.insert(closest, ray.closest.y)
        -- end
    end
    love.graphics.setLineWidth(3)
    -- love.graphics.polygon("line", closest)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(r, g, b, a)
end

