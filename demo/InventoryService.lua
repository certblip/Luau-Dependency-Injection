--[[
	InventoryService

	Manages player inventories.

	Depends on DatabaseService.
]]

local Lifetime = require(script.Parent.Parent.src.Types.Lifetime)

return {

	Name = "InventoryService",

	Lifetime = Lifetime.Singleton,

	Constructor = function(resolve)

		local Database = resolve("DatabaseService")

		local self = {}

		function self:Init()

			print("[InventoryService] Initialized.")

		end

		function self:GetInventory(userId)

			return Database:LoadPlayer(userId).Inventory

		end

		function self:AddItem(userId, item)

			local data = Database:LoadPlayer(userId)

			table.insert(data.Inventory, item)

			Database:SavePlayer(userId, data)

		end

		return self

	end

}
