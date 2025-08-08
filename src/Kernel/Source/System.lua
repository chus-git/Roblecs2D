local Utils = require(game.ReplicatedStorage.Source.Utils)

local System = {}
System.__index = System

function System.extend()
	return Utils.extend(System)
end

function System:create(SystemModuleOrList)
	local function instantiate(module)
		local system = require(module).new(self.eventManager, self.entityManager, self.componentManager, self.world, self.camera, self.screenGui)
		system:init()
		return system
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

function System.new(eventManager, entityManager, componentManager, world, camera, screenGui)

	local self = setmetatable({}, System)
	self.eventManager = eventManager
	self.entityManager = entityManager
	self.componentManager = componentManager
	self.world = world
	self.camera = camera
	self.screenGui = screenGui
	
	self._eventUnsubscribers = {}
	
	return self

end

function System:init()
	--
end

function System:load()
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
	--
end

function System:destroy()
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

function System:removeComponent(entityId, componentName)
	return self.componentManager:removeComponent(entityId, componentName)
end

function System:hasComponent(entityId, componentName)
	return self.componentManager:hasComponent(entityId, componentName)
end

return System