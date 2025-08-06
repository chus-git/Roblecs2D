local Engine = {}
Engine.__index = Engine

function Engine.new(mainSystem, eventManager, loop)
	local self = setmetatable({}, Engine)
	self.mainSystem = mainSystem
	self.eventManager = eventManager
	self.loop = loop
	self:load()
	self:start()
	return self
end

function Engine:load()
	self.mainSystem:load()
	self.mainSystem:afterLoad()
end

function Engine:start()
	self.loop(self)
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

---


return Engine