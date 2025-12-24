local UserInputService = game:GetService("UserInputService")

local PlayerMovementSystem = require(game.ReplicatedStorage.Source.System).extend()

local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SpeedComponent = require(game.ReplicatedStorage.Components.SpeedComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function PlayerMovementSystem:load()
	self.player = self:getEntityWithComponent(PlayerTagComponent)
	self.playerVelocity = self:getComponent(self.player, VelocityComponent)
	self.playerSpeed = self:getComponent(self.player, SpeedComponent)
end

function PlayerMovementSystem:update(dt)

	local x = 0
	local y = 0

	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		x -= 1
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		x += 1
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		y += 1
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		y -= 1
	end

	-- Normalizar para evitar diagonales más rápidas
	local length = math.sqrt(x * x + y * y)
	if length > 0 then
		x /= length
		y /= length
	end

	self.playerVelocity.x = x * self.playerSpeed.speed
	self.playerVelocity.y = y * self.playerSpeed.speed

end

return PlayerMovementSystem