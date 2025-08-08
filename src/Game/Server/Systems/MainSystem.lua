local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()
	self.playerSystem = self:create(game.ReplicatedStorage.Modules.Essentials.Systems.PlayerSystem)
    self.playerSystem:init()
    self.playerSystem:load()
end

return MainSystem