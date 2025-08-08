local PlayerComponent = require(game.ReplicatedStorage.Source.Component).extend()

PlayerComponent.name = "PlayerComponent"

PlayerComponent.constructor = function(id: number, name: string)
	return {
		id = id,
        name = name
	}
end

return PlayerComponent