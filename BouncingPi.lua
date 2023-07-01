local assets = require 'assets'

local BouncingPi = {}
BouncingPi.__index = BouncingPi

function BouncingPi:new(x, y)
    local bp = {}
    setmetatable(bp, self)
    
    bp.position = {x = x, y = y}

    bp.jumpYVelocity = -120
    bp.yVelocityMax = 80
    bp.velocity = {
        x = math.random(-30, 30),
        y = math.random(bp.jumpYVelocity, bp.yVelocityMax)
    }
    bp.deltaY = 90
    bp.drawScale = math.random(2, 4)
    
    return bp
end

function BouncingPi:update(dt)
    self.velocity.y = self.velocity.y + self.deltaY * dt

    if self.velocity.y > self.yVelocityMax then 
        self.velocity.y = self.jumpYVelocity

        self.velocity.x = -self.velocity.x
        self.velocity.y = self.jumpYVelocity
    end 

    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt
end

function BouncingPi:draw()
    love.graphics.draw(assets.pi_image, math.round(self.position.x, 0), math.round(self.position.y, 0), 0, self.drawScale, self.drawScale)
end

return BouncingPi