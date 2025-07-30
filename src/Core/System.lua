local Utils = require(game.ReplicatedStorage.Core.Utils)

local System = {}
System.__index = System

function System.extend()
	return Utils.extend(System)
end

function System.create(SystemModuleOrList, eventManager, entityManager, componentManager, viewport, camera)
	local function instantiate(module)
		return require(module).new(eventManager, entityManager, componentManager, viewport, camera)
	end
	if typeof(SystemModuleOrList) == "table" and #SystemModuleOrList > 0 then
		local systems = {}
		for _, mod in ipairs(SystemModuleOrList) do
			table.insert(systems, instantiate(mod))
		end
		return systems
	else
		return instantiate(SystemModuleOrList)
	end
end


function System.new(eventManager, entityManager, componentManager, viewframe, camera)

	local self = setmetatable({}, System)
	self.eventManager = eventManager
	self.entityManager = entityManager
	self.componentManager = componentManager
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

-- Events

function System:on(eventFn, callback)
	local unsubscribe = self.eventManager:on(eventFn, callback)
	table.insert(self._eventUnsubscribers, unsubscribe)
end

function System:emit(eventFn, ...)
	return self.eventManager:emit(eventFn, ...)
end

function System:emitToServer(eventFn, ...)
	return self.eventManager:emitToServer(eventFn, ...)
end

function System:emitToClient(client, eventFn, ...)
	return self.eventManager:emitToClient(client, eventFn, ...)
end

function System:emitToAllClients(eventFn, ...)
	return self.eventManager:emitToAllClients(eventFn, ...)
end

-- Entities

function System:createEntity()
	return self.entityManager:createEntity()
end

function System:getEntitiesWithComponent(componentName)
	return self.componentManager:getEntitiesWithComponent(componentName)
end

function System:destroyEntity(entityId)
	self.componentManager:removeAllComponents(entityId)
	self.entityManager:destroyEntity(entityId)
end

-- Components

function System:addComponent(entityId, componentName, componentData)
	return self.componentManager:addComponent(entityId, componentName, componentData)
end

function System:getComponent(entityId, ...)
	return self.componentManager:getComponent(entityId, ...)
end

function System:getEntitiesWithComponent(componentName)
	return self.componentManager:getEntitiesWithComponent(componentName)
end

function System:hasComponent(entity, componentName)
	return self.componentManager:hasComponent(entity, componentName)
end

function System:removeComponent(entityId, componentName)
	return self.componentManager:removeComponent(entityId, componentName)
end

function System:removeAllComponents(entity)
	for componentName, entityMap in pairs(self.components) do
		entityMap[entity] = nil
	end
end

return System