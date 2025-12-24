local GunGunMovementSystem = require(game.ReplicatedStorage.Source.System).extend()
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local GunTagComponent = require(game.ReplicatedStorage.Components.GunTagComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

local GUN_RADIUS = 1

function GunGunMovementSystem:updateDirection()
	local _, player = next(self:getEntitiesWithComponent(PlayerTagComponent))
	local _, gun = next(self:getEntitiesWithComponent(GunTagComponent))
	
	if not player or not gun then return end

	local playerPos = self:getComponent(player, PositionComponent)
	local gunRotation = self:getComponent(gun, RotationComponent)
	local enemies = self:getEntitiesWithComponent(EnemyTagComponent)

	local nearestEnemy = nil
	local nearestDistanceSq = math.huge

	for _, enemy in pairs(enemies) do
		local enemyPos = self:getComponent(enemy, PositionComponent)
		local dx = enemyPos.x - playerPos.x
		local dy = enemyPos.y - playerPos.y
		local dSq = dx * dx + dy * dy 

		if dSq < nearestDistanceSq then
			nearestDistanceSq = dSq
			nearestEnemy = enemy
		end
	end

	if nearestEnemy then
		local enemyPos = self:getComponent(nearestEnemy, PositionComponent)
		local dx = enemyPos.x - playerPos.x
		local dy = enemyPos.y - playerPos.y
		gunRotation.angle = math.atan2(-dy, dx)
	end
end

function GunGunMovementSystem:updatePosition()
	local _, player = next(self:getEntitiesWithComponent(PlayerTagComponent))
	local _, gun = next(self:getEntitiesWithComponent(GunTagComponent))
	
	if not player or not gun then return end

	local playerPos = self:getComponent(player, PositionComponent)
	local gunPos = self:getComponent(gun, PositionComponent)
	local gunRotation = self:getComponent(gun, RotationComponent)

	local angle = gunRotation.angle
	
	gunPos.x = playerPos.x + math.cos(angle) * GUN_RADIUS
	gunPos.y = playerPos.y + (-math.sin(angle) * GUN_RADIUS)
end

function GunGunMovementSystem:update(dt)
	self:updateDirection()
	self:updatePosition()
end

return GunGunMovementSystem