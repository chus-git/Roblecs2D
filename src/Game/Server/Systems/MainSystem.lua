local MainSystem = require(game.ReplicatedStorage.Kernel.System).extend()

function MainSystem:load()
	self.playerSystem = self.create(game.ServerScriptService.Server.Systems.PlayerSystem, self.eventManager, self.entityManager, self.componentManager, self.world, self.camera)
    self.playerSystem:load()
    self.playerSystem:afterLoad()
end

return MainSystem