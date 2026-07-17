--[[
	Luau DI

	Public entry point.

	Example:

	local DI = require(ReplicatedStorage.Packages.LuauDI)

	DI:Register(...)
	DI:Get(...)
]]

local DIContainer = require(script.Core.DIContainer)
local ServiceLoader = require(script.Core.ServiceLoader)
local Lifecycle = require(script.Core.Lifecycle)

local container = DIContainer.new()
local lifecycle = Lifecycle.new(container)

local LuauDI = {}

function LuauDI:Register(serviceDefinition)

	container:Register(serviceDefinition)

end

function LuauDI:Get(serviceName)

	return container:Get(serviceName)

end

function LuauDI:Load(folder)

	ServiceLoader.Load(container, folder)

end

function LuauDI:Initialize()

	lifecycle:Initialize()

end

function LuauDI:IsRegistered(serviceName)

	return container:IsRegistered(serviceName)

end

function LuauDI:Validate()

	container:Validate()

end

function LuauDI:Clear()

	container:Clear()

end

return table.freeze(LuauDI)
