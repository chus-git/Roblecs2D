local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:load()
	self.playerSystem = self.create(game.ReplicatedStorage.Systems.PlayerSystem, self.eventManager, self.entityManager, self.componentManager, self.world, self.camera)
    self.playerSystem:load()
    self.playerSystem:afterLoad()
end

return MainSystem