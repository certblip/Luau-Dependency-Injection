--!strict
--[[
	Lifetime.lua

	Defines supported service lifetimes.

	• Singleton — one shared instance, cached after first resolution.
	• Transient — a fresh instance is created on every resolution.
]]

export type Lifetime = "Singleton" | "Transient"

return table.freeze({

	Singleton = "Singleton" :: Lifetime,

	Transient = "Transient" :: Lifetime,

})
