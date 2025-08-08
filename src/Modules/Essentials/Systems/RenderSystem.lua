local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

local RenderSystem = require(game.ReplicatedStorage.Source.System).extend()

function RenderSystem:render(dt, alpha)

	local entitiesWithPositionInterpolation = self:getEntitiesWithComponent(PositionInterpolationComponent)

	for _, entity in ipairs(entitiesWithPositionInterpolation) do

        local positionInterpolationComponent = self:getComponent(entity, PositionInterpolationComponent)

        if not self:hasComponent(entity, RenderPositionComponent) then
            self:addComponent(entity, RenderPositionComponent(positionInterpolationComponent.previous.x, positionInterpolationComponent.previous.y))
        end

		local renderPositionComponent = self:getComponent(entity, RenderPositionComponent)

		renderPositionComponent.x = positionInterpolationComponent.previous.x + (positionInterpolationComponent.target.x - positionInterpolationComponent.previous.x) * alpha
		renderPositionComponent.y = positionInterpolationComponent.previous.y + (positionInterpolationComponent.target.y - positionInterpolationComponent.previous.y) * alpha

	end

end

return RenderSystem