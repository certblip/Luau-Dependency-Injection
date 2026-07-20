--!strict
--[[
	DependencyGraph.lua

	Maintains the dependency graph used by the container.

	Responsibilities:
		• Track which services depend on which.
		• Detect circular dependencies (reporting the exact cycle).
		• Produce a topological ordering so services can be initialized
		  in dependency order (dependencies before dependents).

	Edges are stored as a set per node, so repeatedly declaring the
	same dependency never produces duplicates.
]]

local DependencyGraph = {}
DependencyGraph.__index = DependencyGraph

export type DependencyGraph = typeof(setmetatable(
	{} :: {
		_edges: { [string]: { [string]: true } },
	},
	DependencyGraph
))

function DependencyGraph.new(): DependencyGraph
	return setmetatable({
		_edges = {},
	}, DependencyGraph)
end

function DependencyGraph.Add(self: DependencyGraph, serviceName: string)
	if not self._edges[serviceName] then
		self._edges[serviceName] = {}
	end
end

function DependencyGraph.AddDependency(self: DependencyGraph, serviceName: string, dependency: string)
	self:Add(serviceName)
	self:Add(dependency)

	-- Stored as a set to avoid duplicate edges.
	self._edges[serviceName][dependency] = true
end

-- Depth-first search that raises with the full cycle path when it
-- revisits a node currently on the recursion stack.
local function visit(
	edges: { [string]: { [string]: true } },
	node: string,
	visiting: { [string]: boolean },
	visited: { [string]: boolean },
	stack: { string }
)
	if visiting[node] then
		local cycleStart = table.find(stack, node) or #stack
		local path = table.concat(stack, " -> ", cycleStart)
		error(("Circular dependency detected: %s -> %s"):format(path, node), 0)
	end

	if visited[node] then
		return
	end

	visiting[node] = true
	table.insert(stack, node)

	for dependency in pairs(edges[node] or {}) do
		visit(edges, dependency, visiting, visited, stack)
	end

	table.remove(stack)
	visiting[node] = nil
	visited[node] = true
end

-- Raises if the graph contains a cycle. Safe to call before any
-- service is constructed, provided dependencies were declared.
function DependencyGraph.Validate(self: DependencyGraph)
	local visiting: { [string]: boolean } = {}
	local visited: { [string]: boolean } = {}

	for node in pairs(self._edges) do
		visit(self._edges, node, visiting, visited, {})
	end
end

-- Returns node names in dependency order: every service appears
-- after all of the services it depends on. Raises on cycles.
function DependencyGraph.TopologicalOrder(self: DependencyGraph): { string }
	local visiting: { [string]: boolean } = {}
	local visited: { [string]: boolean } = {}
	local order: { string } = {}

	local function walk(node: string, stack: { string })
		if visiting[node] then
			local cycleStart = table.find(stack, node) or #stack
			local path = table.concat(stack, " -> ", cycleStart)
			error(("Circular dependency detected: %s -> %s"):format(path, node), 0)
		end

		if visited[node] then
			return
		end

		visiting[node] = true
		table.insert(stack, node)

		for dependency in pairs(self._edges[node] or {}) do
			walk(dependency, stack)
		end

		table.remove(stack)
		visiting[node] = nil
		visited[node] = true
		table.insert(order, node)
	end

	for node in pairs(self._edges) do
		walk(node, {})
	end

	return order
end

return DependencyGraph
