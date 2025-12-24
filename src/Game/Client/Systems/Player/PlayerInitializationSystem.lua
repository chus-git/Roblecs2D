local PlayerInitializationSystem = require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local SpeedComponent = require(game.ReplicatedStorage.Components.SpeedComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PlayerTagComponent = require(game.ReplicatedStorage.Components.PlayerTagComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local AccelerationComponent = require(game.ReplicatedStorage.Modules.Physics.Components.AccelerationComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function PlayerInitializationSystem:init()
	
	self.player = self:createEntity()
    self:addComponent(self.player, PlayerTagComponent())
    self:addComponent(self.player, SpriteComponent(Sprites.PLAYER))
    self:addComponent(self.player, PositionComponent(0, 0))
    self:addComponent(self.player, VelocityComponent(0, 0))
    self:addComponent(self.player, AccelerationComponent(0, 0))
    self:addComponent(self.player, SpeedComponent(5))
    self:addComponent(self.player, CircleColliderComponent(0.5))

end

return PlayerInitializationSystem