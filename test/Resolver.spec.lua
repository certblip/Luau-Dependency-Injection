local LuauDI = require(script.Parent.Parent.src)

local DI = LuauDI.new()

DI:Register({
	Name = "Database",
	Lifetime = "Singleton",
	Constructor = function()
		return { connected = true }
	end,
})

DI:Register({
	Name = "Inventory",
	Lifetime = "Singleton",
	Dependencies = { "Database" },
	Constructor = function(resolve)
		local Database = resolve("Database")
		assert(Database, "Inventory should receive its Database dependency.")
		assert(Database.connected, "Database should be usable when injected.")
		return {}
	end,
})

local inventory = DI:Get("Inventory")
assert(inventory, "Inventory should resolve.")

print("[Resolver.spec] passed")
