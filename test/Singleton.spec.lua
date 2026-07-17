local DI = require(script.Parent.Parent.src)

local Lifetime = require(script.Parent.Parent.src.Types.Lifetime)

DI:Register({

	Name = "Example",

	Lifetime = Lifetime.Singleton,

	Constructor = function()

		return {}

	end

})

local a = DI:Get("Example")
local b = DI:Get("Example")

assert(a == b, "Singleton services should return the same instance.")
