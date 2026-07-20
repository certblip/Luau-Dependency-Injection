--[[
	PlayerService

	Coordinates player-related operations.
	Depends on both InventoryService and EconomyService.
]]

local Players = game:GetService("Players")

return {

	Name = "PlayerService",

	Lifetime = "Singleton",

	Dependencies = { "InventoryService", "EconomyService" },

	Constructor = function(resolve)

		local Inventory = resolve("InventoryService")
		local Economy = resolve("EconomyService")

		local self = {}

		function self:Init()

			print("[PlayerService] Initialized.")

			Players.PlayerAdded:Connect(function(player)
				Inventory:AddItem(player.UserId, "Starter Sword")
				Economy:AddCoins(player.UserId, 100)
			end)

		end

		function self:GetCoins(player)
			return Economy:GetCoins(player.UserId)
		end

		function self:GetInventory(player)
			return Inventory:GetInventory(player.UserId)
		end

		return self

	end,

}
