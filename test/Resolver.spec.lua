local DI = require(script.Parent.Parent.src)

local Lifetime = require(script.Parent.Parent.src.Types.Lifetime)

DI:Register({

	Name = "Database",

	Lifetime = Lifetime.Singleton,

	Constructor = function()

		return {}

	end

})

DI:Register({

	Name = "Inventory",

	Lifetime = Lifetime.Singleton,

	Constructor = function(resolve)

		local Database = resolve("Database")

		assert(Database)

		return {}

	end

})

DI:Get("Inventory")
