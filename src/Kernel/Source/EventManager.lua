local RunService = game:GetService("RunService")

local EventManager = {}
EventManager.__index = EventManager

function EventManager.new(remoteEvent)
    local self = setmetatable({}, EventManager)
    self.listeners = {} -- { eventName = { {callback=fn, instant=bool}, ... } }
    self.queue = {}
    self.remoteEvent = remoteEvent
    return self
end

-- Suscripción
function EventManager:on(event, callback)
    return self:_addListener(event, callback, false)
end

function EventManager:onFire(event, callback)
    return self:_addListener(event, callback, true)
end

-- Internal: agrega listener
function EventManager:_addListener(event, callback, instant)
    local name = typeof(event) == "string" and event or tostring(event)
    if not self.listeners[name] then
        self.listeners[name] = {}
    end
    local listener = { callback = callback, instant = instant }
    table.insert(self.listeners[name], listener)

    -- Devuelve función de desconexión
    return function()
        local handlers = self.listeners[name]
        if not handlers then return end
        for i = #handlers, 1, -1 do
            if handlers[i] == listener then
                table.remove(handlers, i)
                break
            end
        end
    end
end

-- Emitir evento diferido
function EventManager:emit(event, ...)
    local name, args = self:_resolveEvent(event, ...)
    table.insert(self.queue, { name = name, args = args })
end

-- Emitir evento instantáneo
function EventManager:fire(event, ...)
    local name, args = self:_resolveEvent(event, ...)
    local handlers = self.listeners[name]
    if handlers then
        for _, h in ipairs(handlers) do
            if h.instant then
                h.callback(table.unpack(args))
            end
        end
    end
end

-- Flush de todos los eventos diferidos
function EventManager:flush()
    for _, evt in ipairs(self.queue) do
        local handlers = self.listeners[evt.name]
        if handlers then
            for _, h in ipairs(handlers) do
                if not h.instant then
                    h.callback(table.unpack(evt.args))
                end
            end
        end
    end
    table.clear(self.queue)
end

-- Resolución de nombre/args
function EventManager:_resolveEvent(event, ...)
    if typeof(event) == "string" then
        return event, { ... }
    else
        return event(...)
    end
end

-- Ejemplos de networking
function EventManager:emitToServer(event, ...)
    local name, args = self:_resolveEvent(event, ...)
    self.remoteEvent:FireServer(name, args)
end

function EventManager:emitToClient(client, event, ...)
    local name, args = self:_resolveEvent(event, ...)
    self.remoteEvent:FireClient(client, name, args)
end

function EventManager:emitToAllClients(event, ...)
    local name, args = self:_resolveEvent(event, ...)
    self.remoteEvent:FireAllClients(name, args)
end

return EventManager
