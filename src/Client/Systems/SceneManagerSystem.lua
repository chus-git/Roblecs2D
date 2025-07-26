local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local SceneManagerSystem = Utils.extend(System)

function SceneManagerSystem:load()
	
	self.systems = {}
	
end

function SceneManagerSystem:loadScene(systems)

	print("[SceneManagerSystem] Loading scene")

	for _, system in ipairs(self.systems) do
		system:unload()
	end
	
	self.systems = self:createSystems(systems)
	
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
