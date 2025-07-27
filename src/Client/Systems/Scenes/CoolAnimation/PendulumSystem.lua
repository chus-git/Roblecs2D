local BallCreated = require(game.ReplicatedStorage.Shared.Events.BallCreated)
local CircleComponent = require(game.ReplicatedStorage.Shared.Components.Circle)
local PendulumSystem = require(game.ReplicatedStorage.Core.System).extend()

local GRAVITY = 9.81
local VELOCITY_MULTIPLIER = 20 -- para acelerar la oscilación

function PendulumSystem:load()
	self.balls = {}
	self.baseY = 100
	
	self:on(BallCreated, function(ballId)
        self:addBall(ballId)
    end)
end

function PendulumSystem:addBall(ballEntity)
	local circle = self:getComponent(ballEntity, CircleComponent)
	if not circle then return end
	
	local L = math.abs(circle.position.X)
	
	local ballState = {
		entity = ballEntity,
		length = L,
		theta = math.pi/2,  -- 45 grados inicio
		omega = 0,
		fixed = (L < 0.001) -- si L muy pequeño, bola fija
	}
	
	-- Para bola fija aseguramos posición en baseY (anclaje)
	if ballState.fixed then
		circle.position = Vector2.new(0, self.baseY)
	end
	
	table.insert(self.balls, ballState)
end

function PendulumSystem:update(dt)
    local g = GRAVITY
    local lengthExponent = 0.05 -- ajusta entre 0 (igual frecuencia) y 1 (frecuencia real)

    for _, ball in ipairs(self.balls) do
        if not ball.fixed then
            local theta = ball.theta
            local omega = ball.omega
            local L = ball.length
            
            -- aplicamos el exponente para suavizar la dependencia
            local effectiveLength = L^lengthExponent
            
            local alpha = -(g / effectiveLength) * math.sin(theta)
            
            omega = omega + alpha * dt * VELOCITY_MULTIPLIER
            theta = theta + omega * dt
            
            ball.theta = theta
            ball.omega = omega
            
            -- posición se calcula con la longitud real para mantener separación espacial
            local x = L * math.sin(theta)
            local y = self.baseY - L * math.cos(theta)
            
            local circle = self:getComponent(ball.entity, CircleComponent)
            if circle then
                circle.position = Vector2.new(x, y)
            end
        end
    end
end

return PendulumSystem
