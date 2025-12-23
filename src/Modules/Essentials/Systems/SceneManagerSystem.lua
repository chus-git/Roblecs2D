local LoadSceneEvent = require(game.ReplicatedStorage.Modules.Essentials.Events.LoadSceneEvent)

local SceneManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

function SceneManagerSystem:init()
	
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

	self.systems = self:create(SystemModules)

	for _, system in ipairs(self.systems) do
		system:load()
	end
	
	print("[SceneManagerSystem] Loaded " .. #self.systems .. " systems")
	
end

function SceneManagerSystem:update(dt)
	for _, system in ipairs(self.systems) do
		system:update(dt)
	end
end

function SceneManagerSystem:render(dt, alpha)
	for _, system in ipairs(self.systems) do
		system:render(dt, alpha)
	end
end

return SceneManagerSystem
