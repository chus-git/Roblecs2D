local BulletHealthSystem = require(game.ReplicatedStorage.Source.System).extend()

local BulletTagComponent = require(game.ReplicatedStorage.Components.BulletTagComponent)
local HealthPointsComponent = require(game.ReplicatedStorage.Components.HealthPointsComponent)

local DestroyEntityEvent = require(game.ReplicatedStorage.Events.DestroyEntityEvent)

function BulletHealthSystem:update(dt)
	
	local bullets = self:getEntitiesWithComponent(BulletTagComponent)
    for _, bullet in pairs(bullets) do
        local healthComp = self:getComponent(bullet, HealthPointsComponent)
        healthComp.currentHealth = healthComp.currentHealth - dt * 10
        if healthComp.currentHealth <= 0 then
            self:fire(DestroyEntityEvent(bullet))
            self:destroyEntity(bullet)
        end
    end

end

return BulletHealthSystem