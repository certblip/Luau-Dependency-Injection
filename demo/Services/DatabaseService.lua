--[[
	DatabaseService

	Responsible for persisting player data.

	This example uses an in-memory table to simulate a database backend.
]]

return {

	Name = "DatabaseService",

	Lifetime = "Singleton",

	Dependencies = {},

	Constructor = function(resolve)

		local self = {}

		local storage = {}

		function self:Init()
			print("[DatabaseService] Initialized.")
		end

		function self:LoadPlayer(userId)
			return storage[userId] or {
				Coins = 0,
				Inventory = {},
			}
		end

		function self:SavePlayer(userId, data)
			storage[userId] = data
		end

		return self

	end,

}
