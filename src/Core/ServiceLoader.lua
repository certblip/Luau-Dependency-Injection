--!strict
--[[
	ServiceLoader.lua

	Automatically loads every service module contained inside a folder
	(recursively). Each ModuleScript must return a ServiceDefinition.

	Validation runs once, after all definitions are registered, so the
	dependency graph is complete and circular references are caught up
	front — provided services declare their `Dependencies`.
]]

local ServiceLoader = {}

export type Container = {
	Register: (self: any, definition: any) -> (),
	Validate: (self: any) -> (),
}

local function loadInto(container: Container, instance: Instance)
	for _, child in ipairs(instance:GetChildren()) do
		if child:IsA("ModuleScript") then
			local definition = require(child) :: any
			container:Register(definition)
		end

		-- Recurse into folders / nested containers.
		if #child:GetChildren() > 0 then
			loadInto(container, child)
		end
	end
end

function ServiceLoader.Load(container: Container, folder: Instance)
	loadInto(container, folder)
	container:Validate()
end

return ServiceLoader
