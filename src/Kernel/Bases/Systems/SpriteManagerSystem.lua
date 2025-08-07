local SpriteManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

local SpriteComponent = require(game.ReplicatedStorage.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Components.PositionComponent)

function SpriteManagerSystem:load()

    self.images = {}
	
end

function SpriteManagerSystem:render(dt, alpha)
    local STUDS_PER_PIXEL = 1 / (self.camera.FieldOfView / 5)

    local entities = self:getEntitiesWithComponent(SpriteComponent)

    for _, entityId in ipairs(entities) do
        
        local spriteComponent = self:getComponent(entityId, SpriteComponent)
        local positionComponent = self:getComponent(entityId, PositionComponent)

        local image = self.images[entityId]

        if not image then
            image = self:createImage(
                spriteComponent.imageId,
                positionComponent.x,
                positionComponent.y,
                spriteComponent.width,
                spriteComponent.height
            )
            self.images[entityId] = image
        end

        local part = image.Parent.Parent
        local billboard = image.Parent

        -- Actualizar posición
        part.Position = Vector3.new(positionComponent.x, positionComponent.y, 0)

        -- Actualizar tamaño del Part (en studs)
        part.Size = Vector3.new(spriteComponent.width, 0.1, spriteComponent.height)

        -- Actualizar tamaño del BillboardGui (en píxeles)
        billboard.Size = UDim2.new(0, spriteComponent.width * STUDS_PER_PIXEL, 0, spriteComponent.height * STUDS_PER_PIXEL)
    end
end

---

function SpriteManagerSystem:addSprite(imageId: string, x: number, y: number, width: number, height: number)

    local spriteId = self:createEntity()
    local positionComponent = self:addComponent(spriteId, PositionComponent(x, Y))
    local spriteComponent = self:addComponent(spriteId, SpriteComponent(imageId, width, height))

    local image = self:createImage(imageId, x, y, width, height)

    self.images[spriteId] = image
    
end

function SpriteManagerSystem:createImage(imageId: string, x: number, y: number, width: number, height: number)

    local STUDS_PER_PIXEL = 1 / (self.camera.FieldOfView / 5)

    -- Crear el Part anclado e invisible
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Transparency = 1
    part.Size = Vector3.new(width, 0.1, height)
    part.Position = Vector3.new(x, y, 0)
    part.Parent = workspace

    -- Crear el BillboardGui (sprite 2D)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, width * STUDS_PER_PIXEL, 0, height * STUDS_PER_PIXEL)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ResetOnSpawn = false
    billboard.Parent = part

    -- Crear la imagen
    local image = Instance.new("ImageLabel")
    image.Image = imageId
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.BorderSizePixel = 0
    image.Parent = billboard

    return image

end

return SpriteManagerSystem