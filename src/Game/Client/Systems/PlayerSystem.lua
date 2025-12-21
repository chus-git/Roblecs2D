local UserInputService = game:GetService("UserInputService")

local PlayerSystem = require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)

function PlayerSystem:init()
	
	self.player = self:createEntity()

    -- Añadir Sprite del jugador
    self:addComponent(self.player, SpriteComponent("rbxassetid://132488562992832"))

    -- Añadir componente velocidad del jugador
    self.playerVelocity = self:addComponent(self.player, VelocityComponent(0, 0))

    self.playerSpeed = 10

end

function PlayerSystem:update(dt)

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

	self.playerVelocity.x = x * self.playerSpeed
	self.playerVelocity.y = y * self.playerSpeed

end

return PlayerSystem