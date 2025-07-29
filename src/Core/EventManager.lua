local RunService = game:GetService("RunService")

local EventManager = {}
EventManager.__index = EventManager

function EventManager.new(remoteEvent)
	local self = setmetatable({}, EventManager)
	self.listeners = {}
	self.queue = {}
	self.remoteEvent = remoteEvent
	return self
end

function EventManager:on(event, callback)

	local eventName = typeof(event) == "string" and event or tostring(event)

	if not self.listeners[eventName] then
		self.listeners[eventName] = {}
	end

	local wrappedCallback = function(...)
		callback(...)
	end

	table.insert(self.listeners[eventName], wrappedCallback)

	return function()
		local handlers = self.listeners[eventName]
		if not handlers then return end

		for i = #handlers, 1, -1 do
			if handlers[i] == wrappedCallback then
				table.remove(handlers, i)
				break
			end
		end
	end

end

function EventManager:_resolveEvent(event, ...)
	if typeof(event) == "string" then
		return event, { ... }
	else
		return event(...)
	end
end

function EventManager:emit(event, ...)
	local eventName, args = self:_resolveEvent(event, ...)
	table.insert(self.queue, {
		name = eventName,
		args = args
	})
end

function EventManager:emitToServer(event, ...)
	local eventName, args = self:_resolveEvent(event, ...)
	self.remoteEvent:FireServer(eventName, args)
end

function EventManager:emitToClient(client, event, ...)
	local eventName, args = self:_resolveEvent(event, ...)
	self.remoteEvent:FireClient(client, eventName, args)
end

function EventManager:emitToAllClients(event, ...)
	local eventName, args = self:_resolveEvent(event, ...)
	self.remoteEvent:FireAllClients(eventName, args)
end

function EventManager:flush()
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

return EventManager
