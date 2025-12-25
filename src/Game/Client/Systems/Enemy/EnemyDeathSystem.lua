local EnemyDeathSystem = require(game.ReplicatedStorage.Source.System).extend()

local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local HealthPointsComponent = require(game.ReplicatedStorage.Components.HealthPointsComponent)

local DestroyEntityEvent = require(game.ReplicatedStorage.Events.DestroyEntityEvent)

function EnemyDeathSystem:update(dt)
	
	local enemies = self:getEntitiesWithComponent(EnemyTagComponent)
    for _, enemy in pairs(enemies) do
        local healthComp = self:getComponent(enemy, HealthPointsComponent)
        if healthComp.currentHealth <= 0 then
            self:fire(DestroyEntityEvent(enemy))
            self:destroyEntity(enemy)
        end
    end

end

return EnemyDeathSystem