--[[
	Bootstrap

	Initializes the dependency injection container and loads all demo
	services from the sibling `Services` folder.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LuauDI = require(ReplicatedStorage.LuauDI)

local Services = script.Parent:WaitForChild("Services")

-- Load every service module, then validate the dependency graph.
LuauDI:Load(Services)

-- Resolve and run Init()/Start() in dependency order.
LuauDI:Initialize()

print("Luau DI demo initialized successfully")
