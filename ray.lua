Ray = {}
Ray.__index = Ray

function Ray:create(origin,to)
    local ray = {}
    setmetatable(ray,Ray)
    ray.origin = origin
    ray.to = to
    ray.intersections =  {}
    ray.closest =nil
    return ray
end

function Ray:lineTo(to,segmants)
    self.to = to
    local intersections = {}
    self.closest = nil
    for i =1,#segmants do
      
        -- local intersect = self:intersection(segmants[i])
        local intersect = self:intersection(segmants[i][1])
        if (intersect ~= nil) then
            table.insert(intersections,intersect)
            if(self.closest == nil) then 
                self.closest = intersect
            else
                if(intersect.t1 <self.closest.t1) then
                    self.closest = intersect
                end
            end
        end
    end
    self.intersections = intersections

end

function Ray: draw()
    
    r,g,b,a = love.graphics.getColor()
    local to = self.to
 
    love.graphics.setColor(0,1,0)
    if(self.closest ~= nil) then
        to = {self.closest.x,self.closest.y}
    end
    love.graphics.line(self.origin[1],self.origin[2],to[1],to[2])


    -- for i = 1, #self.intersections do 
    --     local intersection = self.intersections[i]

    --     love.graphics.circle('fill',intersection.x,intersection.y,8)
    -- end
    -- if(self.closest ~= nil) then
    --     love.graphics.setColor(1,0,0)
    --     love.graphics.circle('fill',self.closest.x,self.closest.y,5)
    -- end

    love.graphics.setColor(r,g,b,a)
end

function Ray:intersection(segmant)

    local px = self.origin[1]
    local py = self.origin[2]
    local dx = self.to[1] - px
    local dy = self.to[2] - py

    local spx = segmant[1][1]
    local spy = segmant[1][2]
    local sdx = segmant[2][1] - spx
    local sdy = segmant[2][2] - spy
    
    local rmag = math.sqrt(dx*dx + dy*dy)
    local smag = math.sqrt(sdx*sdx + sdy*sdy)

    if ((dx/rmag == sdx/rmag) and (dy/rmag == sdy/rmag)) then
        return nil
    end

    local t2 = (dx*(spy - py )+ dy*(px-spx))/ (sdx * dy -sdy*dx)
    local t1 =  (spx + sdx*t2 - px)/dx

    if(t1<0) then
        return nil
    end

    if(t2 <0 or t2>1) then
        return nil
    end

    local x = px + dx * t1
    local y = py + dy * t1
    return {x = x , y = y , t1 = t1}

end