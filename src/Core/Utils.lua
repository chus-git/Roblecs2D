local Utils = {}

function Utils.extend(BaseClass)
	
	local SubClass = {}
	SubClass.__index = SubClass

	function SubClass.new(...)
		local baseInstance = BaseClass.new(...)
		return setmetatable(baseInstance, SubClass)
	end

	setmetatable(SubClass, { __index = BaseClass })

	return SubClass
	
end

function Utils.wrapEvent(eventName: string, constructor: ((...any) -> ...any)?)
	local wrapper = {}

	function wrapper:__call(...)
		if constructor then
			return eventName, constructor(...)
		else
			return eventName, nil
		end
	end

	return setmetatable(wrapper, {
		__call = wrapper.__call,
		__tostring = function()
			return eventName
		end,
		__index = {
			name = eventName
		}
	})
	
end

function Utils.wrapComponent(componentName, constructor)

	local wrapper = {}

	function wrapper:__call(...)
		if constructor then
			return componentName, constructor(...)
		else
			return componentName, nil
		end
	end

	setmetatable(wrapper, {
		__call = wrapper.__call,
		__tostring = function() return componentName end,
		__index = {
			name = componentName
		}
	})

	return wrapper
end

function Utils.lerp(a, b, t)
	return a + (b - a) * t
end

return Utils
