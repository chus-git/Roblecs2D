local ComponentManager = {}
ComponentManager.__index = ComponentManager

function ComponentManager.new()
	local self = setmetatable({}, ComponentManager)
	self.components = {}
	return self
end

function ComponentManager:addComponent(entity, ...)
	local componentName, component = ...
	assert(type(componentName) == "string" and type(component) == "table")
	self.components[componentName] = self.components[componentName] or {}
	self.components[componentName][entity] = component
	return component
end

function ComponentManager:removeComponent(entity, componentName)
	self.components[componentName][entity] = nil
end

function ComponentManager:getComponent(entity, componentName)
	return self.components[componentName][entity]
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