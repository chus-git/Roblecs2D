local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(game.ReplicatedStorage.Core.Engine)
local System = require(game.ReplicatedStorage.Core.System)
local EventManager = require(game.ReplicatedStorage.Core.EventManager)
local EntityManager = require(game.ReplicatedStorage.Core.EntityManager)
local ComponentManager = require(game.ReplicatedStorage.Core.ComponentManager)

local EngineFactory = {}

function EngineFactory.create(remoteEvent)

	-- Crear EventManager
	local eventManager = EventManager.new(remoteEvent)
	local entityManager = EntityManager.new()
	local componentManager = ComponentManager.new()

	local viewport, camera

	-- SOLO EN EL CLIENTE
	if RunService:IsClient() then
		local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "GameCanvas"
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui

		viewport = Instance.new("Folder")
		viewport.Name = "RenderRoot"
		viewport.Parent = workspace

		camera = workspace.CurrentCamera
		camera.CFrame = CFrame.new(Vector3.new(0, 100, 0)) * CFrame.Angles(-math.rad(90), 0, 0)
		
	end
	
	local MainSystemModule

	if RunService:IsServer() then
		MainSystemModule = game.ServerScriptService.Server.Systems.MainSystem
	else
		MainSystemModule = game.StarterPlayer.StarterPlayerScripts.Client.Systems.MainSystem
	end

	local mainSystem = System.create(
		MainSystemModule,
		eventManager,
		entityManager,
		componentManager,
		viewport,
		camera,
		screenGui
	)

	local engine = Engine.new(
		mainSystem,
		eventManager
	)

	return engine
end

return EngineFactory