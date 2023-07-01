local assets = require 'assets'

local BouncingPi = require 'BouncingPi'

local BouncingPiBackground = {}
BouncingPiBackground.__index = BouncingPiBackground

function BouncingPiBackground:new(canvasWidth, canvasHeight)
    local b = {}
    setmetatable(b, self)

    b.piInstances = {}
    b.canvasWidth, b.canvasHeight = canvasWidth, canvasHeight

    return b
end

function BouncingPiBackground:init()
    for i=0, 40 do
        table.insert(self.piInstances, BouncingPi:new(math.random(0, self.canvasWidth), math.random(0, self.canvasHeight)))
    end
end

function BouncingPiBackground:update(dt)
    local piWidth, piHeight = assets.pi_image:getDimensions()
    for i, bouncingPi in ipairs(self.piInstances) do
        bouncingPi:update(dt)
        
        if bouncingPi.position.y + piHeight*bouncingPi.drawScale < 0 then 
            table.remove(self.piInstances, i)
            local newBouncingPi = BouncingPi:new(math.random(0, self.canvasWidth), self.canvasHeight + piHeight * 4)
            table.insert(self.piInstances, newBouncingPi)
        end
    end

    print(#self.piInstances)
end

function BouncingPiBackground:draw()
    love.graphics.setColor(1, 1, 1, 0.2)
    for i, BouncingPi in ipairs(self.piInstances) do
        BouncingPi:draw()
    end
end

return BouncingPiBackground