local Slider = {}
Slider.__index = Slider

function Slider:new(x, y)
    local s = {}
    setmetatable(s, self)

    s.pos = {x = x, y = y}
    s.test = 'hello'

    return s
end

function Slider:draw()
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, 100, 10)
end

return Slider