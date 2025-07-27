local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local remoteEvent = ReplicatedStorage:FindFirstChild("GameEventBus")

local EngineFactory = require(script.Parent.EngineFactory)

local Game = {}
Game.__index = Game

function Game.new(MainSystemModule, config)
	local self = setmetatable({}, Game)
	self.engine = EngineFactory.create(MainSystemModule, remoteEvent)
	self.config = config
	self:setupNetworking()
	return self
end

function Game:setupNetworking()
	
	if RunService:IsServer() then
		-- Crear RemoteEvent si no existe (hazlo solo una vez en tu servidor)
		
		if not remoteEvent then
			remoteEvent = Instance.new("RemoteEvent")
			remoteEvent.Name = "GameEventBus"
			remoteEvent.Parent = ReplicatedStorage
		end
		self.remoteEvent = remoteEvent

		remoteEvent.OnServerEvent:Connect(function(player, eventName, ...)
			self.engine.eventBus:emit(eventName, ...)
		end)

	else
		-- Cliente
		local remoteEvent = ReplicatedStorage:WaitForChild("GameEventBus")
		self.remoteEvent = remoteEvent

		-- Escuchar eventos del servidor
		remoteEvent.OnClientEvent:Connect(function(eventName, ...)
			self.engine.eventBus:emit(eventName, ...)
		end)

	end
	
end

function Game:start()
	local timeAccumulator = 0
	local fixeddt = 1 / self.config.FixedUPS

	local timeSinceLastFpsUpdate = 0
	local frameCount = 0

	if RunService:IsClient() then
		-- Cliente: actualización + render en RenderStepped
		RunService.RenderStepped:Connect(function(dt)
			timeAccumulator += dt

			-- Procesamos TODAS las actualizaciones necesarias (sin límite)
			while timeAccumulator >= fixeddt do
				self.engine:update(fixeddt)
				timeAccumulator -= fixeddt
			end

			-- alpha para interpolación
			local alpha = math.clamp(timeAccumulator / fixeddt, 0, 1)
			self.engine:render(dt, alpha)

			-- Mostrar FPS (opcional)
			if self.config.ShowFPS then
				frameCount += 1
				timeSinceLastFpsUpdate += dt
				if timeSinceLastFpsUpdate >= 1 then
					print("[Game] FPS:", frameCount)
					frameCount = 0
					timeSinceLastFpsUpdate = 0
				end
			end
		end)

	else
		-- Servidor: solo actualización lógica en Stepped, sin render
		RunService.Stepped:Connect(function(time, dt)
			timeAccumulator += dt

			local updatesThisFrame = 0
			while timeAccumulator >= fixeddt and updatesThisFrame < self.config.MaxUPF do
				self.engine:update(fixeddt)
				timeAccumulator -= fixeddt
				updatesThisFrame += 1
			end

			if updatesThisFrame == self.config.MaxUPF then
				timeAccumulator = 0
			end
			-- NO hay render en servidor ni FPS a mostrar
		end)
	end
end

return Game
