local EnemyMovementSystem = require(game.ReplicatedStorage.Source.System).extend()
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SpeedComponent = require(game.ReplicatedStorage.Components.SpeedComponent)

local LERP_SMOOTHNESS = 5 -- Mayor valor = giro más rápido/brusco
local MAX_SPEED_MULTIPLIER = 1.2 -- Factor de velocidad máxima

function EnemyMovementSystem:update(dt)
	local _, player = next(self:getEntitiesWithComponent(PlayerTagComponent))
	if not player then return end

	local playerPos = self:getComponent(player, PositionComponent)
	local enemies = self:getEntitiesWithComponent(EnemyTagComponent)

	for enemy, _ in pairs(enemies) do
		local enemyPos = self:getComponent(enemy, PositionComponent)
		local enemyVel = self:getComponent(enemy, VelocityComponent)
		local enemySpeed = self:getComponent(enemy, SpeedComponent)

		if not enemyVel or not enemySpeed then continue end

		-- 1. Calcular dirección normalizada
		local dx = playerPos.x - enemyPos.x
		local dy = playerPos.y - enemyPos.y
		local distance = math.sqrt(dx * dx + dy * dy)

		if distance > 0 then
			local dirX = dx / distance
			local dirY = dy / distance

			-- 2. Definir velocidad deseada (Lineal)
			local targetVelX = dirX * enemySpeed.speed
			local targetVelY = dirY * enemySpeed.speed

			-- 3. Suavizado (Lerp) entre velocidad actual y deseada
			-- Esto evita cambios de dirección de 180º instantáneos
			enemyVel.x = enemyVel.x + (targetVelX - enemyVel.x) * (dt * LERP_SMOOTHNESS)
			enemyVel.y = enemyVel.y + (targetVelY - enemyVel.y) * (dt * LERP_SMOOTHNESS)

			-- 4. Capar la velocidad máxima (Magnitude Clamping)
			local currentSpeedSq = enemyVel.x * enemyVel.x + enemyVel.y * enemyVel.y
			local maxSpeed = enemySpeed.speed * MAX_SPEED_MULTIPLIER
			
			if currentSpeedSq > maxSpeed * maxSpeed then
				local ratio = maxSpeed / math.sqrt(currentSpeedSq)
				enemyVel.vx *= ratio
				enemyVel.vy *= ratio
			end
		end
	end
end

return EnemyMovementSystem