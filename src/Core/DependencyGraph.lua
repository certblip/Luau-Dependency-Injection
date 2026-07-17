--[[
	DependencyGraph.lua

	Maintains the dependency graph used by the container.

	This graph is responsible for detecting circular
	dependencies before services are instantiated.
]]

local DependencyGraph = {}
DependencyGraph.__index = DependencyGraph

function DependencyGraph.new()

	return setmetatable({
		_graph = {}
	}, DependencyGraph)

end

function DependencyGraph:Add(serviceName: string)

	if not self._graph[serviceName] then
		self._graph[serviceName] = {}
	end

end

function DependencyGraph:AddDependency(serviceName: string, dependency: string)

	self:Add(serviceName)

	table.insert(self._graph[serviceName], dependency)

end

local function Visit(graph, node, visiting, visited)

	if visiting[node] then
		error(("Circular dependency detected involving '%s'."):format(node))
	end

	if visited[node] then
		return
	end

	visiting[node] = true

	for _, dependency in ipairs(graph[node] or {}) do
		Visit(graph, dependency, visiting, visited)
	end

	visiting[node] = nil
	visited[node] = true

end

function DependencyGraph:Validate()

	local visiting = {}
	local visited = {}

	for node in pairs(self._graph) do
		Visit(self._graph, node, visiting, visited)
	end

end

return DependencyGraph
