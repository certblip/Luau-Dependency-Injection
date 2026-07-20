local LuauDI = require(script.Parent.Parent.src)

local DI = LuauDI.new()

DI:Register({
	Name = "Example",
	Lifetime = "Singleton",
	Constructor = function()
		return {}
	end,
})

local a = DI:Get("Example")
local b = DI:Get("Example")

assert(a == b, "Singleton services should return the same instance.")

print("[Singleton.spec] passed")
