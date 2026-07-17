--[[
	Bootstrap

	Initializes the dependency injection container
	and loads all demo services.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LuauDI = require(ReplicatedStorage.LuauDI)

local Services = script.Parent

LuauDI:Load(Services)

LuauDI:Initialize()

print("Luau DI demo initialized successfully")
