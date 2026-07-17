--[[
	DIContainer.lua

	The dependency injection container.

	Responsibilities:
	• Register services
	• Resolve dependencies
	• Manage service lifetimes
	• Cache singleton instances
	• Detect circular dependencies
]]

local Resolver = require(script.Parent.Resolver)
local DependencyGraph = require(script.Parent.DependencyGraph)

local DIContainer = {}
DIContainer.__index = DIContainer

function DIContainer.new()

	local self = setmetatable({}, DIContainer)

	self._definitions = {}
	self._instances = {}
	self._constructing = {}

	self._graph = DependencyGraph.new()
	self._resolver = Resolver.new(self)

	return self

end

function DIContainer:Register(definition)

	assert(definition.Name, "Service is missing Name.")
	assert(definition.Constructor, "Service is missing Constructor.")

	assert(
		not self._definitions[definition.Name],
		("Service '%s' is already registered."):format(definition.Name)
	)

	self._definitions[definition.Name] = definition

	self._graph:Add(definition.Name)

end

function DIContainer:Get(serviceName)

	local definition = self._definitions[serviceName]

	assert(
		definition,
		("Unknown service '%s'."):format(serviceName)
	)

	if definition.Lifetime == "Singleton" then

		if self._instances[serviceName] then
			return self._instances[serviceName]
		end

	end

	if self._constructing[serviceName] then
		error(("Circular dependency detected while resolving '%s'."):format(serviceName))
	end

	self._constructing[serviceName] = true

	local instance = definition.Constructor(function(dependency)

		self._graph:AddDependency(serviceName, dependency)

		return self:Get(dependency)

	end)

	self._constructing[serviceName] = nil

	if definition.Lifetime == "Singleton" then
		self._instances[serviceName] = instance
	end

	return instance

end

function DIContainer:Validate()

	self._graph:Validate()

end

function DIContainer:IsRegistered(serviceName)

	return self._definitions[serviceName] ~= nil

end

function DIContainer:Clear()

	table.clear(self._definitions)
	table.clear(self._instances)
	table.clear(self._constructing)

	self._graph = DependencyGraph.new()

end

return DIContainer
