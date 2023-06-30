local CircleDisplay = require 'CircleDisplay'

local windowWidth, windowHeight
local canvasWidth, canvasHeight
local canvas
local canvasScale

local circleDisplay


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
end


local function setCanvas()
	love.graphics.setCanvas(canvas)
		love.graphics.clear()
		
		circleDisplay:draw()

	love.graphics.setCanvas()
end

function love.update(dt)

	local mousex, mousey = love.mouse.getPosition()

	circleDisplay:update(dt, mousex/canvasScale, mousey/canvasScale)

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