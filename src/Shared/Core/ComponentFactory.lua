local ComponentFactory = {}
ComponentFactory.__index = ComponentFactory

function ComponentFactory.new(componentFactories: { any })
	local self = setmetatable({}, ComponentFactory)
	self.componentFactories = componentFactories
	return self
end

function ComponentFactory:create(name: string, ...)
	local constructor = self.componentFactories[name]
	assert(constructor, "Component not registered: " .. name)
	return constructor(...)
end

return ComponentFactory