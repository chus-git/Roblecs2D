local LoadSceneEvent = require(script.Parent.Scenes.SelectExperienceMenu.Events.LoadSceneEvent)

local SceneManagerSystem = require(game.ReplicatedStorage.Core.System).extend()

function SceneManagerSystem:load()
	
	self.systems = {}
	
	self:on(LoadSceneEvent, function(scene)
		self:loadScene(scene)
	end)

end

function SceneManagerSystem:loadScene(SystemModules)

	print("[SceneManagerSystem] Loading scene")

	for _, system in ipairs(self.systems) do
		system:unload()
		system:destroy()
	end
	
	self.systems = self.create(SystemModules, self.eventManager, self.entityManager, self.componentManager, self.viewport, self.camera)
	
	for _, system in ipairs(self.systems) do
		system:load()
	end

	for _, system in ipairs(self.systems) do
		system:afterLoad()
	end
	
	print("[SceneManagerSystem] Loaded " .. #self.systems .. " systems")
	
end

function SceneManagerSystem:beforeUpdate(dt)
	for _, system in ipairs(self.systems) do
		system:beforeUpdate(dt)
	end
end

function SceneManagerSystem:update(dt)
	for _, system in ipairs(self.systems) do
		system:update(dt)
	end
end

function SceneManagerSystem:afterUpdate(dt)
	for _, system in ipairs(self.systems) do
		system:afterUpdate(dt)
	end
end

function SceneManagerSystem:render(dt, alpha)
	for _, system in ipairs(self.systems) do
		system:render(dt, alpha)
	end
end

return SceneManagerSystem
