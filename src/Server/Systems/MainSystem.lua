local MainSystem = require(game.ReplicatedStorage.Core.System).extend()

function MainSystem:load()
	self.playerSystem = self:createSystem(game.ServerScriptService.Server.Systems.PlayerSystem)
    self.playerSystem:load()
    self.playerSystem:afterLoad()
end

return MainSystem