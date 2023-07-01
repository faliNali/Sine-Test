local CircleDisplay
local BouncingPiBackground
local assets 

local windowWidth, windowHeight
local canvasWidth, canvasHeight
local canvas
local canvasScale

local circleDisplay
local bouncingPiBackground


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

	CircleDisplay = require 'CircleDisplay'
	BouncingPiBackground = require 'BouncingPiBackground'
	assets = require 'assets'

	love.graphics.setFont(assets.font)

	windowWidth, windowHeight = love.graphics.getDimensions()
	canvasScale = 4
	canvasWidth, canvasHeight = windowWidth / canvasScale, windowHeight / canvasScale

	canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
	canvas:setFilter('nearest', 'nearest')

	circleDisplay = CircleDisplay:new(canvasWidth, canvasHeight)

	bouncingPiBackground = BouncingPiBackground:new(canvasWidth, canvasHeight)
	bouncingPiBackground:init()
end


local function setCanvas()
	love.graphics.setCanvas(canvas)
		love.graphics.clear()
		
		bouncingPiBackground:draw()
		circleDisplay:draw()

	love.graphics.setCanvas()
end

function love.update(dt)

	local mousex, mousey = love.mouse.getPosition()

	circleDisplay:update(dt, mousex/canvasScale, mousey/canvasScale)
	bouncingPiBackground:update(dt)

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