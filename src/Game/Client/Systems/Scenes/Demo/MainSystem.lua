local PositionComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.PositionComponent)
local SpriteComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SpriteComponent)
local VelocityComponent = require(game.ReplicatedStorage.Modules.Physics.Components.VelocityComponent)
local BallComponent = require(script.Parent.Components.BallComponent)
local CircleColliderComponent = require(game.ReplicatedStorage.Modules.Physics.Components.CircleColliderComponent)
local SizeComponent = require(game.ReplicatedStorage.Modules.Essentials.Components.SizeComponent)
local OnCollideEvent = require(game.ReplicatedStorage.Modules.Physics.Events.OnCollideEvent)

local MainSystem = require(game.ReplicatedStorage.Source.System).extend()

local CIRCLE_CENTER = Vector2.new(0, 0)
local CIRCLE_RADIUS = 8
local MAX_BALLS = 500
local BALL_RADIUS = 0.5

function MainSystem:resolveCollision(entity1, entity2)

    local pos1 = self:getComponent(entity1, PositionComponent)
    local pos2 = self:getComponent(entity2, PositionComponent)

    local vel1 = self:getComponent(entity1, VelocityComponent)
    local vel2 = self:getComponent(entity2, VelocityComponent)

    -- calcula diferencia
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dist = math.sqrt(dx*dx + dy*dy)

    -- asumiendo que cada bola tiene un radio "r"
    local r1 = self:getComponent(entity1, CircleColliderComponent).radius
    local r2 = self:getComponent(entity2, CircleColliderComponent).radius
    local minDist = r1 + r2

    -- normaliza el vector de separación
    local nx = dx / dist
    local ny = dy / dist

    -- separa las bolas la mitad del solapamiento cada una
    local overlap = ((minDist - dist) / 2) + 0.01
    pos1.x = pos1.x + nx * overlap
    pos1.y = pos1.y + ny * overlap
    pos2.x = pos2.x - nx * overlap
    pos2.y = pos2.y - ny * overlap

    -- rebote elástico simple (invirtiendo velocidad en dirección del normal)
    local dot1 = vel1.x * nx + vel1.y * ny
    local dot2 = vel2.x * nx + vel2.y * ny
    vel1.x = vel1.x - 2 * dot1 * nx
    vel1.y = vel1.y - 2 * dot1 * ny
    vel2.x = vel2.x - 2 * dot2 * nx
    vel2.y = vel2.y - 2 * dot2 * ny

end

function MainSystem:createBall()
    local ball = self:createEntity()
    self:addComponent(ball, PositionComponent(math.random(-CIRCLE_RADIUS * 0.9, CIRCLE_RADIUS * 0.9), math.random(-CIRCLE_RADIUS * 0.9, CIRCLE_RADIUS * 0.9)))
    self:addComponent(ball, SpriteComponent("rbxassetid://132488562992832"))
    local speed = 5
    local direction = Vector2.new(math.random(-1, 1), math.random(-1, 1)).Unit
    self:addComponent(ball, VelocityComponent(direction.X * speed, direction.Y * speed))
    self:addComponent(ball, BallComponent())
    local sizeComponent = self:addComponent(ball, SizeComponent(BALL_RADIUS * 2, BALL_RADIUS * 2))
    self:addComponent(ball, CircleColliderComponent(sizeComponent.width / 2))
    return ball
end

---

function MainSystem:init()

    self:createBall()
    self:createBall()
    self:createBall()
    self:createBall()

    self:onFire(OnCollideEvent, function(entity1, entity2)
        self:resolveCollision(entity1, entity2)
        local balls = self:getEntitiesWithComponent(BallComponent)
        if #balls < MAX_BALLS then

            for _, ball in pairs(balls) do
                local sizeComponent = self:getComponent(ball, SizeComponent)
                local circleColliderComponent = self:getComponent(ball, CircleColliderComponent)
                sizeComponent.width = sizeComponent.width * 0.998
                sizeComponent.height = sizeComponent.height * 0.998
                circleColliderComponent.radius = sizeComponent.width / 2
                BALL_RADIUS = circleColliderComponent.radius
            end

            self:createBall()
        end
    end)

end

function MainSystem:update(dt)

    local balls = self:getEntitiesWithComponent(BallComponent)

    for entityId, entity in pairs(balls) do

        local pos = self:getComponent(entity, PositionComponent)
        local vel = self:getComponent(entity, VelocityComponent)

        -- actualizar posición
        pos.x = pos.x + vel.x * dt
        pos.y = pos.y + vel.y * dt

        -- vector desde el centro hacia la bola
        local dir = Vector2.new(pos.x, pos.y) - CIRCLE_CENTER
        local dist = dir.Magnitude

        if dist > CIRCLE_RADIUS then
            -- normalizar el vector
            local normal = dir.Unit

            -- reflejar velocidad elásticamente
            local v = Vector2.new(vel.x, vel.y)
            local reflected = v - 2 * (v:Dot(normal)) * normal

            vel.x = reflected.X
            vel.y = reflected.Y

            -- reposicionar la bola justo en el borde
            pos.x = CIRCLE_CENTER.X + normal.X * CIRCLE_RADIUS
            pos.y = CIRCLE_CENTER.Y + normal.Y * CIRCLE_RADIUS
        end
    end

end

return MainSystem