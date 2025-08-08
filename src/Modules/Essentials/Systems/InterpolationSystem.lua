local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local RenderRotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderRotationComponent)
local RotationInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationInterpolationComponent)

local InterpolationSystem = require(game.ReplicatedStorage.Source.System).extend()

function InterpolationSystem:afterUpdate(dt)
	
	self:interpolatePosition()
	self:interpolateRotation()

end

---

function InterpolationSystem:interpolatePosition()

	local entitiesWithPosition = self:getEntitiesWithComponent(PositionComponent)

	for _, entity in ipairs(entitiesWithPosition) do

		local positionComponent = self:getComponent(entity, PositionComponent)

		if not self:hasComponent(entity, PositionInterpolationComponent) then
			self:addComponent(entity, PositionInterpolationComponent(positionComponent.x, positionComponent.y))
		end

		local positionInterpolationComponent = self:getComponent(entity, PositionInterpolationComponent)

		positionInterpolationComponent.previous.x = positionInterpolationComponent.target.x
		positionInterpolationComponent.previous.y = positionInterpolationComponent.target.y

		positionInterpolationComponent.target.x = positionComponent.x
		positionInterpolationComponent.target.y = positionComponent.y

	end

end

function InterpolationSystem:interpolateRotation()

	local entitiesWithRotation = self:getEntitiesWithComponent(RotationComponent)

	for _, entity in ipairs(entitiesWithRotation) do

		local rotationComponent = self:getComponent(entity, RotationComponent)

		if not self:hasComponent(entity, RotationInterpolationComponent) then
			self:addComponent(entity, RotationInterpolationComponent(rotationComponent.angle))
		end

		local rotationInterpolationComponent = self:getComponent(entity, RotationInterpolationComponent)

		rotationInterpolationComponent.previous = rotationInterpolationComponent.target

		rotationInterpolationComponent.target = rotationComponent.angle

	end

end

return InterpolationSystem