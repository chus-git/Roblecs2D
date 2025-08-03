local BallCreated = require(game.ReplicatedStorage.Shared.Events.BallCreated)
local CircleComponent = require(game.ReplicatedStorage.Shared.Components.Circle)
local InterpolationComponent = require(game.ReplicatedStorage.Shared.Components.Interpolation)

local RenderSystem = require(game.ReplicatedStorage.Core.System).extend()

function RenderSystem:load()
	self.ballsRenderables = {}

	self:on(BallCreated, function(ballId)
		self:addBall(ballId)
	end)
end

function RenderSystem:update(dt)
	for ballId, renderable in pairs(self.ballsRenderables) do
		local position = self:getComponentFromEntity(ballId, CircleComponent)
		local interpolated = self:getComponentFromEntity(ballId, InterpolationComponent)
		interpolated.previous = interpolated.next
		interpolated.next = Vector2.new(position.position.X, position.position.Y)
	end
end

function RenderSystem:render(dt, alpha)
	for ballId, renderable in pairs(self.ballsRenderables) do
		local interpolated = self:getComponentFromEntity(ballId, InterpolationComponent)
		interpolated.current = interpolated.previous + (interpolated.next - interpolated.previous) * alpha
		local part = renderable.part
		part.Position = Vector3.new(interpolated.current.X, interpolated.current.Y, 0)
	end
end

function RenderSystem:addBall(ballId)
	local circle = self:getComponentFromEntity(ballId, CircleComponent)
	if not circle then return end

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(circle.radius * 2, circle.radius * 2, 1)
	part.Position = Vector3.new(circle.position.X, circle.position.Y, 0)
	part.Anchored = true
	part.CanCollide = false
	part.Color = circle.color
	part.Material = Enum.Material.SmoothPlastic
	part.Name = "Ball"
	part.Parent = self.viewport

	self.ballsRenderables[ballId] = {
		part = part
	}
end


return RenderSystem
