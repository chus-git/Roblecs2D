local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)

local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

local RotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationComponent)
local RenderRotationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderRotationComponent)
local RotationInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RotationInterpolationComponent)

local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local RenderSizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderSizeComponent)
local SizeInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeInterpolationComponent)

local SpriteManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

function SpriteManagerSystem:init()

    self.images = {}
	
end

function SpriteManagerSystem:update(dt)

    local entities = self:getEntitiesWithComponent(SpriteComponent)

    for _, entityId in pairs(entities) do

        local spriteComponent = self:getComponent(entityId, SpriteComponent)

        -- Position components
        local positionComponent = self:getComponent(entityId, PositionComponent)

        if not positionComponent then
            positionComponent = self:addComponent(entityId, PositionComponent(0, 0))
        end
        local positionInterpolationComponent = self:getComponent(entityId, PositionInterpolationComponent)
        if not positionInterpolationComponent then
            positionInterpolationComponent = self:addComponent(entityId, PositionInterpolationComponent(positionComponent.x, positionComponent.y))
        end
        local renderPositionComponent = self:getComponent(entityId, RenderPositionComponent)
        if not renderPositionComponent then
            renderPositionComponent = self:addComponent(entityId, RenderPositionComponent(positionComponent.x, positionComponent.y))
        end

        -- Rotation components
        local rotationComponent = self:getComponent(entityId, RotationComponent)
        if not rotationComponent then
            rotationComponent = self:addComponent(entityId, RotationComponent(0))
        end
        local rotationInterpolationComponent = self:getComponent(entityId, RotationInterpolationComponent)
        if not rotationInterpolationComponent then
            rotationInterpolationComponent = self:addComponent(entityId, RotationInterpolationComponent(rotationComponent.angle))
        end
        local renderRotationComponent = self:getComponent(entityId, RenderRotationComponent)
        if not renderRotationComponent then
            renderRotationComponent = self:addComponent(entityId, RenderRotationComponent(rotationComponent.angle))
        end

        -- Size components
        local sizeComponent = self:getComponent(entityId, SizeComponent)
        if not sizeComponent then
            sizeComponent = self:addComponent(entityId, SizeComponent(1, 1))
        end
        local sizeInterpolationComponent = self:getComponent(entityId, SizeInterpolationComponent)
        if not sizeInterpolationComponent then
            sizeInterpolationComponent = self:addComponent(entityId, SizeInterpolationComponent(sizeComponent.width, sizeComponent.height))
        end
        local renderSizeComponent = self:getComponent(entityId, RenderSizeComponent)
        if not renderSizeComponent then
            renderSizeComponent = self:addComponent(entityId, RenderSizeComponent(sizeComponent.width, sizeComponent.height))
        end

        -- Inicializamos la imagen
        self.images[entityId] = self:createImage(spriteComponent.imageId, positionComponent.x, positionComponent.y, sizeComponent.width, sizeComponent.height)
       
        self:removeComponent(entityId, SpriteComponent) -- Eliminamos el componente SpriteComponent al ser ya inicializado

    end


end

function SpriteManagerSystem:render(dt, alpha)

    for entityId, image in pairs(self.images) do

        local part = image.Parent.Parent
        local surfaceGui = image.Parent

        -- Actualizar posición
        local renderPositionComponent = self:getComponent(entityId, RenderPositionComponent)
        part.Position = Vector3.new(-renderPositionComponent.x, renderPositionComponent.y, 0)

        -- Actualizar rotación
        local renderRotationComponent = self:getComponent(entityId, RenderRotationComponent)
        part.CFrame = CFrame.new(part.Position) * CFrame.Angles(0, 0, renderRotationComponent.angle)

        -- Actualizar tamaño
        local renderSizeComponent = self:getComponent(entityId, RenderSizeComponent)
        part.Size = Vector3.new(renderSizeComponent.width, renderSizeComponent.height, 1)

    end

end

function SpriteManagerSystem:unload()
    for _, image in pairs(self.images) do
        image.Parent.Parent:Destroy()
    end
    self.images = {}
end

---

function SpriteManagerSystem:hasToBeInitialized(entityId)
    return self.images[entityId] == nil and
            self:hasComponent(entityId, SpriteComponent) and
            self:hasComponent(entityId, PositionComponent)
end

function SpriteManagerSystem:createImage(imageId: string, x: number, y: number, width: number, height: number)

    local part = Instance.new("Part")
    part.Size = Vector3.new(width, height, 0.1)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Position = Vector3.new(x, y, 0)
    part.Parent = self.world

    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Adornee = part
    surfaceGui.AlwaysOnTop = true
    surfaceGui.ResetOnSpawn = false
    surfaceGui.Parent = part

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.BorderSizePixel = 0
    imageLabel.Image = imageId
    imageLabel.Parent = surfaceGui

    return imageLabel

end

return SpriteManagerSystem