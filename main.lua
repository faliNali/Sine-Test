local CircleDisplay = require 'circleDisplay'

local windowWidth, windowHeight
local canvasWidth, canvasHeight
local canvas
local canvasScale
local circleOffset

local circleDisplay

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

	windowWidth, windowHeight = love.graphics.getDimensions()
	canvasScale = 4
	canvasWidth, canvasHeight = windowWidth / canvasScale, windowHeight / canvasScale

	canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
	canvas:setFilter('nearest', 'nearest')

	circleDisplay = CircleDisplay:new(canvasWidth, canvasHeight)

	sinPoints = {}
	sinPointsUnpacked = {}
	sinPointSpeed = 35
	sinTimer = 0
	sinTimerMax = 0.05
end


local function setCanvas()
	love.graphics.setCanvas(canvas)
		love.graphics.clear()
		
		circleDisplay:draw()

		love.graphics.setColor(1, 1, 1)
		if #sinPointsUnpacked >= 4 then love.graphics.line(unpack(sinPointsUnpacked)) end

	love.graphics.setCanvas()
end

local function updateSinPoints(dt)
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
end

function love.update(dt)

	local mousex, mousey = love.mouse.getPosition()
--[[
	for i, s in pairs(sliders) do
		s:update(mousex/canvasScale, mousey/canvasScale)
	end

	sinTimer = sinTimer + dt
	if sinTimer >= sinTimerMax then
		sinTimer = sinTimer - sinTimerMax
		table.insert(sinPoints, {0, sin * radius})
	end ]]

	circleDisplay:update(dt, mousex/canvasScale, mousey/canvasScale)

	updateSinPoints(dt)

	setCanvas()
end	

function love.mousepressed(x, y, button)
	circleDisplay:mousepressed(x/canvasScale, y/canvasScale, button)
end

function love.keypressed(key)
	if key == 'escape' or 'q' then love.event.quit() end
end

function love.draw()
	love.graphics.draw(canvas, 0, 0, 0, canvasScale, canvasScale)
end