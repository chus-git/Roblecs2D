local UserInputService = game:GetService("UserInputService")
local ShootingSystem = require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local GunTagComponent = require(game.ReplicatedStorage.Components.GunTagComponent)
local BulletTagComponent = require(game.ReplicatedStorage.Components.BulletTagComponent)
local HealthPointsComponent = require(game.ReplicatedStorage.Components.HealthPointsComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local OnShootEvent = require(game.ReplicatedStorage.Events.OnShootEvent)
local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

local BULLET_SPEED = 10
local FIRE_RATE = 0.1

function ShootingSystem:init()
	self.cooldownTimer = 0
end

function ShootingSystem:shoot(position, direction, angle)
	local bullet = self:createEntity()
    self:addComponent(bullet, BulletTagComponent())
	self:addComponent(bullet, SpriteComponent(Sprites.BULLET))
	self:addComponent(bullet, PositionComponent(position.x, position.y))
	self:addComponent(bullet, RotationComponent(angle))
	self:addComponent(bullet, AccelerationComponent(0, 0))
    self:addComponent(bullet, HealthPointsComponent(10))
    self:addComponent(bullet, CircleColliderComponent(0.5))
	
	local velocityX = direction.x * BULLET_SPEED
	local velocityY = direction.y * BULLET_SPEED
	self:addComponent(bullet, VelocityComponent(velocityX, velocityY))
end

function ShootingSystem:update(dt)
	if self.cooldownTimer > 0 then
		self.cooldownTimer = self.cooldownTimer - dt
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) and self.cooldownTimer <= 0 then
		local _, gun = next(self:getEntitiesWithComponent(GunTagComponent))
		if not gun then return end

		local gunPos = self:getComponent(gun, PositionComponent)
		local gunRot = self:getComponent(gun, RotationComponent)

		local angle = gunRot.angle
		local dirX = math.cos(angle)
		local dirY = -math.sin(angle)

		self:shoot(gunPos, {x = dirX, y = dirY}, angle)
		
		self.cooldownTimer = FIRE_RATE
	end
end

return ShootingSystem