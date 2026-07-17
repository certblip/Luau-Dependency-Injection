--[[
	Lifetime.lua

	Defines supported service lifetimes.
]]

export type Lifetime = "Singleton" | "Transient"

return table.freeze({

	Singleton = "Singleton",

	Transient = "Transient"

})
