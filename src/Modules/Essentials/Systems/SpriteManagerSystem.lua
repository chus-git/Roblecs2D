local SpriteManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local RenderPositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.RenderPositionComponent)
local PositionInterpolationComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionInterpolationComponent)

function SpriteManagerSystem:init()

    self.images = {}
	
end

function SpriteManagerSystem:render(dt, alpha)

    local STUDS_PER_PIXEL = 1 / (self.camera.FieldOfView / 20)

    local entities = self:getEntitiesWithComponent(SpriteComponent)

    for _, entityId in ipairs(entities) do

        local positionComponent = self:getComponent(entityId, PositionComponent)

        if not self:hasComponent(entityId, RenderPositionComponent) then
            self:addComponent(entityId, RenderPositionComponent(positionComponent.x, positionComponent.y))
        end
        
        local spriteComponent = self:getComponent(entityId, SpriteComponent)
        local renderPositionComponent = self:getComponent(entityId, RenderPositionComponent)

        local image = self.images[entityId]

        if not image then
            image = self:createImage(spriteComponent.imageId, positionComponent.x, positionComponent.y, spriteComponent.width, spriteComponent.height)
            self.images[entityId] = image
        end

        local part = image.Parent.Parent
        local billboard = image.Parent

        -- Actualizar posición
        part.Position = Vector3.new(-renderPositionComponent.x, renderPositionComponent.y, 0)

        -- Actualizar tamaño del Part (en studs)
        --part.Size = Vector3.new(spriteComponent.width, spriteComponent.height, 1)

        -- Actualizar tamaño del BillboardGui (en píxeles)
        --billboard.Size = UDim2.new(0, spriteComponent.width * STUDS_PER_PIXEL, 0, spriteComponent.height * STUDS_PER_PIXEL)
    end
end

function SpriteManagerSystem:unload()
    for _, image in pairs(self.images) do
        image.Parent.Parent:Destroy()
    end
    self.images = {}
end

---

function SpriteManagerSystem:createImage(imageId: string, x: number, y: number, width: number, height: number)

    local STUDS_PER_PIXEL = 1 / (self.camera.FieldOfView / 20)

    -- Crear el Part plano (como un panel 2D)
    local part = Instance.new("Part")
    part.Size = Vector3.new(width, height, 0.1) -- muy delgado en Z
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1 -- si quieres invisible o pon color para debug
    part.Position = Vector3.new(x, y, 0)
    part.Parent = workspace

    -- Crear SurfaceGui en la cara del Part que mire a la cámara
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front -- depende de cómo lo orientas
    surfaceGui.Adornee = part
    surfaceGui.AlwaysOnTop = true
    surfaceGui.ResetOnSpawn = false
    surfaceGui.Parent = part

    -- Añadir la imagen al SurfaceGui
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.BorderSizePixel = 0
    imageLabel.Image = imageId
    imageLabel.Parent = surfaceGui

    return image

end

return SpriteManagerSystem