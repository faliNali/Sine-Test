local Slider = require 'slider'

local wWidth, wHeight
local cWidth, cHeight
local canvas
local canvasScale
local circleOffset

local smallCircleRadius

local radius
local radians
local radianSpeed
local radianSpeedDef

local sin, cos

local sinPoints
local sinPointsUnpacked
local sinPointSpeed
local sinTimer
local sinTimerMax

local sliders

local pi_image
local piOffset 

function math.round(num, place)
	place = place or 1
	local factor = 10^place
	local numx = num * factor
	local decimal = numx - math.floor(numx)
	return (decimal < 0.5 and math.floor(numx) or math.ceil(numx)) / factor
end

function math.clamp(num, min, max)
	return num < min and min or num > max and max or num
end

function InRect(x, y, rx, ry, rw, rh)
	return x >= rx and x <= rx+rw and y >= ry and y <= ry+rh	
end

function love.load()    
    love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setLineStyle('rough')

	local font = love.graphics.newFont('Pixeled.ttf', 5)
	love.graphics.setFont(font)

	wWidth, wHeight = love.graphics.getDimensions()
	canvasScale = 4
	cWidth, cHeight = wWidth / canvasScale, wHeight / canvasScale

	canvas = love.graphics.newCanvas(cWidth, cHeight)
	canvas:setFilter('nearest', 'nearest')

	circleOffset = { x = cWidth/2 - 30,
				     y = cHeight/2  - 15}

	smallCircleRadius = 4

    radius = 30
	radians = 0
	radianSpeed = 2
	radianSpeedDef = radianSpeed

	sin, cos = math.sin(radians), math.cos(radians)

	sinPoints = {}
	sinPointsUnpacked = {}
	sinPointSpeed = 35
	sinTimer = 0
	sinTimerMax = 0.05

	local sx, sy = 20, 125
	local sxDiff = 70

	sliders = {}
	sliders.radians = Slider:new(sx, sy, 0, math.pi*2)
	sliders.radianSpeed = Slider:new(sx + sxDiff, sy, 0, 6)
	sliders.radianSpeed:setValue(radianSpeed)

	pi_image = love.graphics.newImage('pi.png')
	piOffset = 1.6
end

local function setCanvas()
    love.graphics.setCanvas(canvas)
	 	love.graphics.clear()

	---- draw gui here
	 	love.graphics.print('sin ' .. tostring(math.round(radians, 1)) .. ': ', 5, 5)
		love.graphics.print(tostring(math.round(sin, 2)), 40, 5)
		sliders.radians:draw(tostring('rad: ' .. math.round(radians)))	
		sliders.radianSpeed:draw('speed: ' .. tostring(math.round(radianSpeed)))
		

	---- draw parts of circle here
		love.graphics.translate(circleOffset.x, circleOffset.y)
		-- circle
		love.graphics.setColor(0.5, 0.5, 0.5)
		love.graphics.circle('line', 0, 0, radius)
		
		-- sin and cos
		love.graphics.setColor(0.5, 0.5, 1)
		love.graphics.circle('fill', cos * radius, sin * radius, smallCircleRadius)
		-- sin
		love.graphics.setColor(1, 0.8, 0.5)
		love.graphics.circle('fill', 0, sin * radius, smallCircleRadius)

		--pi 
		if sliders.radians:isMouseDown() then
			love.graphics.setColor(1, 1, 1)	
			local iw, ih = pi_image:getWidth(), pi_image:getHeight()
			love.graphics.draw(pi_image, cos * radius * piOffset - 6, sin * radius * piOffset, 0, 1, 1, iw/2, ih/2)
			love.graphics.print(tostring(math.round(radians/math.pi)), cos * radius * piOffset + 6, sin * radius * piOffset, 0, 1, 1, iw/2, ih/2 + 5)
		end

		-- sin points
		--[[for i, s in ipairs(sinPoints) do
			love.graphics.circle('fill', circleOffset.x + s.x * radius, circleOffset.y + s.y * radius, 1)
		end]]

		-- sin lines
		love.graphics.setColor(1, 1, 1)
		if #sinPointsUnpacked >= 4 then love.graphics.line(unpack(sinPointsUnpacked)) end


		-- line connecting sin&cos and sin
		love.graphics.line(cos * radius, sin * radius, 0, sin * radius)

	love.graphics.setCanvas()
end

function love.update(dt)
	if sliders.radians:isMouseDown() then
		radians = sliders.radians:getValue()
		radianSpeed = 0
	else
		radianSpeed = radianSpeedDef
	end

	radianSpeedDef = sliders.radianSpeed:getValue()

	radians = radians + dt*radianSpeed
	sliders.radians:setValue(radians)

	if radians >= math.pi*2 then radians = radians - math.pi*2 end
	local mousex, mousey = love.mouse.getPosition()

	for i, s in pairs(sliders) do
		s:update(mousex/canvasScale, mousey/canvasScale)
	end
	sin, cos = math.sin(radians), math.cos(radians)

	sinTimer = sinTimer + dt
	if sinTimer >= sinTimerMax then
		sinTimer = sinTimer - sinTimerMax
		table.insert(sinPoints, {0, sin * radius})
	end

	sinPointsUnpacked = {}
	for i, s in ipairs(sinPoints) do
		s[1] = s[1] + sinPointSpeed * dt
		if s[1] > love.graphics.getWidth() - circleOffset.x then
			table.remove(sinPoints, i)
		end
		table.insert(sinPointsUnpacked, s[1])
		table.insert(sinPointsUnpacked, s[2])
	end
	-- connects sinpoints to sin circle
	table.insert(sinPointsUnpacked, 0)
	table.insert(sinPointsUnpacked, sin * radius)

	setCanvas()
end	

function love.mousepressed(x, y, button)
	for i, s in pairs(sliders) do
		s:mousepressed(x/canvasScale, y/canvasScale, button)
	end
end

function love.keypressed(key)
	if key == 'escape' or 'q' then love.event.quit() end
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, canvasScale, canvasScale)
end