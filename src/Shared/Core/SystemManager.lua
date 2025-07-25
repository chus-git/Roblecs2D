local SystemManager = {}
SystemManager.__index = SystemManager

function SystemManager.new(eventBus, entityManager, componentManager, queryManager, viewframe, camera)
	local self = setmetatable({}, SystemManager)
	self.eventBus = eventBus
	self.entityManager = entityManager
	self.componentManager = componentManager
	self.queryManager = queryManager
	self.viewport = viewframe
	self.camera = camera
	return self
end

function SystemManager:createSystem(System)
	
	if typeof(System) == "Instance" and System:IsA("ModuleScript") then
		System = require(System)
	end

	local system = System.new(
		self,
		self.eventBus,
		self.entityManager,
		self.componentManager,
		self.queryManager,
		self.viewport,
		self.camera
	)
	
	return system
	
end

function SystemManager:createSystems(Systems)
	local systems = {}
	for _, System in ipairs(Systems) do
		table.insert(systems, self:createSystem(System))
	end
	return systems
end

return SystemManager