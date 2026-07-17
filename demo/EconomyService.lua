--[[
	EconomyService

	Handles player currency.

	Depends on DatabaseService.
]]

local Lifetime = require(script.Parent.Parent.src.Types.Lifetime)

return {

	Name = "EconomyService",

	Lifetime = Lifetime.Singleton,

	Constructor = function(resolve)

		local Database = resolve("DatabaseService")

		local self = {}

		function self:Init()

			print("[EconomyService] Initialized.")

		end

		function self:AddCoins(userId, amount)

			local data = Database:LoadPlayer(userId)

			data.Coins += amount

			Database:SavePlayer(userId, data)

		end

		function self:GetCoins(userId)

			return Database:LoadPlayer(userId).Coins

		end

		return self

	end

}
