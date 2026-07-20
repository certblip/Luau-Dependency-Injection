--!strict
--[[
	DIContainer.lua

	The dependency injection container.

	Responsibilities:
		• Register services (with optional statically-declared dependencies).
		• Resolve dependencies and inject them via the Constructor.
		• Manage service lifetimes (Singleton caching / Transient recreation).
		• Detect circular dependencies — statically (via the graph) and at
		  runtime (via the construction stack) as a safety net.
		• Track instantiation so lifecycle hooks run in a sensible order.
]]

local DependencyGraph = require(script.Parent.DependencyGraph)
local ServiceDefinitionType = require(script.Parent.Parent.Types.ServiceDefinition)

type ServiceDefinition = ServiceDefinitionType.ServiceDefinition

local DIContainer = {}
DIContainer.__index = DIContainer

export type DIContainer = typeof(setmetatable(
	{} :: {
		_definitions: { [string]: ServiceDefinition },
		_instances: { [string]: any },
		_singletonOrder: { string },
		_constructing: { [string]: boolean },
		_graph: DependencyGraph.DependencyGraph,
	},
	DIContainer
))

function DIContainer.new(): DIContainer
	return setmetatable({
		_definitions = {},
		_instances = {},
		_singletonOrder = {},
		_constructing = {},
		_graph = DependencyGraph.new(),
	}, DIContainer)
end

function DIContainer.Register(self: DIContainer, definition: ServiceDefinition)
	assert(type(definition) == "table", "Service definition must be a table.")
	assert(definition.Name, "Service is missing Name.")
	assert(definition.Constructor, ("Service '%s' is missing Constructor."):format(definition.Name))

	assert(
		not self._definitions[definition.Name],
		("Service '%s' is already registered."):format(definition.Name)
	)

	-- Default to Singleton and validate the value.
	local lifetime = definition.Lifetime or "Singleton"
	assert(
		lifetime == "Singleton" or lifetime == "Transient",
		("Service '%s' has invalid Lifetime '%s'."):format(definition.Name, tostring(lifetime))
	)
	definition.Lifetime = lifetime

	self._definitions[definition.Name] = definition

	self._graph:Add(definition.Name)

	-- Build the graph up front from statically-declared dependencies so
	-- Validate() is meaningful before anything is constructed.
	if definition.Dependencies then
		for _, dependency in ipairs(definition.Dependencies) do
			self._graph:AddDependency(definition.Name, dependency)
		end
	end
end

function DIContainer.Get(self: DIContainer, serviceName: string): any
	local definition = self._definitions[serviceName]

	assert(definition, ("Unknown service '%s'."):format(serviceName))

	-- Return the cached singleton if we already built it.
	if definition.Lifetime == "Singleton" then
		local existing = self._instances[serviceName]
		if existing ~= nil then
			return existing
		end
	end

	-- Runtime safety net for cycles that were not declared statically.
	if self._constructing[serviceName] then
		error(("Circular dependency detected while resolving '%s'."):format(serviceName), 0)
	end

	self._constructing[serviceName] = true

	local ok, result = pcall(definition.Constructor, function(dependency: string): any
		-- Record the edge (also catches undeclared dependencies) and resolve.
		self._graph:AddDependency(serviceName, dependency)
		return self:Get(dependency)
	end)

	-- Always clear the construction flag, even on error.
	self._constructing[serviceName] = nil

	if not ok then
		error(result, 0)
	end

	if definition.Lifetime == "Singleton" then
		self._instances[serviceName] = result
		table.insert(self._singletonOrder, serviceName)
	end

	return result
end

-- Resolve every registered singleton, in dependency order, so that
-- Initialize() can iterate a fully-populated, correctly-ordered set.
function DIContainer.ResolveAll(self: DIContainer)
	local order = self._graph:TopologicalOrder()

	for _, serviceName in ipairs(order) do
		local definition = self._definitions[serviceName]
		if definition and definition.Lifetime == "Singleton" then
			self:Get(serviceName)
		end
	end

	-- Any singleton with no graph edges at all still needs resolving.
	for serviceName, definition in pairs(self._definitions) do
		if definition.Lifetime == "Singleton" and self._instances[serviceName] == nil then
			self:Get(serviceName)
		end
	end
end

-- Singleton instances in the order they should be initialized
-- (dependencies before dependents).
function DIContainer.GetInitializationOrder(self: DIContainer): { any }
	local ordered = {}
	for _, serviceName in ipairs(self._singletonOrder) do
		table.insert(ordered, self._instances[serviceName])
	end
	return ordered
end

function DIContainer.Validate(self: DIContainer)
	self._graph:Validate()
end

function DIContainer.IsRegistered(self: DIContainer, serviceName: string): boolean
	return self._definitions[serviceName] ~= nil
end

function DIContainer.Clear(self: DIContainer)
	-- Dispose instantiated services (dependents first) before dropping them.
	for i = #self._singletonOrder, 1, -1 do
		local instance = self._instances[self._singletonOrder[i]]
		if instance and type(instance.Dispose) == "function" then
			instance:Dispose()
		end
	end

	table.clear(self._definitions)
	table.clear(self._instances)
	table.clear(self._singletonOrder)
	table.clear(self._constructing)

	self._graph = DependencyGraph.new()
end

return DIContainer
