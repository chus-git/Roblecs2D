local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()
	
	self.sceneManagerSystem = self:create(game.ReplicatedStorage.Modules.Essentials.Systems.SceneManagerSystem)

	self.sceneManagerSystem:loadScene({

		game.ReplicatedStorage.Modules.Physics.Systems.CollisionSystem,

		script.Parent.Systems.ParticleGeneratorSystem,
		script.Parent.Systems.ContainerSystem,
		script.Parent.Systems.GravitySystem,
		script.Parent.Systems.MovementSystem,
		script.Parent.Systems.BoundingSystem,
		script.Parent.Systems.ParticleCollisionSystem,
		script.Parent.Systems.BackgroundSystem,
		script.Parent.Systems.SimulationControlSystem,

		game.ReplicatedStorage.Modules.Essentials.Systems.SpriteManagerSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.InterpolationSystem,
		game.ReplicatedStorage.Modules.Essentials.Systems.RenderSystem,
		
	})
	
end

function MainSystem:update(dt)
	self.sceneManagerSystem:update(dt)
end

function MainSystem:render(dt, alpha)
	self.sceneManagerSystem:render(dt, alpha)
end

return MainSystem