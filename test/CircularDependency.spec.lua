local DI = require(script.Parent.Parent.src)

local Lifetime = require(script.Parent.Parent.src.Types.Lifetime)

DI:Register({

	Name = "A",

	Lifetime = Lifetime.Singleton,

	Constructor = function(resolve)

		resolve("B")

		return {}

	end

})

DI:Register({

	Name = "B",

	Lifetime = Lifetime.Singleton,

	Constructor = function(resolve)

		resolve("A")

		return {}

	end

})

local success = pcall(function()

	DI:Get("A")

end)

assert(not success, "Expected circular dependency detection.")
