local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)
local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

function MainSystem:init()

    self.elements = {}

end

function MainSystem:load()

end

function MainSystem:update(dt)
    

end

---

function MainSystem:loadLevel()
    
end

return MainSystem