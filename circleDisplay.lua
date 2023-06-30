local Slider = require 'slider'
local pi_image = love.graphics.newImage('pi.png')

local CircleDisplay = {}
CircleDisplay.__index = CircleDisplay

function CircleDisplay:new(canvasWidth, canvasHeight)
    local cd = {} 
    setmetatable(cd, self)

    cd.circleOffset = { x = canvasWidth/2 - 30,
				     y = canvasHeight/2  - 15}

	cd.smallCircleRadius = 4

    cd.radius = 30
	cd.radians = 0
	cd.radianSpeed = 2
	cd.radianSpeedDef = cd.radianSpeed

	cd.piOffset = 1.6

    local sx, sy = 20, 125
	local sxDiff = 70

    --[[ cd.sliders = {
        radians = Slider:new(sx, sy, 0, math.pi*2),
        radianSpeed = Slider:new(sx + sxDiff, sy, 0, 10, cd.radianSpeed)
    } ]]
	cd.sliders = {}
	cd.sliders.radians = Slider:new(sx, sy, 0, math.pi*2)
	cd.sliders.radianSpeed = Slider:new(sx + sxDiff, sy, 0, 10, cd.radianSpeed)
    
    return cd
end

function CircleDisplay:getSin() return math.sin(self.radians) end
function CircleDisplay:getCos() return math.cos(self.radians) end


function CircleDisplay:updateRadians(dt)
	if self.sliders.radians:isMouseDown() then
		self.radians = self.sliders.radians:getValue()
		self.radianSpeed = 0
	else
		self.radianSpeed = self.radianSpeedDef
	end

	self.radianSpeedDef = self.sliders.radianSpeed:getValue()

	self.radians = self.radians + dt*self.radianSpeed
	self.sliders.radians:setValue(self.radians)

	if self.radians >= math.pi*2 then self.radians = self.radians - math.pi*2  end
end

function CircleDisplay:update(dt, mousex, mousey)
	for i, slider in pairs(self.sliders) do
		slider:update(mousex, mousey)
	end
	self:updateRadians(dt)
end

function CircleDisplay:drawGui()
	love.graphics.print('sin ' .. tostring(math.round(self.radians, 1)) .. ': ', 5, 5)
	love.graphics.print(tostring(math.round(self:getSin(), 2)), 40, 5)
	self.sliders.radians:draw(tostring('rad: ' .. math.round(self.radians)))	
	self.sliders.radianSpeed:draw('speed: ' .. tostring(math.round(self.radianSpeed)))
end

function CircleDisplay:drawPi()
	love.graphics.setColor(1, 1, 1)	
	local iw, ih = pi_image:getWidth(), pi_image:getHeight()
    local sin, cos = self:getSin(), self:getCos()
    local r = self.radius
    local offset = self.piOffset
	love.graphics.draw(pi_image, cos * r * offset - 6, sin * r * offset, 0, 1, 1, iw/2, ih/2)
	love.graphics.print(tostring(math.round(self.radians/math.pi)), cos * r * offset + 6, sin * r * offset, 0, 1, 1, iw/2, ih/2 + 5)
end

function CircleDisplay:drawCircle()
	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.circle('line', 0, 0, self.radius)
	
    local sin, cos = self:getSin(), self:getCos()

	-- line connecting sin&cos and sin
	love.graphics.setColor(1, 1, 1)
	love.graphics.line(cos * self.radius, sin * self.radius, 0, sin * self.radius)

	-- sin and cos
	love.graphics.setColor(0.5, 0.5, 1)
	love.graphics.circle('fill', cos * self.radius, sin * self.radius, self.smallCircleRadius)
	-- sin
	love.graphics.setColor(1, 0.8, 0.5)
	love.graphics.circle('fill', 0, sin * self.radius, self.smallCircleRadius)
	if self.sliders.radians:isMouseDown() then self:drawPi() end	
end

function CircleDisplay:mousepressed(x, y, button)
	for i, s in pairs(self.sliders) do
		s:mousepressed(x, y, button)
	end
end

function CircleDisplay:draw()
    self:drawGui()

    love.graphics.translate(self.circleOffset.x, self.circleOffset.y)

    self:drawCircle()	
end

return CircleDisplay