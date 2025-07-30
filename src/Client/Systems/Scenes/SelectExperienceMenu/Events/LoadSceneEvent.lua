local LoadSceneEvent = require(game.ReplicatedStorage.Core.Event).extend()

LoadSceneEvent.name = "LoadSceneEvent"

LoadSceneEvent.constructor = function(scene)
	return scene
end

return LoadSceneEvent