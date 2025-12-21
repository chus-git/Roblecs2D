local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()
	
	self.sceneManagerSystem = self:create(game.ReplicatedStorage.Modules.Essentials.Systems.SceneManagerSystem)

	self.sceneManagerSystem:loadScene({
		script.Parent.Systems.PlayerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.SpriteManagerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.InterpolationSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.RenderSystem,
		game.ReplicatedStorage.Modules.Physics.Systems.PhysicsSystem,
		
	})
	
end

function MainSystem:beforeUpdate(dt)
	self.sceneManagerSystem:beforeUpdate(dt)
end

function MainSystem:update(dt)
	self.sceneManagerSystem:update(dt)
end

function MainSystem:afterUpdate(dt)
	self.sceneManagerSystem:afterUpdate(dt)
end

function MainSystem:render(dt, alpha)
	self.sceneManagerSystem:render(dt, alpha)
end

return MainSystem