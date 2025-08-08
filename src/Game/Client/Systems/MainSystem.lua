local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:load()
	
	self.sceneManagerSystem = self:create(game.ReplicatedStorage.Systems.SceneManagerSystem)
	self.sceneManagerSystem:load()

	local system = {
		script.Parent.Scenes.SelectExperienceMenu.Systems.ExperienceGridSystem,
	}

	self.sceneManagerSystem:loadScene(system)
	
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