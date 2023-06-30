local Slider = {}
Slider.__index = Slider

function Slider:new(x, y, min, max, startValue)
    local s = {}
    setmetatable(s, self)

    s.pos = {x = x, y = y}
    s.rect = {w = 60, h = 12}
    s.handleWidth = 11 

    s.value = 0  
    s.range = {min = min, max = max}
    if startValue then
        s:setValue(startValue)
    end
    
    s.mouseDown = false
    s.mouseJustPressed = false

    return s
end

function Slider:getHandleDimensions()
    return self.pos.x + self.value*self.rect.w - self.handleWidth/2, self.pos.y, self.handleWidth, self.rect.h
end

function Slider:setValue(newValue)
    self.value = (newValue - self.range.min) / (self.range.max - self.range.min)
end

function Slider:getValue()
    return self.value * (self.range.max - self.range.min)
end

function Slider:isMouseDown() return self.mouseDown end

function Slider:inRect(x, y)
    return InRect(x, y, self.pos.x, self.pos.y, self.rect.w, self.rect.h)
end
function Slider:mousepressed(x, y, button)
    if button == 1 and self:inRect(x, y) then
        self.mouseJustPressed = true
        print('wow')
    end
end

function Slider:update(mousex, mousey)
    if (self:inRect(mousex, mousey) or self.mouseDown) and self.mouseJustPressed and love.mouse.isDown(1) then
        self.mouseDown = true
        self.value = math.clamp((mousex - self.pos.x)/self.rect.w, 0, 1)
    else
        self.mouseDown = false
        self.mouseJustPressed = false
    end
end

function Slider:draw(text)
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.rect.w, self.rect.h)

    love.graphics.setColor(1, 1, 1)
    local x, y, w, h = self:getHandleDimensions()
    love.graphics.rectangle('fill', x, y, w, h)

    love.graphics.print(text, self.pos.x, self.pos.y - 14)
end

return Slider