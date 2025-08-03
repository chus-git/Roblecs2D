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

function System:on(event, callback)
	local unsubscribe = self.eventManager:on(event, callback)
	table.insert(self._eventUnsubscribers, unsubscribe)
end

function System:emit(event, ...)
	return self.eventManager:emit(event, ...)
end

function System:emitToServer(event, ...)
	return self.eventManager:emitToServer(event, ...)
end

function System:emitToClient(client, event, ...)
	return self.eventManager:emitToClient(client, event, ...)
end

function System:emitToAllClients(event, ...)
	return self.eventManager:emitToAllClients(event, ...)
end

-- Entities

function System:createEntity()
	return self.entityManager:createEntity()
end

function System:getEntitiesWithComponent(componentName)
	return self.componentManager:getEntitiesWithComponent(componentName)
end

function System:getEntitiesWithComponent(componentName)
	return self.componentManager:getEntitiesWithComponent(componentName)
end

function System:destroyEntityAndComponents(entityId)
	self.componentManager:removeAllComponents(entityId)
	self.entityManager:destroyEntity(entityId)
end

-- Components

function System:addComponentToEntity(entityId, componentName, componentData)
	return self.componentManager:addComponentToEntity(entityId, componentName, componentData)
end

function System:getComponentFromEntity(entityId, ...)
	return self.componentManager:getComponentFromEntity(entityId, ...)
end

function System:removeComponentFromEntity(entityId, componentName)
	return self.componentManager:removeComponentFromEntity(entityId, componentName)
end

return System