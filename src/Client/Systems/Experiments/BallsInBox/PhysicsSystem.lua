local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local PhysicsSystem = Utils.extend(System)

local AIR_FRICTION_FORCE = 30

function PhysicsSystem:load()
	self.balls = {}
end

function PhysicsSystem:afterLoad()
	self:on(Config.Events.BallCreated, function(ballId)
		table.insert(self.balls, ballId)
	end)
end

function PhysicsSystem:update(dt)
	
	for _, ball in ipairs(self.balls) do

		local position = self:getComponent(ball, Config.Components.Position)
		local velocity = self:getComponent(ball, Config.Components.Velocity)
		local mass = self:getComponent(ball, Config.Components.Mass)

		-- Actualizar posición
		position.x = position.x + velocity.x * dt
		position.y = position.y + velocity.y * dt

		-- Calcular aceleración por rozamiento: 
		-- fuerza = masa * aceleración => aceleración = fuerza / masa
		-- fuerza de rozamiento es opuesta a la velocidad
		local frictionAccelX = -AIR_FRICTION_FORCE * velocity.x / (mass.value or 1)
		local frictionAccelY = -AIR_FRICTION_FORCE * velocity.y / (mass.value or 1)

		-- Actualizar velocidad con aceleración de rozamiento
		velocity.x = velocity.x + frictionAccelX * dt
		velocity.y = velocity.y + frictionAccelY * dt
	end
	
end

function PhysicsSystem:unload()
	System.unload(self)
end


return PhysicsSystem