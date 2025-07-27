local Event = {}
Event.__index = Event

function Event.extend()
	local subclass = {}
	subclass.__index = subclass

	function subclass:__call(...)
		if self.constructor then
			return self.name, self.constructor(...)
		else
			return self.name, nil
		end
	end

	return setmetatable(subclass, {
		__index = Event,
		__call = function(self, ...)
			return self:__call(...)
		end,
		__tostring = function()
			return subclass.name
		end
	})
end

return Event