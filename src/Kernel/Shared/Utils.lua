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

function Utils.lerp(a, b, t)
	return a + (b - a) * t
end

return Utils
