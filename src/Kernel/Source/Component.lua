local Component = {}
Component.__index = Component

function Component.extend()
	local subclass = {}
	subclass.__index = subclass

	-- Cada componente debe definir su name y constructor.
	-- Este __call permite hacer Interpolation(...) sin pasar self
	function subclass:__call(...)
		if self.constructor then
			return self.name, self.constructor(...)
		else
			return self.name, nil
		end
	end

	-- Metatable para que el objeto tenga el metamétodo __call
	return setmetatable(subclass, {
		__index = Component,
		__call = function(self, ...)
			return self:__call(...)
		end,
		__tostring = function()
			return subclass.name
		end
	})
end

return Component