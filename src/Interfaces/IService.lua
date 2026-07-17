--[[
	IService.lua

	Base service interface.

	Services may implement one or both lifecycle
	methods depending on their needs.
]]

export type IService = {

	Init: ((self: any) -> ())?,

	Start: ((self: any) -> ())?

}

return {}
