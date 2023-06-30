local SineCurve = {}
SineCurve.__index = SineCurve

function SineCurve:new(circleRadius, maxPixelWidth)
    local sc = {}
    setmetatable(sc, self)

    sc.points = {}
    sc.pointsUnpacked = {}
    sc.speed = 35
    sc.pointTimer = 0
    sc.pointTimerMax = 0.05
	sc.circleRadius = circleRadius
	sc.maxPixelWidth = maxPixelWidth

	return sc
end

function SineCurve:update(dt, sin)

	self.pointTimer = self.pointTimer + dt
	if self.pointTimer >= self.pointTimerMax then
		self.pointTimer = self.pointTimer - self.pointTimerMax
		table.insert(self.points, {x = 0, y = sin * self.circleRadius})
	end

    self.pointsUnpacked = {}
	for i, p in ipairs(self.points) do
		p.x = p.x + self.speed * dt
		if p.x > self.maxPixelWidth then
			table.remove(self.points, i)
		end
		table.insert(self.pointsUnpacked, p.x)
		table.insert(self.pointsUnpacked, p.y)
	end
	-- connects sinpoints to sin circle
	table.insert(self.pointsUnpacked, 0)
	table.insert(self.pointsUnpacked, sin * self.circleRadius)
end

function SineCurve:draw()
    love.graphics.setColor(1, 1, 1)
    if #self.pointsUnpacked >= 4 then love.graphics.line(unpack(self.pointsUnpacked)) end
end

return SineCurve