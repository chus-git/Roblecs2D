local EnemyMovementSystem= require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SpeedComponent = require(game.ReplicatedStorage.Components.SpeedComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function EnemyMovementSystem:update(dt)
    
    local player = self:getEntityWithComponent(PlayerTagComponent)

    local enemies = self:getEntitiesWithComponent(EnemyTagComponent)
    local playerPosition = self:getComponent(player, PositionComponent)

    for _, enemy in pairs(enemies) do
        
        local enemyPosition = self:getComponent(enemy, PositionComponent)
        local enemyAcceleration = self:getComponent(enemy, AccelerationComponent)
        local enemySpeed = self:getComponent(enemy, SpeedComponent)

        local dx = playerPosition.x - enemyPosition.x
        local dy = playerPosition.y - enemyPosition.y

        local length = math.sqrt(dx * dx + dy * dy)
        if length > 0 then
            dx /= length
            dy /= length
        end

        enemyAcceleration.x = enemyAcceleration.x + dx * enemySpeed.speed
        enemyAcceleration.y = enemyAcceleration.y + dy * enemySpeed.speed

    end
end


return EnemyMovementSystem