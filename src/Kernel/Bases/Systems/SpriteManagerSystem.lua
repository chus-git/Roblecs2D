local SpriteManagerSystem = require(game.ReplicatedStorage.Source.System).extend()

local SpriteComponent = require(game.ReplicatedStorage.Components.SpriteComponent)
local PositionComponent = require(game.ReplicatedStorage.Components.PositionComponent)
local CreateSpriteEvent = require(game.ReplicatedStorage.Events.CreateSpriteEvent)

function SpriteManagerSystem:load()

    self.sprites = {}

	self:on(CreateSpriteEvent, function(imageId: string, x: number, y: number, width: number, height: number)
		self:addSprite(imageId, x, y, width, height)
	end)
	
end

function SpriteManagerSystem:render(dt, alpha)
    --for spriteId, spriteComponent in pairs(self.sprites) do
    --    local positionComponent = self:getComponent(spriteId, PositionComponent)
    --    local spriteComponent = self:getComponent(spriteId, SpriteComponent)
    --    local sprite = self.sprites[spriteId]
    --    sprite.Adornee.Position = Vector3.new(positionComponent.x, positionComponent.y, 0)
    --    sprite.Size = UDim2.new(0, spriteComponent.width * 100, 0, spriteComponent.height * 100)
    --end
end

---

function SpriteManagerSystem:addSprite(imageId: string, x: number, y: number, width: number, height: number)

    local spriteId = self:createEntity()
    local positionComponent = self:addComponent(spriteId, PositionComponent(x, Y))
    local spriteComponent = self:addComponent(spriteId, SpriteComponent(imageId, width, height))

    local sprite = self:createSprite(imageId, x, y, width, height)

    self.sprites[spriteId] = sprite
end

function SpriteManagerSystem:createSprite(imageId: string, x: number, y: number, width: number, height: number)

    local STUDS_PER_PIXEL = self.camera.FieldOfView / 5

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
    billboard.Size = UDim2.new(0, width / STUDS_PER_PIXEL, 0, height / STUDS_PER_PIXEL)
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

    return billboard

end

return SpriteManagerSystem