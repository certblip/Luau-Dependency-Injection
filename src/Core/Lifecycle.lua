--!strict
--[[
	Lifecycle.lua

	Handles service initialization, startup and disposal.

	On Initialize():
		1. Every registered singleton is resolved (so none are skipped
		   just because nothing requested them yet).
		2. :Init() is called on each service that defines it, in
		   dependency order (dependencies before dependents).
		3. :Start() is called on each service that defines it, after
		   every service has finished Init().

	On Dispose():
		:Dispose() is called on each service that defines it, in
		reverse order (dependents before dependencies).
]]

local Lifecycle = {}
Lifecycle.__index = Lifecycle

export type Container = {
	ResolveAll: (self: any) -> (),
	GetInitializationOrder: (self: any) -> { any },
	Clear: (self: any) -> (),
}

export type Lifecycle = typeof(setmetatable(
	{} :: { _container: Container },
	Lifecycle
))

function Lifecycle.new(container: Container): Lifecycle
	return setmetatable({
		_container = container,
	}, Lifecycle)
end

function Lifecycle.Initialize(self: Lifecycle)
	-- Make sure every singleton exists and the init order is populated.
	self._container:ResolveAll()

	local ordered = self._container:GetInitializationOrder()

	for _, instance in ipairs(ordered) do
		if type(instance.Init) == "function" then
			instance:Init()
		end
	end

	for _, instance in ipairs(ordered) do
		if type(instance.Start) == "function" then
			instance:Start()
		end
	end
end

function Lifecycle.Dispose(self: Lifecycle)
	local ordered = self._container:GetInitializationOrder()

	for i = #ordered, 1, -1 do
		local instance = ordered[i]
		if type(instance.Dispose) == "function" then
			instance:Dispose()
		end
	end
end

return Lifecycle
