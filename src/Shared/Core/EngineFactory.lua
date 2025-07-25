local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Shared.Core.Engine)
local SystemManager = require(ReplicatedStorage.Shared.Core.SystemManager)
local EventBus = require(ReplicatedStorage.Shared.Core.EventBus)
local EntityManager = require(ReplicatedStorage.Shared.Core.EntityManager)
local ComponentManager = require(ReplicatedStorage.Shared.Core.ComponentManager)
local ComponentFactory = require(ReplicatedStorage.Shared.Core.ComponentFactory)
local ComponentRegistry = require(ReplicatedStorage.Shared.Core.ComponentRegistry)
local QueryManager = require(ReplicatedStorage.Shared.Core.QueryManager)
local SystemManager = require(ReplicatedStorage.Shared.Core.SystemManager)

local EngineFactory = {}

function EngineFactory.create(Config, remoteEvent)

	-- Crear EventBus
	local eventBus = EventBus.new(Config.Events, remoteEvent)
	local entityManager = EntityManager.new()
	local componentRegistry = ComponentRegistry.new(Config.ComponentsPath)
	local componentManager = ComponentManager.new(ComponentFactory.new(componentRegistry.components))
	local queryManager = QueryManager.new(entityManager, componentManager)

	local viewport, camera

	-- SOLO EN EL CLIENTE
	if RunService:IsClient() then
		local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "GameCanvas"
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui

		viewport = Instance.new("ViewportFrame")
		viewport.Name = "Viewport"
		viewport.Size = UDim2.fromScale(1, 1)
		viewport.Position = UDim2.fromScale(0, 0)
		viewport.BackgroundColor3 = Color3.new(1, 1, 1)
		viewport.BackgroundTransparency = 0
		viewport.BorderSizePixel = 0
		viewport.Parent = screenGui

		camera = Instance.new("Camera")
		camera.Name = "ViewportCamera"
		camera.CFrame = CFrame.new(0, 0, -100) * CFrame.lookAt(Vector3.new(0, 0, -100), Vector3.new(0, 0, 0))
		camera.Parent = viewport
		viewport.CurrentCamera = camera
		
	end
	
	local systemManager = SystemManager.new(
		eventBus,
		entityManager,
		componentManager,
		queryManager,
		viewport,
		camera
	)

	local mainSystem = systemManager:createSystem(Config.MainSystem)

	local engine = Engine.new(mainSystem, eventBus)

	return engine
end

return EngineFactory