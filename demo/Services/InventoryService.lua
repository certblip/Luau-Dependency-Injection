--[[
	InventoryService

	Manages player inventories. Depends on DatabaseService.
]]

return {

	Name = "InventoryService",

	Lifetime = "Singleton",

	Dependencies = { "DatabaseService" },

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

	end,

}
