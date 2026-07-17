--[[
	ServiceDefinition.lua

	Represents a registered service inside the container.
]]

export type Constructor = (resolve: (string) -> any) -> any

export type ServiceDefinition = {
	Name: string,
	Lifetime: "Singleton" | "Transient",
	Constructor: Constructor
}

return {}
