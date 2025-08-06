local CircleComponent = require(game.ReplicatedStorage.Shared.Components.Circle)
local InterpolationComponent = require(game.ReplicatedStorage.Shared.Components.Interpolation)
local BallCreated = require(game.ReplicatedStorage.Shared.Events.BallCreated)

local BallGeneratorSystem = require(game.ReplicatedStorage.Kernel.System).extend()

function BallGeneratorSystem:afterLoad()

    local numBalls = 100
    local radius = 3
    local yPosition = 100
    local spacing = radius * 2.2
    local minDistance = spacing * 1.5

    for i = 1, numBalls do
        local x = -spacing * (i - 1)
        if math.abs(x) < minDistance then
            -- Saltar bolas muy cercanas al eje
        else
            local entity = self:createEntity()
            local position = Vector2.new(x, yPosition)

            local color = (i == 1) and Color3.new(1, 0, 0) or Color3.new(0, 0, 1)

            self:addComponent(entity, CircleComponent(radius, color, position))
            self:addComponent(entity, InterpolationComponent(x, yPosition))
            self:emit(BallCreated(entity))
        end
    end

end

return BallGeneratorSystem
