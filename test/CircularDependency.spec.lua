local LuauDI = require(script.Parent.Parent.src)

-- 1. Runtime detection (dependencies discovered while constructing).
do
	local DI = LuauDI.new()

	DI:Register({
		Name = "A",
		Lifetime = "Singleton",
		Constructor = function(resolve)
			resolve("B")
			return {}
		end,
	})

	DI:Register({
		Name = "B",
		Lifetime = "Singleton",
		Constructor = function(resolve)
			resolve("A")
			return {}
		end,
	})

	local success = pcall(function()
		DI:Get("A")
	end)

	assert(not success, "Expected runtime circular dependency detection.")
end

-- 2. Static detection (declared dependencies, before construction).
do
	local DI = LuauDI.new()

	DI:Register({
		Name = "X",
		Lifetime = "Singleton",
		Dependencies = { "Y" },
		Constructor = function()
			return {}
		end,
	})

	DI:Register({
		Name = "Y",
		Lifetime = "Singleton",
		Dependencies = { "X" },
		Constructor = function()
			return {}
		end,
	})

	local success = pcall(function()
		DI:Validate()
	end)

	assert(not success, "Expected static circular dependency detection via Validate().")
end

print("[CircularDependency.spec] passed")
