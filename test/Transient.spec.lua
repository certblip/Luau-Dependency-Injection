local LuauDI = require(script.Parent.Parent.src)

local DI = LuauDI.new()

DI:Register({
	Name = "Transient",
	Lifetime = "Transient",
	Constructor = function()
		return {}
	end,
})

local a = DI:Get("Transient")
local b = DI:Get("Transient")

assert(a ~= b, "Transient services should return a new instance each time.")

print("[Transient.spec] passed")
