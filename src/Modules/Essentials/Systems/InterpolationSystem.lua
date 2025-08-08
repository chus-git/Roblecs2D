local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

local InterpolationSystem = require(game.ReplicatedStorage.Source.System).extend()

function InterpolationSystem:afterUpdate(dt)
	
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

return InterpolationSystem