local RunService = game:GetService("RunService")

local EventBus = {}
EventBus.__index = EventBus

function EventBus.new(remoteEvent)
	local self = setmetatable({}, EventBus)
	self.listeners = {}
	self.queue = {}
	self.remoteEvent = remoteEvent
	return self
end

function EventBus:on(event, callback)

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

function EventBus:emit(event, ...)

	local eventName, args

	if typeof(event) == "string" then
		eventName = event
		args = {...}
	else
		eventName, args = event(...)
	end

	table.insert(self.queue, {
		name = eventName,
		args = args
	})

end

function EventBus:emitToServer(event, ...)
	local eventName, args

	if typeof(event) == "string" then
		eventName = event
		args = { ... }
	else
		eventName, args = event(...)
	end

	self.remoteEvent:FireServer(eventName, args)
end

function EventBus:emitToClient(client, event, ...)
	local eventName, args

	if typeof(event) == "string" then
		eventName = event
		args = { ... }
	else
		eventName, args = event(...)
	end

	self.remoteEvent:FireClient(client, eventName, args)
end

function EventBus:emitToAllClients(event, ...)
	local eventName, args

	if typeof(event) == "string" then
		eventName = event
		args = { ... }
	else
		eventName, args = event(...)
	end

	self.remoteEvent:FireAllClients(eventName, args)
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
