local QueryManager = {}
QueryManager.__index = QueryManager

function QueryManager.new(entityManager, componentManager)
	local self = setmetatable({}, QueryManager)
	self.entityManager = entityManager
	self.componentManager = componentManager
	return self
end

function QueryManager:getEntitiesWithComponents(componentList)
	local results = {}
	for entity, _ in pairs(self.entityManager.entities) do
		local hasAll = true
		for _, compName in ipairs(componentList) do
			if not self.componentManager:hasComponent(entity, compName) then
				hasAll = false
				break
			end
		end
		if hasAll then
			table.insert(results, entity)
		end
	end
	return results
end

function QueryManager:getEntitiesWithComponent(component)
	return self.componentManager.components[component]
end

return QueryManager
