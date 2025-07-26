local ComponentManager = {}
ComponentManager.__index = ComponentManager

function ComponentManager.new(componentFactory)
	local self = setmetatable({}, ComponentManager)
	self.componentFactory = componentFactory
	self.components = {}
	return self
end

function ComponentManager:addComponentToEntity(entity, componentName, ...)
	self.components[componentName] = self.components[componentName] or {}
	local component = self.componentFactory:create(componentName, ...)
	self.components[componentName][entity] = component
	return component
end

function ComponentManager:removeComponentForEntity(entity, componentName)
	self.components[componentName][entity] = nil
end

function ComponentManager:getComponentForEntity(entity, componentName)
	return self.components[componentName][entity]
end

function ComponentManager:hasComponent(entity, componentName)
	return self.components[componentName] and self.components[componentName][entity] ~= nil
end

function ComponentManager:removeAllComponentsForEntity(entity)
	for componentName, entityMap in pairs(self.components) do
		entityMap[entity] = nil
	end
end

return ComponentManager