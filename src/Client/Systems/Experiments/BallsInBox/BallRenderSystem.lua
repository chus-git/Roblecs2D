local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local BallRenderSystem = Utils.extend(System)

function BallRenderSystem:load()

	self.renderables = {}
	
end

function BallRenderSystem:afterLoad()
	self:on(Config.Events.BallCreated, function(ballId)
		self:addRenderableBall(ballId)
	end)
end

function BallRenderSystem:update(delta)
	
	for entityId, data in pairs(self.renderables) do
		local position = self:getComponent(entityId, Config.Components.Position)
		local interpolation = self:getComponent(entityId, Config.Components.Interpolation)
		interpolation.previous.x = interpolation.next.x
		interpolation.previous.y = interpolation.next.y
		interpolation.next.x = position.x
		interpolation.next.y = position.y
	end
end

function BallRenderSystem:render(dt, alpha)
	for id, data in pairs(self.renderables) do
		local interpolation = self:getComponent(id, Config.Components.Interpolation)
		interpolation.current.x = interpolation.previous.x + (interpolation.next.x - interpolation.previous.x) * alpha
		interpolation.current.y = interpolation.previous.y + (interpolation.next.y - interpolation.previous.y) * alpha
		data.part.Position = Vector3.new(interpolation.current.x, interpolation.current.y, 0)
	end
end

function BallRenderSystem:addRenderableBall(ballId)
	
	local position = self:getComponent(ballId, Config.Components.Position)
	local radius = self:getComponent(ballId, Config.Components.Ball).radius
	if not position then return end

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(radius * 2, radius * 2, 1)
	part.Position = Vector3.new(position.x, position.y, 0)
	part.Anchored = true
	part.CanCollide = false
	part.Color = Color3.new(1, 0, 0)
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = self.viewport

	self.renderables[ballId] = {
		part = part
	}
	
end

function BallRenderSystem:destroyRenderableBall(ballId)
	self.renderables[ballId] = nil
end

function BallRenderSystem:unload()
	for id, data in pairs(self.renderables) do
		data.part:Destroy()
	end
	System.unload(self)
end

return BallRenderSystem