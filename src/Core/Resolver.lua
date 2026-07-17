
--[[
	Resolver.lua

	Provides dependency resolution for registered services.

	The resolver delegates instance creation to the DI container,
	while keeping dependency lookup isolated from service logic.
]]

local Resolver = {}
Resolver.__index = Resolver

export type Resolver = {
	_container: any,

	Resolve: (self: Resolver, serviceName: string) -> any
}

function Resolver.new(container)
	return setmetatable({
		_container = container
	}, Resolver)
end

function Resolver:Resolve(serviceName: string)
	return self._container:Get(serviceName)
end

return Resolver
