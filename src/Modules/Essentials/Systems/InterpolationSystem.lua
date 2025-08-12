local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local RotationInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationInterpolationComponent)

local InterpolationSystem = require(game.ReplicatedStorage.Source.System).extend()

function InterpolationSystem:update(dt)
	
	self:interpolatePosition()
	self:interpolateRotation()

end

---

function InterpolationSystem:interpolatePosition()

	local entitiesWithPositionInterpolationComponent = self:getEntitiesWithComponent(PositionInterpolationComponent)

	for _, entity in ipairs(entitiesWithPositionInterpolationComponent) do

		local positionComponent = self:getComponent(entity, PositionComponent)
		local positionInterpolationComponent = self:getComponent(entity, PositionInterpolationComponent)

		positionInterpolationComponent.previous.x = positionInterpolationComponent.target.x
		positionInterpolationComponent.previous.y = positionInterpolationComponent.target.y

		positionInterpolationComponent.target.x = positionComponent.x
		positionInterpolationComponent.target.y = positionComponent.y

	end

end

function InterpolationSystem:interpolateRotation()

	local entitiesWithRotationInterpolationComponent = self:getEntitiesWithComponent(RotationInterpolationComponent)

	for _, entity in ipairs(entitiesWithRotationInterpolationComponent) do

		local rotationComponent = self:getComponent(entity, RotationComponent)
		local rotationInterpolationComponent = self:getComponent(entity, RotationInterpolationComponent)

		rotationInterpolationComponent.previous = rotationInterpolationComponent.target

		rotationInterpolationComponent.target = rotationComponent.angle

	end

end

return InterpolationSystem