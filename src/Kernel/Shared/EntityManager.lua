local EntityManager = {}
EntityManager.__index = EntityManager

function EntityManager.new()
	local self = setmetatable({}, EntityManager)
	self.nextId = 0
	self.entities = {}
	return self
end

function EntityManager:createEntity()
	self.nextId = self.nextId + 1
	self.entities[self.nextId] = true
	return self.nextId
end

function EntityManager:destroyEntity(id)
	self.entities[id] = nil
end

return EntityManager