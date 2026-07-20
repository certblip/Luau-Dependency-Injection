--!strict
--[[
	Luau DI

	Public entry point.

	Two ways to use it:

	1. Shared default container (convenient for a whole game):

		local DI = require(ReplicatedStorage.Packages.LuauDI)
		DI:Register({ Name = "Foo", Constructor = ... })
		DI:Initialize()
		local foo = DI:Get("Foo")

	2. Isolated container (recommended for tests / multiple scopes):

		local LuauDI = require(ReplicatedStorage.Packages.LuauDI)
		local container = LuauDI.new()
		container:Register({ ... })
		container:Initialize()
]]

local DIContainer = require(script.Core.DIContainer)
local Lifecycle = require(script.Core.Lifecycle)
local ServiceLoader = require(script.Core.ServiceLoader)

local Lifetime = require(script.Types.Lifetime)
local ServiceDefinition = require(script.Types.ServiceDefinition)

type ServiceDefinition = ServiceDefinition.ServiceDefinition

-- A self-contained DI facade wrapping one container + lifecycle.
local Instance = {}
Instance.__index = Instance

export type LuauDI = typeof(setmetatable(
	{} :: {
		_container: DIContainer.DIContainer,
		_lifecycle: Lifecycle.Lifecycle,
	},
	Instance
))

local function createInstance(): LuauDI
	local container = DIContainer.new()
	local lifecycle = Lifecycle.new(container :: any)

	return setmetatable({
		_container = container,
		_lifecycle = lifecycle,
	}, Instance)
end

function Instance.Register(self: LuauDI, definition: ServiceDefinition)
	self._container:Register(definition)
end

function Instance.Get(self: LuauDI, serviceName: string): any
	return self._container:Get(serviceName)
end

function Instance.Load(self: LuauDI, folder: any)
	ServiceLoader.Load(self._container :: any, folder)
end

function Instance.Initialize(self: LuauDI)
	self._lifecycle:Initialize()
end

function Instance.Dispose(self: LuauDI)
	self._lifecycle:Dispose()
end

function Instance.IsRegistered(self: LuauDI, serviceName: string): boolean
	return self._container:IsRegistered(serviceName)
end

function Instance.Validate(self: LuauDI)
	self._container:Validate()
end

function Instance.Clear(self: LuauDI)
	self._container:Clear()
end

-- Default shared container, plus the pieces consumers may need.
-- Methods are forwarded explicitly (rather than via __index) so that
-- `DI:Method()` binds `self` to the default instance, not the facade.
local defaultInstance = createInstance()

local LuauDI = {
	Lifetime = Lifetime,
	ServiceDefinition = ServiceDefinition,

	-- Factory for an isolated container (does not share state with default).
	new = createInstance,
}

function LuauDI:Register(definition: ServiceDefinition)
	defaultInstance:Register(definition)
end

function LuauDI:Get(serviceName: string): any
	return defaultInstance:Get(serviceName)
end

function LuauDI:Load(folder: any)
	defaultInstance:Load(folder)
end

function LuauDI:Initialize()
	defaultInstance:Initialize()
end

function LuauDI:Dispose()
	defaultInstance:Dispose()
end

function LuauDI:IsRegistered(serviceName: string): boolean
	return defaultInstance:IsRegistered(serviceName)
end

function LuauDI:Validate()
	defaultInstance:Validate()
end

function LuauDI:Clear()
	defaultInstance:Clear()
end

return table.freeze(LuauDI)
