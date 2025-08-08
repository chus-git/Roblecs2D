local LoadSceneEvent = require(game.ReplicatedStorage.Source.Event).extend()

LoadSceneEvent.name = "LoadSceneEvent"

LoadSceneEvent.constructor = function(scene)
	return scene
end

return LoadSceneEvent