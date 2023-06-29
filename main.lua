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

local sin, cos

local sinPoints
local sinPointsUnpacked
local sinPointSpeed
local sinTimer
local sinTimerMax

function math.round(num, place)
	place = place or 1
	local factor = 10^place
	local numx = num * factor
	local decimal = numx - math.floor(numx)
	return (decimal < 0.5 and math.floor(numx) or math.ceil(numx)) / factor
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
				     y = cHeight/2 }

	smallCircleRadius = 4

    radius = 30
	radians = 0
	radianSpeed = 2

	sin, cos = math.sin(radians), math.cos(radians)

	sinPoints = {}
	sinPointsUnpacked = {}
	sinPointSpeed = 35
	sinTimer = 0
	sinTimerMax = 0.1
end


function love.update(dt)

	radians = radians + dt*radianSpeed
	if radians >= math.pi*2 then radians = radians - math.pi*2 end
	
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

	love.graphics.setCanvas(canvas)
	 	love.graphics.clear()
	---- draw gui here
		love.graphics.print("Radians:\n" .. tostring(math.round(radians)) .. '\npi ' .. tostring(math.round(radians/math.pi)), 10, 10)

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

function love.keypressed(key)
	if key == 'escape' or 'q' then love.event.quit() end
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, canvasScale, canvasScale)
end