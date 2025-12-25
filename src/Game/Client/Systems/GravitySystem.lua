local GravitySystem = require(game.ReplicatedStorage.Source.System).extend()

local BallTagComponent = require(game.ReplicatedStorage.Components.BallTagComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

function GravitySystem:init()
    -- Valor positivo si Y aumenta hacia abajo, negativo si aumenta hacia arriba
    self.GRAVITY_FORCE = -9.81
end

function GravitySystem:update(dt)
    local balls = self:getEntitiesWithComponent(BallTagComponent)

    for _, ball in pairs(balls) do
        local accComp = self:getComponent(ball, AccelerationComponent)
        
        -- Solo modificamos la aceleración
        accComp.y = self.GRAVITY_FORCE
    end
end

return GravitySystem