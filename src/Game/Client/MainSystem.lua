local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()
	
	self.sceneManagerSystem = self:create(game.ReplicatedStorage.Modules.Essentials.Systems.SceneManagerSystem)

	self.sceneManagerSystem:loadScene({

		script.Parent.Systems.Player.PlayerInitializationSystem,

		game.ReplicatedStorage.Modules.Physics.Systems.CollisionSystem,
		script.Parent.Systems.GunInitializationSystem,

		script.Parent.Systems.Player.PlayerMovementSystem,
		script.Parent.Systems.Enemy.EnemyMovementSystem,
		script.Parent.Systems.Enemy.EnemySpawnSystem,
		script.Parent.Systems.CollisionResolverSystem,
		script.Parent.Systems.MovementSystem,
		script.Parent.Systems.GunMovementSystem,

		script.Parent.Systems.ShootingSystem,
		script.Parent.Systems.BulletHealthSystem,
		script.Parent.Systems.BulletCollisionSystem,

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