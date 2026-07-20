--!strict
--[[
	Resolver.lua

	Provides dependency resolution for registered services.

	The resolver is the seam between service logic and the container:
	services receive a plain `resolve(name)` function and never touch
	the container directly. This keeps service code decoupled from the
	container implementation and makes dependency lookup easy to stub
	in tests.
]]

local Resolver = {}
Resolver.__index = Resolver

export type Container = {
	Get: (self: any, serviceName: string) -> any,
}

export type Resolver = typeof(setmetatable(
	{} :: { _container: Container },
	Resolver
))

function Resolver.new(container: Container): Resolver
	return setmetatable({
		_container = container,
	}, Resolver)
end

function Resolver.Resolve(self: Resolver, serviceName: string): any
	return self._container:Get(serviceName)
end

-- Returns a bound `resolve` function suitable for handing to a
-- service Constructor.
function Resolver.CreateFunction(self: Resolver): (string) -> any
	return function(serviceName: string): any
		return self:Resolve(serviceName)
	end
end

return Resolver
