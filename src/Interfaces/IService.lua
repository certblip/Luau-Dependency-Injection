--!strict
--[[
	IService.lua

	Base service interface.

	Services may implement any of these optional lifecycle
	methods depending on their needs.

	• Init()    — called during Initialize(), in dependency order.
	• Start()   — called after every service has finished Init().
	• Dispose() — called on Clear()/shutdown for cleanup.
]]

export type IService = {
	Init: ((self: any) -> ())?,
	Start: ((self: any) -> ())?,
	Dispose: ((self: any) -> ())?,
}

return {}
