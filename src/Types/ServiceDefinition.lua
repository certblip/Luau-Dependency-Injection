--!strict
--[[
	ServiceDefinition.lua

	Represents a registered service inside the container.

	Fields:
		Name         — unique service identifier.
		Constructor  — factory that receives a `resolve` function and
		               returns the service instance.
		Lifetime     — optional; defaults to "Singleton" when omitted.
		Dependencies — optional; the names of services this one depends on.
		               When provided, the container can validate the whole
		               dependency graph *before* any service is constructed.
]]

export type Resolve = (serviceName: string) -> any

export type Constructor = (resolve: Resolve) -> any

export type ServiceDefinition = {
	Name: string,
	Constructor: Constructor,
	Lifetime: ("Singleton" | "Transient")?,
	Dependencies: { string }?,
}

return {}
