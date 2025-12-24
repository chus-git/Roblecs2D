local GunInitializationSystem = require(game.ReplicatedStorage.Source.System).extend()
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local GunTagComponent = require(game.ReplicatedStorage.Components.GunTagComponent)

local Sprites = require(game.ReplicatedStorage.Assets.Sprites)

function GunInitializationSystem:init()
	
	local gun = self:createEntity()
    self:addComponent(gun, GunTagComponent())
    self:addComponent(gun, SpriteComponent(Sprites.GUN))
    self:addComponent(gun, PositionComponent(0, 0))
    self:addComponent(gun, RotationComponent(0))

end

return GunInitializationSystem