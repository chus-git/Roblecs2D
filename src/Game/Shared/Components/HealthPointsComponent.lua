local HealthPointsComponent = require(game.ReplicatedStorage.Source.Component).extend()

HealthPointsComponent.name = "HealthPointsComponent"

HealthPointsComponent.constructor = function(health: number)
	return {
        currentHealth = health,
        maxHealth = health
    }
end

return HealthPointsComponent