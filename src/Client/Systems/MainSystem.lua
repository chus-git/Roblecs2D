local Config = require(game.ReplicatedStorage.Shared.Config)

local Utils = require(game.ReplicatedStorage.Shared.Core.Utils)
local System = require(game.ReplicatedStorage.Shared.Core.System)

local MainSystem = Utils.extend(System)

function MainSystem:load()
	
	self.sceneManagerSystem = self:createSystem(script.Parent.SceneManagerSystem)
	self.sceneManagerSystem:load()

	local UserInputService = game:GetService("UserInputService")

	local selectExperienceMenu = {
		script.Parent.Scenes.SelectExperienceMenu.ExperienceGridSystem,
	}

	local ballsInBox = {
		script.Parent.Experiments.BallsInBox.MainSystem,
		script.Parent.Experiments.BallsInBox.CollisionSystem,
		script.Parent.Experiments.BallsInBox.GravitySystem,
		script.Parent.Experiments.BallsInBox.PhysicsSystem,
		script.Parent.Experiments.BallsInBox.BallRenderSystem,
		script.Parent.Experiments.BallsInBox.BallGeneratorSystem,
	}

	local boxInBox = {
		script.Parent.Experiments.BoxInBox.MainSystem,
		script.Parent.Experiments.BoxInBox.BoxRenderSystem,
		script.Parent.Experiments.BoxInBox.BoxGeneratorSystem,
		script.Parent.Experiments.BoxInBox.PhysicsSystem,
		script.Parent.Experiments.BoxInBox.CollisionSystem,
	}

	self.sceneManagerSystem:loadScene(selectExperienceMenu)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.One then
			self:emit("LoadScene", selectExperienceMenu)
		elseif input.KeyCode == Enum.KeyCode.Two then
			self:emit("LoadScene", ballsInBox)
		elseif input.KeyCode == Enum.KeyCode.Three then
			self:emit("LoadScene", boxInBox)
		end
	end)
	
	self:on("LoadScene", function(scene)
		self.sceneManagerSystem:loadScene(scene)
	end)
	
end

function MainSystem:beforeUpdate(dt)
	self.sceneManagerSystem:beforeUpdate(dt)
end

function MainSystem:update(dt)
	self.sceneManagerSystem:update(dt)
end

function MainSystem:afterUpdate(dt)
	self.sceneManagerSystem:afterUpdate(dt)
end

function MainSystem:render(dt, alpha)
	self.sceneManagerSystem:render(dt, alpha)
end

return MainSystem