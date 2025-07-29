local Engine = {}
Engine.__index = Engine

function Engine.new(mainSystem, eventManager)
	local self = setmetatable({}, Engine)
	self.mainSystem = mainSystem
	self.eventManager = eventManager
	self:load()
	return self
end

function Engine:load()
	self.mainSystem:load()
	self.mainSystem:afterLoad()
end

function Engine:update(dt: number)
	self.mainSystem:beforeUpdate(dt)
	self.mainSystem:update(dt)
	self.mainSystem:afterUpdate(dt)
	self.eventManager:flush()
end

function Engine:render(dt: number, alpha: number)
	self.mainSystem:render(dt, alpha)
end

return Engine