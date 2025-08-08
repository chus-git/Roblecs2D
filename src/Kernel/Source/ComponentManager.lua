local ComponentManager = {}
ComponentManager.__index = ComponentManager

function ComponentManager.new()
	local self = setmetatable({}, ComponentManager)
	self.components = {}
	self.entitiesByComponent = {}
	return self
end

function ComponentManager:addComponent(entity, componentName, componentData)
	self.components[componentName] = self.components[componentName] or {}
	self.components[componentName][entity] = componentData
	self.entitiesByComponent[componentName] = self.entitiesByComponent[componentName] or {}
	self.entitiesByComponent[componentName][entity] = entity
	return componentData
end

function ComponentManager:getComponent(entity, component)
	return self.components[component.name][entity]
end

function ComponentManager:getEntitiesWithComponent(component)
	return self.entitiesByComponent[component.name]
end

function ComponentManager:hasComponent(entity, component)
	return self.components[component.name][entity] ~= nil
end

function ComponentManager:removeComponent(entity, component)
	self.components[component.name][entity] = nil
	self.entitiesByComponent[component.name][entity] = nil
end

function ComponentManager:removeAllComponents(entity)
	for componentName, components in pairs(self.components) do
		if components[entity] then
			components[entity] = nil
			self.entitiesByComponent[componentName][entity] = nil
		end
	end
end

return ComponentManager