local Engine = {}
Engine.__index = Engine

function Engine.new(mainSystem, eventManager, loop)
	local self = setmetatable({}, Engine)
	self.mainSystem = mainSystem
	self.eventManager = eventManager
	self.loop = loop
	self:start()
	return self
end

function Engine:start()
	self.mainSystem:load()
	self.loop(self)
end

function Engine:update(dt: number)
	self.mainSystem:update(dt)
	self.eventManager:flush()
end

function Engine:render(dt: number, alpha: number)
	self.mainSystem.camera.CameraType = Enum.CameraType.Scriptable
	self.mainSystem.camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, -1000), Vector3.new(0, 0, 0))
	self.mainSystem.camera.FieldOfView = 1
	self.mainSystem:render(dt, alpha)
end

---


return Engine