Items = {}
local InventoriesIndex, Inventories, SharedInventories = {}, {}, {}

MySQL.ready(function()
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')

	for k, v in pairs(items) do
		Items[v.name] = v.label
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')

	for k, v in pairs(result) do
		local name = v.name
		local label = v.label
		local shared = v.shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
			['@inventory_name'] = name
		})

		if shared == 0 then
			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items = {}

			for k1, v1 in pairs(result2) do
				local itemName = v1.name
				local itemCount = v1.count
				local itemOwner = v1.owner
			
				if items[itemOwner] == nil then
					items[itemOwner] = {}
				end

				table.insert(items[itemOwner], {
					name  = itemName,
					count = itemCount,
					label = Items[itemName]
				})
			end

			for k2, v2 in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k2, v2)
				table.insert(Inventories[name], addonInventory)
			end
		else
			local items = {}

			for k2, v2 in pairs(result2) do
				table.insert(items, {
					name  = v2.name,
					count = v2.count,
					label = Items[v2.name]
				})
			end

			local addonInventory = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory
		end
	end
end)

local function GetInventory(name, owner)
	for k, v in pairs(Inventories[name]) do
		if v.owner == owner then
			return v
		end
	end
end

local function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('esx_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner))
end)

AddEventHandler('esx_addoninventory:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonInventories = {}

	for k, v in pairs(InventoriesIndex) do
		local name = v
		local inventory = GetInventory(name, xPlayer.identifier)

		if inventory == nil then
			inventory = CreateAddonInventory(name, xPlayer.identifier, {})
			table.insert(Inventories[name], inventory)
		end

		table.insert(addonInventories, inventory)
	end

	xPlayer.set('addonInventories', addonInventories)
end)
