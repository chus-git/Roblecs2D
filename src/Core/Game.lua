local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local remoteEvent = ReplicatedStorage:FindFirstChild("GameEventManager")

local EngineFactory = require(script.Parent.EngineFactory)

local Game = {}
Game.__index = Game

function Game.new()
	local self = setmetatable({}, Game)
	self.engine = EngineFactory.create(remoteEvent)
	self:setupNetworking()
	self:start()
	return self
end

function Game:setupNetworking()
	
	if RunService:IsServer() then
		remoteEvent.OnServerEvent:Connect(function(player, eventName, ...)
			self.engine.eventManager:emit(eventName, ...)
		end)
	else
		remoteEvent.OnClientEvent:Connect(function(eventName, ...)
			self.engine.eventManager:emit(eventName, ...)
		end)
	end
	
end

function Game:start()

	local timeAccumulator = 0
	local fixeddt = 1 / 24

	local timeSinceLastFpsUpdate = 0
	local frameCount = 0

	if RunService:IsClient() then

		RunService.RenderStepped:Connect(function(dt)
			timeAccumulator += dt

			while timeAccumulator >= fixeddt do
				self.engine:update(fixeddt)
				timeAccumulator -= fixeddt
			end

			local alpha = math.clamp(timeAccumulator / fixeddt, 0, 1)
			self.engine:render(dt, alpha)

		end)

	else

		RunService.Stepped:Connect(function(time, dt)
			timeAccumulator += dt

			local updatesThisFrame = 0
			while timeAccumulator >= fixeddt and updatesThisFrame < 10 do
				self.engine:update(fixeddt)
				timeAccumulator -= fixeddt
				updatesThisFrame += 1
			end

			if updatesThisFrame == 10 then
				timeAccumulator = 0
			end

		end)
	end
end

return Game
