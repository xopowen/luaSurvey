-- RadiantUnique = {}
-- RadiantUnique.__index = RadiantUnique


-- function RadiantUnique:create(n)
--     local radiant = {}
--     setmetatable(radiant,RadiantUnique)
    
--     radiant.n = n or 4
--     radiant.position = {0,0}
--     radiant.dxdy = {}
--     radiant.rays = {}
--     radiant.unique =nil
--     return radiant
-- end
-- function RadiantUnique:update(segmants)
--     if(self.unique == nil) then
--         local unique = {}
--         for i = 1, #segmants do
--             local p1 = segmants[i][1]
--             local p2 = segmants[i][2]

--             local key1 = tostring(p1[1]).." ".. tostring(p1[2])
--             local key2 = tostring(p2[1]).." ".. tostring(p2[2])

--             if(unique[key1] == nil) then
--                 unique[key1] = p1

--             end
--             if(unique[key2] == nil) then
--                 unique[key2] = p2
--             end
--         end
--         self.unique = {}

--         local c = 1
--         for k,v in pairs(unique) do
--             self.unique[c] = v

--             table.insert(self.rays,Ray:create(radiant.position,{0,0}))
--             table.insert(self.rays,Ray:create(radiant.position,{0,0}))
--             table.insert(self.rays,Ray:create(radiant.position,{0,0}))

--             c = c + 1
--         end
--     end
--     local x,y = love.mouse.getPosition()
--     self.position[1] = x
--     self.position[2] = y
--     local angels = {}

--     for i = 1 , #self.unique do
--         local p  = self.unique[i]
--         local angle = math.atan2(p[2]-y,p[1]-x)
--         local anglem = angle -0.00001
--         local anglep = angle  + 0.00001

--         local dx = math.cos(anglem)
--         local dy = math.sin(anglem)

--         self.rays[(i-1)*3 + 1]:lineTo ({x+dy,y+dy},segmants)
--         self.rays[(i-1)*3 + 1].angle = anglem

--         local dx = math.cos(angle)
--         local dy = math.sin(angle)

--         self.rays[(i-1)*3 + 2]:lineTo ({x+dy,y+dy},segmants)
--         self.rays[(i-1)*3 + 2].angle = angle

--         local dx = math.cos(anglep)
--         local dy = math.sin(anglep)

--         self.rays[(i-1)*3 + 3]:lineTo ({x+dy,y+dy},segmants)
--         self.rays[(i-1)*3 + 3].angle = anglep

--     end
-- end

-- function RadiantUnique:draw()

--     r,g,b,a = love.graphics.getColor()
--     love.graphics.setColor(0,1,0,1)

--     love.graphics.circle('fill',self.position[1],self.position[2],5)

--     for i=1, #self.rays do
--         self.rays[i]:draw()
--     end
--     table.sort(self.rays, function(a,b) return (a.angle - b.angle) < 0 end)
--     local closest = {}
--     for i, ray in ipairs(self.rays) do
--         ray:draw()
--         if(ray.closest ~= nil) then
--             table.insert(closest,ray.closest.x)
--             table.insert(closest,ray.closest.y)
--         end
--     end
--     love.graphics.setLineWidth(3)
--     love.graphics.polygon('line',closest)
--     love.graphics.setLineWidth(1)

--     love.graphics.setColor(r,g,b,a)

-- end

RadiantUnique = {}
RadiantUnique.__index = RadiantUnique

function RadiantUnique:create(obstacles)
    local radiant = {}
    setmetatable(radiant, RadiantUnique)
    radiant.n = n or 4
    radiant.position = {0, 0}
    radiant.dxdy = {}
    radiant.rays = {}
    radiant.unique = nil
    radiant.obstacles = obstacles
    radiant.segmants = {}
    for i=1, #obstacles do
        local points = obstacles[i].points
        for j=2,#points do
            table.insert(radiant.segmants,{points[j-1],points[j],i})   
        end
    end 
    print("total segmants = "..tostring(#radiant.segmants))

    return radiant
end

function RadiantUnique:update()
    local segments = self.segmants
    local x, y = love.mouse.getPosition()
    self.position[1] = width / 2
    self.position[2] = height / 2 
    local angle_main = math.atan2( height/2 - y, width/2 - x)

    if (self.unique == nil) then
        local unique = {}
        for i=1, #segments do
            -- self.obstacles[segments[i][3]].is_draw = false
            local p1 = segments[i][1]
            local p2 = segments[i][2]
            
            local key1 = tostring(p1[1]) .. " " .. tostring(p1[2])
            local key2 = tostring(p2[1]) .. " " .. tostring(p2[2])
            if (unique[key1] == nil) then
                unique[key1] = p1
            end
            if (unique[key2] == nil) then
                unique[key2] = p2
            end
        end
        self.unique = {}
        local c = 1
        for k, v in pairs(unique) do
            self.unique[c] = v
            table.insert(self.rays, Ray:create(radiant.position,
                                                {0, 0}))
            table.insert(self.rays, Ray:create(radiant.position,
            {0, 0}))
            table.insert(self.rays, Ray:create(radiant.position,
                                                {0, 0}))
            c = c + 1
        end
    end


    for i=1, #self.unique do
        
        local p = self.unique[i]
        local angle = math.atan2(p[2] - y, p[1] - x)
        local anglem = angle - 0.01
        local anglep = angle + 0.01

        self.obstacles[segments[i][3]].is_draw = false
       

        local dx = math.cos(anglem)
        local dy = math.sin(anglem)
        self.rays[(i-1)* 3 + 1]:lineTo({x+dx, y+dy}, segments)
        self.rays[(i-1)* 3 + 1].angle = anglem

        dx = math.cos(angle)
        dy = math.sin(angle)
        self.rays[(i-1)* 3 + 2]:lineTo({x+dx, y+dy}, segments)
        self.rays[(i-1)* 3 + 2].angle = angle

        if (self.rays[(i-1)* 3 + 2].closest ~= nil) then
            self.obstacles[segments[i][3]].is_draw = true
        end


        dx = math.cos(anglep)
        dy = math.sin(anglep)
        self.rays[(i-1)* 3 + 3]:lineTo({x+dx, y+dy}, segments)
        self.rays[(i-1)* 3 + 3].angle = anglep
    end
 
end

function RadiantUnique:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.circle("fill", self.position[1], 
                         self.position[2], 5)
    table.sort(self.rays, 
                function(a, b) return (a.angle - b.angle) < 0 end)
    local closest = {}
    for i, ray in ipairs(self.rays) do
        -- ray:draw()
        if (ray.closest ~= nil) then
            table.insert(closest, ray.closest.x)
            table.insert(closest, ray.closest.y)
        end
    end
    love.graphics.setLineWidth(3)
    love.graphics.polygon("line", closest)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(r, g, b, a)
end