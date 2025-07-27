local Utils = require(game.ReplicatedStorage.Core.Utils)

local System = {}
System.__index = System

function System.extend()
	return Utils.extend(System)
end

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

function System:emit(eventFn, ...)
	return self.eventBus:emit(eventFn, ...)
end

function System:on(eventFn, callback)
	local unsubscribe = self.eventBus:on(eventFn, callback)
	table.insert(self._eventUnsubscribers, unsubscribe)
end

function System:emitToServer(eventFn, ...)
	return self.eventBus:emitToServer(eventFn, ...)
end

function System:emitToClient(client, eventFn, ...)
	return self.eventBus:emitToClient(client, eventFn, ...)
end

function System:emitToAllClients(eventFn, ...)
	return self.eventBus:emitToAllClients(eventFn, ...)
end

-- EntityManager proxies

function System:createEntity()
	return self.entityManager:createEntity()
end

function System:destroyEntity(entityId)
	self.componentManager:removeAllComponents(entityId)
	self.entityManager:destroyEntity(entityId)
end

-- ComponentManager proxies

function System:addComponent(entityId, componentName, componentData)
	local componentName = componentName
	return self.componentManager:addComponent(entityId, componentName, componentData)
end

function System:removeComponent(entityId, componentName)
	return self.componentManager:removeComponent(entityId, componentName)
end

function System:getComponent(entityId, ...)
	return self.componentManager:getComponent(entityId, ...)
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