local EnemySpawnSystem = require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SpeedComponent = require(game.ReplicatedStorage.Components.SpeedComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)
local HealthPointsComponent = require(game.ReplicatedStorage.Components.HealthPointsComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function EnemySpawnSystem:spawn()

    local enemy = self:createEntity()
    self:addComponent(enemy, EnemyTagComponent())
    self:addComponent(enemy, SpriteComponent(Sprites.ENEMY))
    self:addComponent(enemy, PositionComponent(math.random(-5, 5), math.random(-5, 5)))
    self:addComponent(enemy, VelocityComponent(0, 0))
    self:addComponent(enemy, AccelerationComponent(0, 0))
    self:addComponent(enemy, SpeedComponent(2))
    self:addComponent(enemy, CircleColliderComponent(0.5))
    self:addComponent(enemy, HealthPointsComponent(3))

end

function EnemySpawnSystem:init()
    for i = 1, 1 do
        self:spawn()
    end
end

return EnemySpawnSystem