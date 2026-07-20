--!strict
--[[
	IDisposable.lua

	Optional interface for services that allocate external resources.

	Dispose() is called by the container when it is cleared or shut
	down (see DIContainer:Clear and Lifecycle:Dispose).
]]

export type IDisposable = {
	Dispose: (self: any) -> (),
}

return {}
