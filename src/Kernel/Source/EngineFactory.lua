local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:FindFirstChild("GameEventManager")

local Engine = require(game.ReplicatedStorage.Source.Engine)
local System = require(game.ReplicatedStorage.Source.System)
local EventManager = require(game.ReplicatedStorage.Source.EventManager)
local EntityManager = require(game.ReplicatedStorage.Source.EntityManager)
local ComponentManager = require(game.ReplicatedStorage.Source.ComponentManager)

local EngineFactory = {}

function EngineFactory.create()
	if RunService:IsClient() then
		return EngineFactory.createClientEngine()
	else
		return EngineFactory.createServerEngine()
	end
end

function EngineFactory.createClientEngine()

	local eventManager = EventManager.new(remoteEvent)
	local entityManager = EntityManager.new()
	local componentManager = ComponentManager.new()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GameCanvas"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local world = Instance.new("Folder")
	world.Name = "World"
	world.Parent = workspace

	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, -500), Vector3.new(0, 0, 0))
	camera.FieldOfView = 2

	local MainSystem = require(game.StarterPlayer.StarterPlayerScripts.Client.MainSystem)

	local mainSystem = MainSystem.new(eventManager, entityManager, componentManager, world, camera, screenGui)
	mainSystem:init()

	local timeAccumulator = 0
	local fixeddt = 1 / 30

	local loop = function(self)
		RunService.RenderStepped:Connect(function(dt)
			timeAccumulator += dt

			while timeAccumulator >= fixeddt do
				self:update(fixeddt)
				timeAccumulator -= fixeddt
			end

			local alpha = math.clamp(timeAccumulator / fixeddt, 0, 1)
			self:render(dt, alpha)
		end)
	end

	local engine = Engine.new(
		mainSystem,
		eventManager,
		loop
	)

	remoteEvent.OnClientEvent:Connect(function(eventName, ...)
		eventManager:emit(eventName, ...)
	end)

	EngineFactory.resetClient()

	return engine

end

function EngineFactory.createServerEngine()

	local eventManager = EventManager.new(remoteEvent)
	local entityManager = EntityManager.new()
	local componentManager = ComponentManager.new()

	local MainSystem = require(game.ServerScriptService.Server.MainSystem)

	local mainSystem = MainSystem.new(
		eventManager,
		entityManager,
		componentManager
	)
	mainSystem:init()

	local timeAccumulator = 0
	local fixeddt = 1 / 10

	local loop = function(self)
		RunService.Stepped:Connect(function(_, dt)
			timeAccumulator += dt

			local updatesThisFrame = 0
			while timeAccumulator >= fixeddt and updatesThisFrame < 10 do
				self:update(fixeddt)
				timeAccumulator -= fixeddt
				updatesThisFrame += 1
			end

			if updatesThisFrame == 10 then
				timeAccumulator = 0
			end
		end)
	end

	local engine = Engine.new(
		mainSystem,
		eventManager,
		loop
	)

	remoteEvent.OnServerEvent:Connect(function(player, eventName, ...)
		eventManager:emit(eventName, ...)
	end)

	return engine

end

function EngineFactory.resetClient()

	local Players               = game:GetService("Players")
	local ContextActionService  = game:GetService("ContextActionService")
	local StarterGui            = game:GetService("StarterGui")

	local player = Players.LocalPlayer

	for _, action in ipairs({
		"jumpAction", "toggleDevConsole", "toggleMenu",
		"mouseLock", "mouseLockSwitch", "shiftLockSwitch"
		}) do
		ContextActionService:UnbindAction(action)
	end

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

	local function freezeCharacter(char)
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = 1
				part.CanCollide = false
			elseif part:IsA("Decal") then
				part.Transparency = 1
			end
		end

		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid.AutoRotate = false
		end

		local rootPart = char:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.Anchored = true
		end
	end

	if player.Character then
		freezeCharacter(player.Character)
	end

	player.CharacterAdded:Connect(freezeCharacter)

	local Lighting = game:GetService("Lighting")

	Lighting.Ambient = Color3.new(0, 0, 0)           -- Sin luz ambiental para negros puros
	Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
	Lighting.Brightness = 1
	Lighting.ExposureCompensation = 0
	Lighting.ColorShift_Top = Color3.new(1, 1, 1)
	Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.GlobalShadows = false

	Lighting.FogStart = 1e10
	Lighting.FogEnd = 1e10
	Lighting.FogColor = Color3.new(1, 1, 1)

	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Light") then
			child.Enabled = false
		end
		if child:IsA("PostEffect") then
			child.Enabled = false
		end
	end

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
		atmosphere.Density = 0
		atmosphere.Haze = 0
		atmosphere.Glare = 0
		atmosphere.Offset = 0
		atmosphere.Color = Color3.new(1, 1, 1)
	end

	local Lighting = game:GetService("Lighting")

end

return EngineFactory