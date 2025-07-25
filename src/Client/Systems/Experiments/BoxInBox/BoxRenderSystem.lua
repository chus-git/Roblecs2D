local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local BoxRenderSystem = Utils.extend(System)

function BoxRenderSystem:load()

	self.renderables = {}
	
	self:on(Config.Events.BoxCreated, function(boxId)
		self:addRenderableBox(boxId)
	end)
	
end

function BoxRenderSystem:update(delta)
	for entityId, data in pairs(self.renderables) do
		local position = self:getComponent(entityId, Config.Components.Position)
		local interpolation = self:getComponent(entityId, Config.Components.Interpolation)
		interpolation.previous.x = interpolation.next.x
		interpolation.previous.y = interpolation.next.y
		interpolation.next.x = position.x
		interpolation.next.y = position.y
	end
end

function BoxRenderSystem:render(dt, alpha)
	for id, data in pairs(self.renderables) do
		local interpolation = self:getComponent(id, Config.Components.Interpolation)
		interpolation.current.x = interpolation.previous.x + (interpolation.next.x - interpolation.previous.x) * alpha
		interpolation.current.y = interpolation.previous.y + (interpolation.next.y - interpolation.previous.y) * alpha
		data.part.Position = Vector3.new(interpolation.current.x, interpolation.current.y, 0)
	end
end

function BoxRenderSystem:addRenderableBox(boxId)
	
	local position = self:getComponent(boxId, Config.Components.Position)
	local box = self:getComponent(boxId, Config.Components.Box)

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Block 
	part.Size = Vector3.new(box.width, box.height, 1)
	part.Position = Vector3.new(position.x, position.y, 0)
	part.Anchored = true
	part.CanCollide = false
	part.Color = Color3.new(1, 0, 0)
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = self.viewport

	self.renderables[boxId] = {
		part = part
	}
	
end


function BoxRenderSystem:destroyRenderableBox(boxId)
	self.renderables[boxId] = nil
end

function BoxRenderSystem:unload()
	for id, data in pairs(self.renderables) do
		data.part:Destroy()
	end
	System.unload(self)
end

return BoxRenderSystem