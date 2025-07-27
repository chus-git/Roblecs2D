local MainSystem = require(game.ReplicatedStorage.Core.System).extend()

function MainSystem:load()
	
	self.sceneManagerSystem = self:createSystem(script.Parent.SceneManagerSystem)
	self.sceneManagerSystem:load()

	local selectExperienceMenu = {
		script.Parent.Scenes.SelectExperienceMenu.ExperienceGridSystem,
	}

	self.sceneManagerSystem:loadScene(selectExperienceMenu)
	
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