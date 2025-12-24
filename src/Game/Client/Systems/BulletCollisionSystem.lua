local BulletCollisionSystem = require(game.ReplicatedStorage.Source.System).extend()
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local EnemyTagComponent = require(game.ReplicatedStorage.Components.EnemyTagComponent)
local BulletTagComponent = require(game.ReplicatedStorage.Components.BulletTagComponent)
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)
local DestroyEntityEvent = require(game.ReplicatedStorage.Events.DestroyEntityEvent)
local HealthPointsComponent = require(game.ReplicatedStorage.Components.HealthPointsComponent)

function BulletCollisionSystem:init()
	-- Escuchamos el evento de colisión
	self:onFire(OnCollideEvent, function(entityA, entityB)
		
		local isBulletA = self:hasComponent(entityA, BulletTagComponent)
		local isEnemyA = self:hasComponent(entityA, EnemyTagComponent)
		
		local isBulletB = self:hasComponent(entityB, BulletTagComponent)
		local isEnemyB = self:hasComponent(entityB, EnemyTagComponent)

		-- Comprobamos si la pareja es Bala + Enemigo
		if (isBulletA and isEnemyB) or (isBulletB and isEnemyA) then
			local bullet = isBulletA and entityA or entityB
			local enemy = isEnemyA and entityA or entityB
			
			self:handleBulletEnemyCollision(bullet, enemy)
		end
	end)
end

function BulletCollisionSystem:handleBulletEnemyCollision(bullet, enemy)

    local bulletHealth = self:getComponent(bullet, HealthPointsComponent)
	bulletHealth.currentHealth = 0

end

return BulletCollisionSystem