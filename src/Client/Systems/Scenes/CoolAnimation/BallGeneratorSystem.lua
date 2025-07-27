local System = require(game.ReplicatedStorage.Core.System)
local CircleComponent = require(game.ReplicatedStorage.Shared.Components.Circle)

local BallGeneratorSystem = System.extend()

function BallGeneratorSystem:load()
    local entity = self:createEntity()
    self:addComponent(entity, CircleComponent(5, Color3.new(1, 0, 0), Vector2.new(0, 0)))
    self:getComponent(entity, CircleComponent)
end

return BallGeneratorSystem