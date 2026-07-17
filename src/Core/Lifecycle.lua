--[[
	Lifecycle.lua

	Handles service initialization and startup.

	If a service exposes:
		:Init()
	it will be initialized first.

	If a service exposes:
		:Start()
	it will be started after every service has
	finished initialization.
]]

local Lifecycle = {}
Lifecycle.__index = Lifecycle

function Lifecycle.new(container)

	return setmetatable({
		_container = container
	}, Lifecycle)

end

function Lifecycle:Initialize()

	for _, instance in pairs(self._container._instances) do

		if type(instance.Init) == "function" then
			instance:Init()
		end

	end

	for _, instance in pairs(self._container._instances) do

		if type(instance.Start) == "function" then
			instance:Start()
		end

	end

end

return Lifecycle
