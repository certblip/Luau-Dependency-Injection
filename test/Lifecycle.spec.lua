local LuauDI = require(script.Parent.Parent.src)

local DI = LuauDI.new()

local events = {}

DI:Register({
	Name = "Database",
	Lifetime = "Singleton",
	Constructor = function()
		local self = {}
		function self:Init()
			table.insert(events, "Database.Init")
		end
		function self:Start()
			table.insert(events, "Database.Start")
		end
		function self:Dispose()
			table.insert(events, "Database.Dispose")
		end
		return self
	end,
})

DI:Register({
	Name = "Economy",
	Lifetime = "Singleton",
	Dependencies = { "Database" },
	Constructor = function(resolve)
		resolve("Database")
		local self = {}
		function self:Init()
			table.insert(events, "Economy.Init")
		end
		function self:Dispose()
			table.insert(events, "Economy.Dispose")
		end
		return self
	end,
})

DI:Initialize()

-- Database is a dependency of Economy, so it must Init first.
local dbInit = table.find(events, "Database.Init")
local ecoInit = table.find(events, "Economy.Init")
assert(dbInit and ecoInit, "Both services should have initialized.")
assert(dbInit < ecoInit, "Dependencies should Init before dependents.")

-- All Init calls come before any Start call.
local dbStart = table.find(events, "Database.Start")
assert(dbStart and dbStart > ecoInit, "Start should run after all Init calls.")

DI:Dispose()

-- Dependents dispose before dependencies.
local ecoDispose = table.find(events, "Economy.Dispose")
local dbDispose = table.find(events, "Database.Dispose")
assert(ecoDispose and dbDispose, "Both services should have disposed.")
assert(ecoDispose < dbDispose, "Dependents should Dispose before dependencies.")

print("[Lifecycle.spec] passed")
