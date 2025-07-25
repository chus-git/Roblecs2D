local Config = require(game.StarterPlayer.StarterPlayerScripts.Client.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local PhysicsSystem = Utils.extend(System)

local AIR_FRICTION_FORCE = 30

function PhysicsSystem:load()
	self.boxes = {}
end

function PhysicsSystem:afterLoad()
	self:on(Config.Events.BoxCreated, function(boxId)
		table.insert(self.boxes, boxId)
	end)
end

function PhysicsSystem:update(dt)
	
	for _, box in ipairs(self.boxes) do

		local position = self:getComponent(box, Config.Components.Position)
		local velocity = self:getComponent(box, Config.Components.Velocity)

		-- Actualizar posición
		position.x = position.x + velocity.x * dt
		position.y = position.y + velocity.y * dt
		
		
		
	end
	
end

function PhysicsSystem:unload()
	System.unload(self)
end


return PhysicsSystem
