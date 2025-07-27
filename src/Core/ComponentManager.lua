local ComponentManager = {}
ComponentManager.__index = ComponentManager

function ComponentManager.new()
	local self = setmetatable({}, ComponentManager)
	self.components = {}
	return self
end

function ComponentManager:addComponent(entity, componentName, componentData)
	self.components[componentName] = self.components[componentName] or {}
	self.components[componentName][entity] = componentData
	return componentData
end

function ComponentManager:removeComponent(entity, component)
	self.components[component.name][entity] = nil
end

function ComponentManager:getComponent(entity, component)
	return self.components[component.name][entity]
end

function ComponentManager:hasComponent(entity, componentName)
	return self.components[componentName] and self.components[componentName][entity] ~= nil
end

function ComponentManager:removeAllComponents(entity)
	for componentName, entityMap in pairs(self.components) do
		entityMap[entity] = nil
	end
end

return ComponentManager