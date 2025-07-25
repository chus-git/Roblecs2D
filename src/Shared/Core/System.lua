local System = {}
System.__index = System

function System.new(systemManager, eventBus, entityManager, componentManager, queryManager, viewframe, camera)
	local self = setmetatable({}, System)
	self.systemManager = systemManager
	self.eventBus = eventBus
	self.entityManager = entityManager
	self.componentManager = componentManager
	self.queryManager = queryManager
	self.viewport = viewframe
	self.camera = camera
	
	self._eventUnsubscribers = {}
	
	return self
end

function System:load()
	--
end

function System:afterLoad()
	--
end

function System:beforeUpdate(dt)
	--
end

function System:update(dt)
	--
end

function System:afterUpdate(dt)
	--
end

function System:render(dt, alpha)
	--
end

function System:unload()
	for _, unsub in ipairs(self._eventUnsubscribers) do
		pcall(unsub)
	end
	self._eventUnsubscribers = {}
end

-- SystemManager proxies

function System:createSystem(System)
	return self.systemManager:createSystem(System)
end

function System:createSystems(Systems)
	return self.systemManager:createSystems(Systems)
end

-- EventBus proxies

function System:emit(eventName, ...)
	return self.eventBus:emit(eventName, ...)
end

function System:on(eventName, callback)
	local unsubscribe = self.eventBus:on(eventName, callback)
	table.insert(self._eventUnsubscribers, unsubscribe)
end

-- EntityManager proxies

function System:createEntity()
	return self.entityManager:createEntity()
end

function System:destroyEntity(entityId)
	self.componentManager:removeAllComponentsForEntity(entityId)
	self.entityManager:destroyEntity(entityId)
end

-- ComponentManager proxies

function System:addComponent(entityId, componentName, ...)
	local componentName = componentName
	return self.componentManager:addComponent(entityId, componentName, ...)
end

function System:removeComponent(entityId, componentName)
	return self.componentManager:removeComponent(entityId, componentName)
end

function System:getComponent(entityId, componentName)
	return self.componentManager:getComponent(entityId, componentName)
end

-- QueryManager proxies

function System:getEntitiesWithComponents(...)
	return self.queryManager:getEntitiesWithComponents(...)
end

function System:getEntitiesWithComponent(componentName)
	return self.queryManager:getEntitiesWithComponent(componentName)
end

function System:getEntity(componentName)
	return self:getEntitiesWithComponent(componentName)[1]
end

return System