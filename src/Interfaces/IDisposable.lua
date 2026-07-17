--[[
	IDisposable.lua

	Optional interface for services that allocate
	external resources.

	Dispose() is intended to be called when the
	container shuts down.
]]

export type IDisposable = {

	Dispose: (self: any) -> ()

}

return {}
