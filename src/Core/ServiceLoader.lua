--[[
	ServiceLoader.lua

	Automatically loads every service contained
	inside a folder.

	Each module must return a ServiceDefinition.
]]

local ServiceLoader = {}

function ServiceLoader.Load(container, folder)

	for _, moduleScript in ipairs(folder:GetChildren()) do

		if moduleScript:IsA("ModuleScript") then

			local definition = require(moduleScript)

			container:Register(definition)

		end

	end

	container:Validate()

end

return ServiceLoader
