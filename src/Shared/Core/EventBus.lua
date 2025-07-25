local RunService = game:GetService("RunService")

local EventBus = {}
EventBus.__index = EventBus

function EventBus.new(eventTypes, remoteEvent)
	local self = setmetatable({}, EventBus)
	self.eventTypes = eventTypes
	self.listeners = {}
	self.queue = {}
	self.remoteEvent = remoteEvent
	return self
end

function EventBus:on(eventName, callback)
	if not self.listeners[eventName] then
		self.listeners[eventName] = {}
	end
	table.insert(self.listeners[eventName], callback)
	
	-- Devolver función de desuscripción
	return function()
		local handlers = self.listeners[eventName]
		if not handlers then return end

		for i = #handlers, 1, -1 do
			if handlers[i] == callback then
				table.remove(handlers, i)
				break
			end
		end
	end
end

function EventBus:emit(eventName, ...)
	table.insert(self.queue, {
		name = eventName,
		args = {...}
	})
end

function EventBus:emitToServer(eventName, ...)
	self.remoteEvent:FireServer(eventName, ...)
end

function EventBus:emitToClient(client, eventName, ...)
	self.remoteEvent:FireClient(client, eventName, ...)
end

function EventBus:emitToAllClients(eventName, ...)
	self.remoteEvent:FireAllClients(eventName, ...)
end

function EventBus:flush()
	for _, event in ipairs(self.queue) do
		local handlers = self.listeners[event.name]
		if handlers then
			for _, handler in ipairs(handlers) do
				handler(table.unpack(event.args))
			end
		end
	end
	table.clear(self.queue)
end

return EventBus
