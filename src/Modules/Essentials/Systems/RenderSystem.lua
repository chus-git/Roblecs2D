local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)
local RenderRotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderRotationComponent)
local RotationInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationInterpolationComponent)
local RenderSizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderSizeComponent)
local SizeInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeInterpolationComponent)

local RenderSystem = require(game.ReplicatedStorage.Source.System).extend()

function RenderSystem:render(dt, alpha)

	self:renderPosition(dt, alpha)
	self:renderRotation(dt, alpha)
	self:renderSize(dt, alpha)

end

---

function RenderSystem:renderPosition(dt, alpha)

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

function RenderSystem:renderRotation(dt, alpha)

	local entitiesWithRotationInterpolation = self:getEntitiesWithComponent(RotationInterpolationComponent)

	for _, entity in ipairs(entitiesWithRotationInterpolation) do

        local rotationInterpolationComponent = self:getComponent(entity, RotationInterpolationComponent)

        if not self:hasComponent(entity, RenderRotationComponent) then
            self:addComponent(entity, RenderRotationComponent(rotationInterpolationComponent.previous))
        end

		local renderRotationComponent = self:getComponent(entity, RenderRotationComponent)

		renderRotationComponent.angle = rotationInterpolationComponent.previous + (rotationInterpolationComponent.target - rotationInterpolationComponent.previous) * alpha

	end

end

function RenderSystem:renderSize(dt, alpha)

	local entitiesWithSizeInterpolation = self:getEntitiesWithComponent(SizeInterpolationComponent)

	for _, entity in ipairs(entitiesWithSizeInterpolation) do

		local sizeInterpolationComponent = self:getComponent(entity, SizeInterpolationComponent)

		if not self:hasComponent(entity, RenderSizeComponent) then
			self:addComponent(entity, RenderSizeComponent(sizeInterpolationComponent.previous.width, sizeInterpolationComponent.previous.height))
		end

		local renderSizeComponent = self:getComponent(entity, RenderSizeComponent)

		renderSizeComponent.width = sizeInterpolationComponent.previous.width + (sizeInterpolationComponent.target.width - sizeInterpolationComponent.previous.width) * alpha
		renderSizeComponent.height = sizeInterpolationComponent.previous.height + (sizeInterpolationComponent.target.height - sizeInterpolationComponent.previous.height) * alpha

	end

end

return RenderSystem