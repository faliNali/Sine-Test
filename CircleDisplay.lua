local Slider = require 'Slider'
local SineCurve = require 'SineCurve'
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

	cd.sineCurve = SineCurve:new(cd.radius, canvasWidth - cd.circleOffset.x)
    
    return cd
end

function CircleDisplay:getSin() return -math.sin(self.radians) end
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
	self.sineCurve:update(dt, self:getSin())
end

function CircleDisplay:drawGui()
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('sin ' .. tostring(math.round(self.radians, 1)), 5, 5)
	love.graphics.print('  =  ' .. tostring(math.round(-self:getSin(), 2)), 30, 5)
	self.sliders.radians:draw(tostring('rad: ' .. math.round(self.radians)))	
	self.sliders.radianSpeed:draw('speed: ' .. tostring(math.round(self.radianSpeed)))
end

function CircleDisplay:drawPi()
	local x = math.round(self:getCos() * self.radius * self.piOffset, 0)
	local y = math.round(self:getSin() * self.radius * self.piOffset, 0)
	local xOffset, yOffset = math.round(pi_image:getWidth(), 0)/2, math.round(pi_image:getHeight()/2, 0)

	love.graphics.draw(pi_image, x - 6, y, 0, 1, 1, xOffset, yOffset)
	love.graphics.print(tostring(math.round(self.radians/math.pi)), x + 6, y, 0, 1, 1, xOffset, yOffset + 5)
end

function CircleDisplay:drawCircle()
	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.circle('line', 0, 0, self.radius)
	
    local sin, cos = self:getSin() * self.radius, self:getCos() * self.radius

	-- line connecting sin&cos and sin
	love.graphics.setColor(1, 1, 1)
	love.graphics.line(cos, sin, 0, sin)

	-- line connecting sin and origin
	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.line(0, sin, 0, 0)

	-- sin and cos
	love.graphics.setColor(0.5, 0.5, 1)
	love.graphics.circle('fill', cos, sin, self.smallCircleRadius)
	-- sin
	love.graphics.setColor(1, 0.8, 0.5)
	love.graphics.circle('fill', 0, sin, self.smallCircleRadius)
	-- pi
	love.graphics.setColor(1, 1, 1)	
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

	self.sineCurve:draw()
end

return CircleDisplay