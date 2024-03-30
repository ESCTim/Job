ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('le:searchNotify')
AddEventHandler('le:searchNotify', function(source, target, label, text)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	TriggerClientEvent('le_core:hud:notify', target, 'info', label, text)
end)

RegisterServerEvent('le_jobpack:getStockItem')
AddEventHandler('le_jobpack:getStockItem', function(itemName, count)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local name, label = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. name, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			if ESX.PlayerCanCarryItem(playerId, itemName,count) then
				inventory.removeItem(itemName, count)
				ESX.AddPlayerInventoryItem(playerId, itemName, count, GetCurrentResourceName())
				TriggerClientEvent('le_core:hud:notify', playerId, 'success', label, 'Du hast ' .. count .. 'x ' .. inventoryItem.label .. ' aus dein Lager gelegt!')

				FrakkammerStaatLog("**Items entnommen**" ,'Der Spieler **' .. GetPlayerName(playerId) .. '** mit dem Identifier **' .. ESX.GetPlayerIdentifier(playerId) .. '** nimmt folgendes aus der **' .. name .. '** Kammer: **' ..  count ..'x** **'.. itemName ..'**.')
			else
				TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Ungültige Menge!')
			end
		else
            TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Ungültige Menge!')
		end
	end)
end)

RegisterServerEvent('le_jobpack:putStockItems')
AddEventHandler('le_jobpack:putStockItems', function(itemName, count)
	local playerId = source
	local name, label = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label
	local sourceItem = ESX.GetPlayerInventoryItem(playerId, itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. name, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			ESX.RemovePlayerInventoryItem(playerId, itemName, count, GetCurrentResourceName())
			inventory.addItem(itemName, count)
            TriggerClientEvent('le_core:hud:notify', source, 'success', label, 'Du hast ' .. count .. 'x ' .. inventoryItem.label .. ' in dein Lager gelegt!')

			FrakkammerStaatLog("**Items gelagert**" ,'Der Spieler **' .. GetPlayerName(playerId) .. '** mit dem Identifier **' .. ESX.GetPlayerIdentifier(playerId) .. '** legt folgendes in die **' .. name .. '** Kammer: **' ..  count ..'x** **'.. itemName ..'**.')
		else
            TriggerClientEvent('le_core:hud:notify', source, 'error', label, 'Ungültige Menge!')
		end
	end)
end)

RegisterServerEvent('le_jobpack:addArmoryWeapon')
AddEventHandler('le_jobpack:addArmoryWeapon', function(weaponName, ammo)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if ESX.HasPlayerWeapon(playerId, weaponName) then
		ESX.RemovePlayerWeapon(playerId, weaponName)
	
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. name, function(store)
			local weapons = store.get('weapons') or {}

			table.insert(weapons, {name = weaponName, ammo = ammo})
	
			store.set('weapons', weapons)
		end)
		FrakkammerStaatLog("**Waffe gelagert**",'Der Spieler **' .. GetPlayerName(playerId) .. '** mit dem Identifier **' .. ESX.GetPlayerIdentifier(playerId) .. '** legt folgendes in die **' .. name .. '** Kammer: 1x **'.. weaponName ..'**.')
	end
end)

RegisterServerEvent('le_jobpack:removeArmoryWeapon')
AddEventHandler('le_jobpack:removeArmoryWeapon', function(weaponName, ammo)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if not ESX.HasPlayerWeapon(playerId, weaponName) then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. name, function(store)
			local weapons = store.get('weapons') or {}
	
			local foundWeapon = false
		
			for i=1, #weapons, 1 do
				if weapons[i].name == weaponName and weapons[i].ammo == ammo then
					ESX.AddPlayerWeapon(playerId, weaponName, ammo)

					table.remove(weapons, i)
					foundWeapon = true
					break
				end
			end
	
			store.set('weapons', weapons)
		end)
		FrakkammerStaatLog("**Waffe entnommen**" ,'Der Spieler **' .. GetPlayerName(playerId) .. '** mit dem Identifier **' .. ESX.GetPlayerIdentifier(playerId) .. '** nimmt folgendes aus der **' .. name .. '** Kammer: 1x **'.. weaponName ..'**.')
	end
end)

function FrakkammerStaatLog(titel, message)
	local embed = {
		  {
			  ["color"] = '15158332',
			  ["title"] = titel,
			  ["description"] = message,
		  }
	  }  
	PerformHttpRequest('https://discord.com/api/webhooks/1096807822928400454/YURfg5GmzdYGZJ05Zg8sW3GqUscQCTiB2ZoPdsdsr5zpxDx0TMngx9PpjEfVw9K1FjjF', function(err, text, headers) end, 'POST', json.encode({username = 'VEHICLE-SHOP', embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('le_jobpack:buyItem')
AddEventHandler('le_jobpack:buyItem', function(itemName, itemCount)
	local playerId = source
	local name, label, grade_name = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label, ESX.GetPlayerJob(playerId).grade_name
	local price = getItemPriceFromName(name, grade_name, itemName) * itemCount
	if price then
		if ESX.GetPlayerMoney(playerId) >= price then
			if ESX.PlayerCanCarryItem(playerId, itemName, itemCount) then
				ESX.RemovePlayerMoney(playerId, price, GetCurrentResourceName())
				ESX.AddPlayerInventoryItem(playerId, itemName, itemCount, GetCurrentResourceName())
			else
				TriggerClientEvent('le_core:hud:notify', source, 'error', label, 'Dein Inventar ist voll!')
			end
		else
			TriggerClientEvent('le_core:hud:notify', source, 'error', label, 'Nicht genug Geld dabei!')
		end
	end
end)

RegisterServerEvent('le_jobpack:buyWeapon')
AddEventHandler('le_jobpack:buyWeapon', function(weaponName, weaponType, componentNumber)
	local playerId = source
	local name, label, grade_name = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label, ESX.GetPlayerJob(playerId).grade_name
	local authorizedWeapons, selectedWeapon = Config.Jobs[name].AuthorizedWeapons[grade_name]

	for k, v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if selectedWeapon then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..name, function(account)

			if weaponType == 1 then
				if not ESX.HasPlayerWeapon(playerId, weaponName) then
					if account.money >= selectedWeapon.price then
						account.removeMoney(selectedWeapon.price)
						ESX.AddPlayerWeapon(playerId, weaponName, 250)

					else
						TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Nicht genug Geld dabei!')
					end
				else
					TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Du hast diese Waffe bereits!')
				end
			elseif weaponType == 2 then
				local price = selectedWeapon.components[componentNumber]
				local weaponNum, weapon = ESX.GetWeapon(weaponName)
				local component = weapon.components[componentNumber]

				if component then
					if account.money >= price then
						if not ESX.HasPlayerWeaponComponent(playerId, weaponName, component.name) then
							account.removeMoney(price)
							ESX.AddPlayerWeaponComponent(playerId, weaponName, component.name)

						else
							TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Du hast diesen Waffe Component schon!')
						end
					else
						TriggerClientEvent('le_core:hud:notify', playerId, 'error', label, 'Nicht genug Geld dabei!')
					end
				end
			end
		end)
	end
end)

function haveAccessTo(action, job, id)
	-- if id then
	-- 	local myCount = ESX.GetPlayerInventoryItem(id, 'kabelbinder').count
	-- 	if myCount > 0 then
	-- 		return true
	-- 	else
	-- 		return false
	-- 	end
	-- end
	local options = Config.Jobs[job].ActionMenu.zivi

	if action == 'handcuff' then
		if options.handcuff then
			return true
		end
	elseif action == 'search' then
		if options.search then
			return true
		end
	elseif action == 'drag' then
		if options.drag then
			return true
		end
	elseif action == 'putInVehicle' then
		if options.putInVehicle then
			return true
		end
	elseif action == 'putOutVehicle' then
		if options.putOutVehicle then
			return true
		end
	end
	
	return false
end

-- general f6

RegisterServerEvent('le_jobpack:confiscatePlayerItem')
AddEventHandler('le_jobpack:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name
	
	if haveAccessTo('search', name, source) then
		if GetPlayerName(target) ~= nil then
			if itemType == 'item_standard' then
				local targetItem = ESX.GetPlayerInventoryItem(target, itemName)
				local sourceItem = ESX.GetPlayerInventoryItem(playerId, itemName)
	
				if targetItem.count > 0 and targetItem.count <= amount then
					ESX.RemovePlayerInventoryItem(target, itemName, amount, GetCurrentResourceName())
					ESX.AddPlayerInventoryItem(playerId, itemName, amount, GetCurrentResourceName())
					TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Du konfiszierst ' .. amount .. 'x ' .. sourceItem.label .. ' von ' .. GetPlayerName(target) .. '')
					TriggerClientEvent('le_core:hud:notify', target, 'info', 'Information', '' .. amount .. 'x ' .. sourceItem.label .. ' wurde konfisziert von ' .. GetPlayerName(playerId) .. '')
				else
					TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Ungültige Menge')
				end

				if itemName == 'phone' then 
					exports.saltychat:RemovePlayerRadioChannel(target, '')
				end
			elseif itemType == 'item_account' then
				if ESX.GetPlayerAccount(playerId, itemName).money >= amount then
					ESX.RemovePlayerAccountMoney(target, itemName, amount, GetCurrentResourceName())
					TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Du konfiszierst $' .. amount .. ' (' .. itemName .. ') von ' .. GetPlayerName(target) .. '')
					TriggerClientEvent('le_core:hud:notify', target,  'info', 'Information', '$' .. amount .. ' (' .. itemName .. ') wurde konfisziert von' .. GetPlayerName(playerId) .. '')
				else
					TriggerClientEvent('le_core:hud:notify', playerId, 'Ungültige Menge')
				end
			elseif itemType == 'item_weapon' then
				if ESX.HasPlayerWeapon(target, itemName) then
					ESX.RemovePlayerWeapon(target, itemName, 1)
					ESX.AddPlayerWeapon(playerId, itemName, 1)
					TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Du konfiszierst $' .. amount .. ' (' .. itemName .. ') von ' .. GetPlayerName(target) .. '')
					TriggerClientEvent('le_core:hud:notify', target,  'info', 'Information', '$' .. amount .. ' (' .. itemName .. ') wurde konfisziert von' .. GetPlayerName(playerId) .. '')
				else
					TriggerClientEvent('le_core:hud:notify', playerId, 'Du hast diese Waffe bereits')
				end
			end
		end
	end
end)

RegisterServerEvent('le_jobpack:handcuff')
AddEventHandler('le_jobpack:handcuff', function(target)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if target == -1 then
		return
	end

	if haveAccessTo('handcuff', name) then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:handcuff', target)
		end
	end
end)

RegisterServerEvent('le_jobpack:drag')
AddEventHandler('le_jobpack:drag', function(target)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if target == -1 then
		return
	end

	if haveAccessTo('drag', name) then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:drag', target, playerId)
		end
	end
end)

RegisterServerEvent('le_jobpack:putInVehicle')
AddEventHandler('le_jobpack:putInVehicle', function(target)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if target == -1 then
		return
	end

	if haveAccessTo('putInVehicle', name) then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:putInVehicle', target)
		end
	end
end)

RegisterServerEvent('le_jobpack:putOutVehicle')
AddEventHandler('le_jobpack:putOutVehicle', function(target)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if target == -1 then
		return
	end

	if haveAccessTo('putOutVehicle', name) then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:putOutVehicle', target)
		end
	end
end)

-- ambulance job f6

RegisterServerEvent('le_jobpack:ambulance:putInVehicle')
AddEventHandler('le_jobpack:ambulance:putInVehicle', function(target)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	if target == -1 then
		return
	end

	local options = Config.Jobs[name].ActionMenu.ems_menu

	if options.putInVehicle then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:ambulance:putInVehicle', target)
		end
	end
end)

RegisterServerEvent('le_jobpack:removeItem')
AddEventHandler('le_jobpack:removeItem', function(itemName)
	local playerId = source
	local name = ESX.GetPlayerJob(playerId).name

	local options = Config.Jobs[name].ActionMenu.ems_menu

	if options.revive or options.small or options.big then
		ESX.RemovePlayerInventoryItem(playerId, itemName, 1, GetCurrentResourceName())

		if itemName == 'bandage' then
			TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Du hast ein Verband verwendet!')
		elseif itemName == 'medikit' then
			TriggerClientEvent('le_core:hud:notify', playerId, 'info', 'Information', 'Du hast ein Medikit verwendet!')
		end
	end
end)

RegisterServerEvent('le_jobpack:heal')
AddEventHandler('le_jobpack:heal', function(target, type)
	local source = source
	local name = ESX.GetPlayerJob(source).name

	if target == -1 then
		return
	end

	local options = Config.Jobs[name].ActionMenu.ems_menu

	if options.small or options.big then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_jobpack:heal', target, type)
		end
	end
end)

RegisterServerEvent('le_jobpack:revive')
AddEventHandler('le_jobpack:revive', function(target)
	local playerId = source
	local name, label, grade_name = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label, ESX.GetPlayerJob(playerId).grade_name

	local options = Config.Jobs[name].ActionMenu.ems_menu
	
	
	if options.revive or name == 'lspd' and grade_name == 'boss' or name == 'doj' and grade_name == 'boss' then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Du hast ' .. GetPlayerName(target) .. ' wiederbelebt und dabei $400 erhalten!')
			exports['le_core']:doubleLog(source, target, 'Revive - log', GetPlayerName(source) .. ' hat ' .. GetPlayerName(target)  .. ' revived', 'https://discord.com/api/webhooks/1113859259009089656/2XHnGh4c7gdz8XUa5IJEb5qlyvK-WPlq5hBN4mqb1LPB_zCoeb2tXqf8Lf6W2vxz11ew')

			TriggerClientEvent('le_jobpack:revive', target)

			ESX.AddPlayerMoney(playerId, 400, GetCurrentResourceName())
		else
			TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Dieser Spieler ist nicht länger online!')
		end
	end
end)

RegisterServerEvent('le_jobpack:revive1')
AddEventHandler('le_jobpack:revive1', function(target)
	local playerId = source
	local name, label, grade_name = ESX.GetPlayerJob(playerId).name, ESX.GetPlayerJob(playerId).label, ESX.GetPlayerJob(playerId).grade_name
	
	if name == 'bar' then
		if GetPlayerName(target) ~= nil then
			TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Du hast ' .. GetPlayerName(target) .. ' wiederbelebt und dabei $1000 erhalten!')
			exports['le_core']:doubleLog(source, target, 'Revive - log', GetPlayerName(source) .. ' hat ' .. GetPlayerName(target)  .. ' revived', 'https://discord.com/api/webhooks/1113859259009089656/2XHnGh4c7gdz8XUa5IJEb5qlyvK-WPlq5hBN4mqb1LPB_zCoeb2tXqf8Lf6W2vxz11ew')
			TriggerClientEvent('le_jobpack:revive', target)
		else
			TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Dieser Spieler ist nicht länger online!')
		end
	end
end)

RegisterServerEvent('le_jobpack:setDeathStatus')
AddEventHandler('le_jobpack:setDeathStatus', function(isDead)
	local source = source

	if GetPlayerName(source) ~= nil then
		if type(isDead) == 'boolean' then
			MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
				['@identifier'] = ESX.GetPlayerIdentifier(source),
				['@isDead'] = isDead
			})
		end
	end

	if isDead then 
		exports.saltychat:SetPlayerAlive(source, false)
	elseif not isDead then 
		exports.saltychat:SetPlayerAlive(source, true)
	end
end)

RegisterNetEvent("le_jobpack:declareDead")
AddEventHandler('le_jobpack:declareDead', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "lsmd" then
		TriggerClientEvent('le_core:hud:notify', source, "info", "Todeserklärung", 'Du hast jemanden für Tot erklärt.')
		TriggerClientEvent('le_core:hud:notify', target, "info", "Todeserklärung", 'Du wurdest soeben für Tot erklärt.')

		TriggerClientEvent('le_jobpack:killPlayer', target)
	else
		print(xPlayer.identifier .. " hat versucht, jemanden für tot zu erklären, obwohl er kein Medic ist (achtung: cheater)")
	end
end)

ESX.RegisterServerCallback('le_jobpack:checkDim', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(GetPlayerRoutingBucket(source))
end)

RegisterServerEvent('le_jobpack:revivePlayer')
AddEventHandler('le_jobpack:revivePlayer', function(reviveTimer, isDead, isDead, anotherPlayer, nogga, ooga_booga, name)
	local playerId = source

	if GetPlayerName(source) ~= nil then
		reviveTimer = tonumber(reviveTimer)

		if reviveTimer ~= nil then
			ESX.SetPlayerReviveTimer(playerId, reviveTimer)
		end
	end
end)

RegisterCommand('revive', function(source, args, rawCommand)
	local source = source

	if ESX.GetPlayerGroup(source) ~= 'user' and ESX.GetPlayerGroup(source) ~= 'analyst' then
		if args[1] == 'me' then
			TriggerClientEvent('le_jobpack:revive', source, true, false)
			exports['le_core']:log(source, 'Self-Revive - log', GetPlayerName(source) .. ' hat sich selber per Command revived', 'https://discord.com/api/webhooks/1159648781336317972/N5rr0ZWJknj2oR8Lq6uwXgCHtkgK6IHwFw4oKsbE4BD7BZ31ZOzL-wZPq2AwTEqy5VDv')
		else 
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					if GetPlayerName(source) == GetPlayerName(args[1]) then 
						TriggerClientEvent('le_jobpack:revive', source, true, false)
						exports['le_core']:log(source, 'Self-Revive - log', GetPlayerName(source) .. ' hat sich selber per Command revived', 'https://discord.com/api/webhooks/1159648781336317972/N5rr0ZWJknj2oR8Lq6uwXgCHtkgK6IHwFw4oKsbE4BD7BZ31ZOzL-wZPq2AwTEqy5VDv')
					else
						TriggerClientEvent('le_jobpack:revive', tonumber(args[1]), true, false)
						exports['le_core']:doubleLog(source, args[1], 'Revive - log', GetPlayerName(source) .. ' hat ' .. GetPlayerName(args[1])  .. ' per Command revived', 'https://discord.com/api/webhooks/1089539413257764874/NBkPWrh7nvoZT0s374UaFqlXj4xNIxqmZcmJLKJxkTLg9BcCq68C-MSqz_dtha_3SEDN')
				
					end
				end
			else
				TriggerClientEvent('le_jobpack:revive', source, true, false)
				exports['le_core']:log(source, 'Self-Revive - log', GetPlayerName(source) .. ' hat sich selber per Command revived', 'https://discord.com/api/webhooks/1159648781336317972/N5rr0ZWJknj2oR8Lq6uwXgCHtkgK6IHwFw4oKsbE4BD7BZ31ZOzL-wZPq2AwTEqy5VDv')
			end
		end
	end
end)

RegisterCommand('reviveall', function(source, args, rawCommand)
	local source = source
	local group = ESX.GetPlayerGroup(source)

	if ESX.GetPlayerGroup(source) ~= 'user' and ESX.GetPlayerGroup(source) ~= 'analyst' then
		if args[1] then
			local xPlayers = exports['le_core']:GetPlayersFix()
			local count = 0

			for k, v in pairs(xPlayers) do
				local distance = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(v.playerId)))
				
				if distance < tonumber(args[1]) then
					count = count + 1
					TriggerClientEvent('le_jobpack:revive', v.playerId, true, false)
				end
			end

			exports['le_core']:log(source, 'Revive - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' hat ' .. count .. ' Spieler in einem radius von ' .. args[1] .. ' revived', 'https://discord.com/api/webhooks/1089539413257764874/NBkPWrh7nvoZT0s374UaFqlXj4xNIxqmZcmJLKJxkTLg9BcCq68C-MSqz_dtha_3SEDN')

			TriggerClientEvent('le_core:hud:notify', source, 'info', 'Revive', 'Du hast ' .. count .. ' leute in einem radius von ' .. args[1] .. ' revived')
		end
	end
end)

RegisterCommand('reuseweapon', function(source, args, rawCommand)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == 'manage' or xPlayer.getGroup() == 'pl' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'dev' or xPlayer.getGroup() == 'developer' or xPlayer.getGroup() == 'support' or xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'cardev' or xPlayer.getGroup() == 'fm' or xPlayer.getGroup() == 'cm' then
		if args[1] == 'me' then
			TriggerClientEvent('le_jobpack:resettimer', source)
			exports['le_core']:log(source, 'Reuseweapon - log', GetPlayerName(source) .. ' hat Weapon Timer resettet', 'https://discord.com/api/webhooks/1117247380887179376/iMtMcCbcIDQvdO7rIQtLTUpRuyxGQotpMz0nzyenu66fDfmywEoVNIrU9gKHC9MJ_Grd')
		else 
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent('le_jobpack:resettimer', tonumber(args[1]))
					exports['le_core']:doubleLog(source, args[1], 'Reuseweapon - log', GetPlayerName(source) .. ' hat ' .. GetPlayerName(args[1])  .. ' den Weapon Timer resettet', 'https://discord.com/api/webhooks/1117247380887179376/iMtMcCbcIDQvdO7rIQtLTUpRuyxGQotpMz0nzyenu66fDfmywEoVNIrU9gKHC9MJ_Grd')
				end
			else
				TriggerClientEvent('le_jobpack:resettimer', source)
				exports['le_core']:log(source, 'Reuseweapon - log', GetPlayerName(source) .. ' hat Weapon Timer resettet', 'https://discord.com/api/webhooks/1117247380887179376/iMtMcCbcIDQvdO7rIQtLTUpRuyxGQotpMz0nzyenu66fDfmywEoVNIrU9gKHC9MJ_Grd')
			end
		end
	end
end)

function getItemPriceFromName(job, jobGrade, itemName)
	local items = Config.Jobs[job].AuthorizedItems[jobGrade]

	for k, v in ipairs(items) do
		if v.item == itemName then
			return v.price
		end	
	end

	return false
end

function getPriceFromHash(job, vehicleHash, jobGrade, type)
	local vehicles = Config.Jobs[job].AuthorizedVehicles[type][jobGrade]

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

local playersHealing = {}

local huanPlayers = {}
local stabilisiert = {}

RegisterNetEvent('le_fraktion:stabil', function(target)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll("SELECT medicschein FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.getIdentifier()
	}, function(result)
		if result[1] and os.time() < result[1].medicschein + (60 * 60 * 24 * 30) then
			if stabilisiert[target] == nil then
				if GetEntityHealth(GetPlayerPed(target)) <= 0 then
					stabilisiert[target] = true
					exports.saltychat:SetPlayerAlive(target, true) -- reden stabilisiert
					TriggerClientEvent("le_core:hud:notify", xPlayer.source, 'info', 'Information', "Du hast erfolgreich jemanden stabilisiert")
					TriggerClientEvent("le_core:hud:notify", target, 'info', 'Information', "Du wurdest stabilisiert und kannst wieder reden")
					TriggerClientEvent("le_jobpack:mehr", target)
				else
					TriggerClientEvent("le_core:hud:notify", xPlayer.source, 'info', 'Information', "Diese Person ist nicht tot")
				end
			else
				TriggerClientEvent("le_core:hud:notify", xPlayer.source, 'info', 'Information', "Diese Person wurde bereits stabilisiert")
			end
		else
			TriggerClientEvent("le_core:hud:notify", xPlayer.source, 'info', 'Information', "Du hast keinen Medicschein")
		end
	end)
end)

local minGradeAmbulance = 11

exports("hasMedicSchein", function(source)
	local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local res
    MySQL.Async.fetchAll("SELECT medicschein FROM users WHERE identifier = @identifier", { ['@identifier'] = xPlayer.getIdentifier() }, function(result)
        if result[1] and os.time() > result[1].medicschein + (60 * 60 * 24 * 60) then
            res = false
        else
            res = true
        end
    end)

    while res == nil do
        Wait(1)
    end
    
	return res
end)

RegisterNetEvent("ambulance:giveMedicSchein", function(target)
	local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if ESX.GetPlayerJob(playerId).name == "lsmd" and ESX.GetPlayerJob(playerId).grade >= minGradeAmbulance then
        local tPlayer = ESX.GetPlayerFromId(target)
        MySQL.Async.execute("UPDATE users SET medicschein = @medicschein WHERE identifier = @identifier",
            { ['medicschein'] = os.time(), ['identifier'] = tPlayer.getIdentifier() })
		TriggerClientEvent('le_core:hud:notify', target, "info", "MEDICSCHEIN", "Du hast soeben von " .. xPlayer.getName() .. " einen Medicschein ausgestellt bekommen")
		TriggerClientEvent('le_core:hud:notify', xPlayer.source, "info", "MEDICSCHEIN", "Du hast einen Medicschein an " .. tPlayer.getName() .. " ausgestellt.")
	else
        print("[BaseScript] " .. xPlayer.getIdentifier() .. " is most likely cheating. (ambulance:giveMedicSchein)")
    end
end)

ESX.RegisterUsableItem('medikit', function(source)
	if GetVehiclePedIsIn(GetPlayerPed(source)) == 0 then
		if not playersHealing[source] then
			ESX.RemovePlayerInventoryItem(source, 'medikit', 1, GetCurrentResourceName())
	
			playersHealing[source] = true
			TriggerClientEvent('le_jobpack:useItem', source, 'medikit')
	
			Wait(7500)
			playersHealing[source] = nil
		end
	else
		TriggerClientEvent('le_core:hud:notify', source, 'error', 'Medikit', 'Kannst du in keinem Fahrzeug benutzen!')
	end
end)

ESX.RegisterUsableItem('bandage', function(source)

	if not playersHealing[source] then
		ESX.RemovePlayerInventoryItem(source, 'bandage', 1, GetCurrentResourceName())

		playersHealing[source] = true
		TriggerClientEvent('le_jobpack:useItem', source, 'bandage')

		Wait(3500)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('le_jobpack:getArmoryWeapons', function(source, cb)
	local name = ESX.GetPlayerJob(source).name
    
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. name, function(store)
		local weapons = store.get('weapons') or {}

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('le_jobpack:getStockItems', function(source, cb)
	local name = ESX.GetPlayerJob(source).name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. name, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('le_jobpack:getPlayerInventory', function(source, cb)
	local items = ESX.GetPlayerInventory(source)


	cb({ items = items })
end)

ESX.RegisterServerCallback('le_jobpack:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = { plate = plate }

		if result[1] then
			local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)

			-- is the owner online?
			if xPlayer then
				retrivedInfo.owner = xPlayer.getRPName()
				cb(retrivedInfo)
			else
				MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
					['@identifier'] = result[1].owner
				}, function(result2)
					if result2[1] then
						if Config.EnableESXIdentity then
							retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
						else
							retrivedInfo.owner = result2[1].name
						end

						cb(retrivedInfo)
					else
						cb(retrivedInfo)
					end
				end)
			end
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('le_jobpack:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				cb(('%s %s'):format(result2[1].firstname, result2[1].lastname), true)
			end)
		else
			cb('Unknown', false)
		end
	end)
end)

ESX.RegisterServerCallback('le_jobpack:getOtherPlayerData', function(source, cb, target, license)


	if GetPlayerName(target) ~= nil then
		local data = {}
		local data = {
			name = ESX.GetPlayerRPName(target),
			job = ESX.GetPlayerJob(target).label,
			grade = ESX.GetPlayerJob(target).grade_label,
			inventory = ESX.GetPlayerInventory(target),
			accounts = ESX.GetPlayerAccounts(target),
			weapons = ESX.GetPlayerLoadout(target)
		}

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	end
end)

ESX.RegisterServerCallback('le_jobpack:buyJobVehicle', function(source, cb, vehicleProps, type)
	local playerId = source
	local name, label, grade_name = ESX.GetPlayerJob(source).name, ESX.GetPlayerJob(source).label, ESX.GetPlayerJob(source).grade_name
	local price = getPriceFromHash(name, vehicleProps.model, grade_name, type)

	if type == 'helicopter' then
		type = 'heli'
	end

	if price == 0 then
		cb(false)
	else
		if ESX.GetPlayerMoney(source) >= price then
			ESX.RemovePlayerMoney(source, price, GetCurrentResourceName())

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = ESX.GetPlayerIdentifier(source),
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = name,
				['@stored'] = true
			}, function (rowsChanged)
				TriggerClientEvent('le_core:garage:addVehicle', playerId, json.decode('{"plate":"' .. vehicleProps.plate .. '", "model":' .. GetHashKey(vehicleProps.model) .. '}'), true, vehicleProps.plate, 'Fahrzeug', type, name)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('le_jobpack:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local name = ESX.GetPlayerJob(source).name
	local foundPlate, foundNum

	for k, v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = ESX.GetPlayerIdentifier(source),
			['@plate'] = v.plate,
			['@job'] = name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = ESX.GetPlayerIdentifier(source),
			['@plate'] = foundPlate,
			['@job'] = name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

ESX.RegisterServerCallback('le_jobpack:addLicense', function(source, cb, target, license)
	local name, label, grade_name = ESX.GetPlayerJob(source).name, ESX.GetPlayerJob(source).label, ESX.GetPlayerJob(source).grade_name

	TriggerEvent('esx_license:checkLicense', target, license, function(hasLicense)
		if not hasLicense then
			TriggerEvent('esx_license:addLicense', target, license, function(done)
				if license == 'drive' then
					log('**' .. GetPlayerName(source) .. '** hat den Autoführerschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Führerschein', 'Dein Autoführerschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				elseif license == 'drive_bike' then
					log('**' .. GetPlayerName(source) .. '** hat den Motorradführerschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Führerschein', 'Dein Motorradführerschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				elseif license == 'drive_boat' then
					log('**' .. GetPlayerName(source) .. '** hat denn Bootsführerschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Führerschein', 'Dein Bootsführerschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				elseif license == 'drive_plane' then
					log('**' .. GetPlayerName(source) .. '** hat den Flugzeugführerschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Führerschein', 'Dein Flugzeugführerschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				elseif license == 'drive_heli' then
					log('**' .. GetPlayerName(source) .. '** hat denn Heliführerschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Führerschein', 'Dein Heliführerschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				elseif license == 'weapon' then
					log('**' .. GetPlayerName(source) .. '** hat denn Waffenschein für **' .. GetPlayerName(target) .. '** ausgestellt!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'success', 'Waffenschein', 'Dein Waffenschein wurde von ' .. GetPlayerName(source) .. ' ausgestellt!')
				end

				cb(ESX.GetPlayerRPName(target), true)
			end)
		else
			cb(ESX.GetPlayerRPName(target), false)
		end
	end)
end)

ESX.RegisterServerCallback('le_jobpack:removeLicense', function(source, cb, target, license)
	local name, label, grade_name = ESX.GetPlayerJob(source).name, ESX.GetPlayerJob(source).label, ESX.GetPlayerJob(source).grade_name

	TriggerEvent('esx_license:checkLicense', target, license, function(hasLicense)
		if hasLicense then
			TriggerEvent('esx_license:removeLicense', target, license, function(done)
				if license == 'drive' then
					log('**' .. GetPlayerName(source) .. '** hat denn Autoführerschein von **' .. GetPlayerName(target) .. '** abgenommen!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'error', 'Führerschein', 'Dein Autoführerschein wurde von ' .. GetPlayerName(source) .. ' abgenommen!')
				elseif license == 'weapon' then
					log('**' .. GetPlayerName(source) .. '** hat denn Waffenschein von **' .. GetPlayerName(target) .. '** abgenommen!\n```' .. GetAllIdentifiers(source) .. '```')
					TriggerClientEvent('le_core:hud:notify', target, 'error', 'Waffenschein', 'Dein Waffenschein wurde von ' .. GetPlayerName(source) .. ' abgenommen!')
				end

				cb(ESX.GetPlayerRPName(target), true)
			end)
		else
			cb(ESX.GetPlayerRPName(target), false)
		end
	end)
end)

ESX.RegisterServerCallback('le_jobpack:getItemAmount', function(source, cb, item)
	local quantity = ESX.GetPlayerInventoryItem(source, item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('le_jobpack:getDeathStatus', function(source, cb)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = ESX.GetPlayerIdentifier(source)
	}, function(isDead)
		if isDead then

			print(('[^2Server Name^7] "%s" ^1hat sicht TOT ausgeloggt.'):format(source))
		end

		cb(isDead)
	end)
end)

ESX.RegisterServerCallback('le_jobpack:removeItemsAfterRPDeath', function(source, cb)
	if ESX.GetPlayerMoney(source) > 0 then
		ESX.RemovePlayerMoney(source, ESX.GetPlayerMoney(source), GetCurrentResourceName())
	end

	if ESX.GetPlayerAccount(source, 'black_money').money >= 0 then
		ESX.RemovePlayerAccountMoney(source, 'black_money', ESX.GetPlayerAccount(source, 'black_money').money)
	end

	for k, v in pairs(ESX.GetPlayerInventory(source)) do
		if v.count > 0 then
			if not CheckIfItemCanRemove(v.name) then
				ESX.SetPlayerInventoryItem(source, v.name, 0, GetCurrentResourceName())
			end
		end
	end

	for k, v in pairs(ESX.GetPlayerLoadout(source)) do
		ESX.RemovePlayerWeapon(source, v.name, v.ammo, 'dead')
	end

	cb()
end)

RegisterNetEvent('le_jobpack:maskoff')
AddEventHandler('le_jobpack:maskoff', function(target)
	local _source = source
	if target == -1 then
		print(_source .. ' hat versucht alle Leute zu entmaskieren!')
		return
	end
    TriggerClientEvent('dpclothing:toggleMask', target)
end)

RegisterNetEvent('le_jobpack:hatoff')
AddEventHandler('le_jobpack:hatoff', function(target)
	local _source = source
	if target == -1 then
		print(_source .. ' hat versucht alle Leute zu entmaskieren!')
		return
	end
    TriggerClientEvent('dpclothing:toggleHat', target)
end)

RegisterNetEvent('le_jobpack:glovesoff')
AddEventHandler('le_jobpack:glovesoff', function(target)
	local _source = source
	if target == -1 then
		print(_source .. ' hat versucht alle Leute zu entmaskieren!')
		return
	end
    TriggerClientEvent('dpclothing:toggleGloves', target)
end)

function CheckIfItemCanRemove(Item)
	for k, v in pairs(Config.WhitelistMedicItems) do
		if v == Item then
			return true	
		end
	end

	return false
end

function GetAllIdentifiers(src)
    local string = ""

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            string = string .. "\n" .. v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            string = string .. "\n" .. v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            string = string .. "\n" .. v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            string = string .. "\n" .. v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            string = string .. "\n" .. v
        elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
            string = string .. "\n" .. v
        end
    end

    return string
end

function log(message)
    local embed = {
        {
            ["color"] = "3447003",
            ["title"] = "**Lizenz Entziehen**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Lizenz Entziehen - Server Name - ".. os.date("%d.%m.%y") .. " - " .. os.date("%X") .. " Uhr",
                ["icon_url"] = "https://media.discordapp.net/attachments/1065547379723472916/1094010413999456357/Komp_2.gif",
            },
            ["author"] = {
                ["name"] = "Server Name",
                ["url"] = "https://discord.gg/xxx",
                ["icon_url"] = "https://media.discordapp.net/attachments/1065547379723472916/1094010413999456357/Komp_2.gif",
            }
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/1096841566338949322/YHMT7OmkvFXSYhAeHzdAJOWBB6GqX0EZG0BqRbcc8g_dQXD3rGfaPRVQDZW5C3qzfl3i", function(err, text, headers) end, 'POST', json.encode({username = "Server Name", embeds = embed, avatar_url = "https://tobias.isfucking.pro/9wZbYe.png"}), { ['Content-Type'] = 'application/json' })
end

--

-- Returns all ranks of jobName

function retrieveJobRanks(jobName, cb)
    MySQL.Async.fetchAll('SELECT id, grade, name, label, salary FROM `job_grades` WHERE job_name=@jobName ORDER BY grade ASC', {['@jobName'] = jobName}, function(ranks)
        cb(ranks)
    end)
end

function retrieveJobsData(cb)
    MySQL.Async.fetchAll('SELECT * FROM jobs ORDER BY label', {}, function(jobs)
        if(jobs) then
            local jobsData = {}
            local completed = 0

            for k, job in pairs(jobs) do
                jobsData[job.name] = {
                    name = job.name, 
                    label = job.label,
                    enableBilling = job.enable_billing,
                    canRob = job.can_rob,
                    canHandcuff = job.can_handcuff,
                    whitelisted = job.whitelisted,
                    ranks = {}
                }

                retrieveJobRanks(job.name, function(ranks)
                    if(ranks) then
                        jobsData[job.name].ranks = ranks

                        completed = completed + 1

                        if(completed >= #jobs) then
                            cb(jobsData)
                        end
                    end
                end)
            end
        else
            cb(false)
        end
    end)
end

function registerSocieties()
    retrieveJobsData(function(jobs)

        -- print()
        for jobName, data in pairs(jobs) do
            createSociety(jobName, data.label)

            local msg = "^6[%s]^7 Creating society ^5%s^7 (id: ^5%s^7) with ^5%d^7 grades"
                    
            print(string.format(msg, GetCurrentResourceName(), data.label, data.name, #data.ranks))
        end
        -- print()
    end)
end

function createSociety(jobName, jobLabel)
    local societyName = "society_" .. jobName
    
    MySQL.Async.fetchScalar('SELECT shared FROM addon_account WHERE name=@societyName', {
        ['@societyName'] = societyName
    }, function(isShared)
        if(isShared == 1) then
            TriggerEvent('le_core:society:registerSociety', jobName, jobLabel, 'society_' .. jobName, 'society_' .. jobName, 'society_' .. jobName, {type = 'public'})
            
            local msg = "^6[%s]^7 Registered ^5%s^7 in 'le_core'"
                    
            print(string.format(msg, GetCurrentResourceName(), societyName))
        end
    end)

    MySQL.Async.execute('INSERT IGNORE INTO `addon_account`(name, label, shared) VALUES (@jobName, @jobLabel, 1)', {
        ['@jobName'] = societyName,
        ['@jobLabel'] = jobLabel
    }, function(affectedRows)
        if(affectedRows > 0) then
            local msg = "^6[%s]^7 Created ^5%s^7 in ^8'addon_account'^7"
            print(string.format(msg, GetCurrentResourceName(), societyName))

            MySQL.Async.fetchAll('SELECT account_name FROM addon_account_data WHERE account_name=@societyName', {
                ['@societyName'] = societyName
            }, function(results)
                if(#results == 0) then
                    MySQL.Async.execute('INSERT IGNORE INTO `addon_account_data`(account_name, money, owner) VALUES (@jobName, 0, NULL)', {
                        ['@jobName'] = societyName
                    }, function(affectedRows)
                        if(affectedRows > 0) then
                            local msg = "^6[%s]^7 Created ^5%s^7 in ^8'addon_account_data'^7"
                                    
                            print(string.format(msg, GetCurrentResourceName(), societyName))
                        end
        
                        TriggerEvent('esx_addonaccount:refreshAccounts')
                    end)
                else
                    TriggerEvent('esx_addonaccount:refreshAccounts')
                end
            end)
        end
    end)

    MySQL.Async.execute('INSERT IGNORE INTO `datastore`(name, label, shared) VALUES (@jobName, @jobLabel, 1)', {
        ['@jobName'] = societyName,
        ['@jobLabel'] = jobLabel
    }, function(affectedRows) 
        if(affectedRows > 0) then
            local msg = "^6[%s]^7 Created ^5%s^7 in ^3'datastore'^7"
                    
            print(string.format(msg, GetCurrentResourceName(), societyName))

            MySQL.Async.fetchAll('SELECT name FROM datastore_data WHERE name=@societyName', {
                ['@societyName'] = societyName
            }, function(results)
                if(#results == 0) then
                    MySQL.Async.execute('INSERT IGNORE INTO `datastore_data`(name, owner, data) VALUES (@jobName, NULL, "{}")', {
                        ['@jobName'] = societyName
                    }, function(affectedRows)
                        if(affectedRows > 0) then
                            local msg = "^6[%s]^7 Created ^5%s^7 in ^3'datastore_data'^7"
                                    
                            print(string.format(msg, GetCurrentResourceName(), societyName))
                        end
                    end)
                end
            end)
        end
    end)

    MySQL.Async.execute('INSERT IGNORE INTO `addon_inventory`(name, label, shared) VALUES (@jobName, @jobLabel, 1)', {
        ['@jobName'] = societyName,
        ['@jobLabel'] = jobLabel
    }, function(affectedRows) 
        if(affectedRows > 0) then
            local msg = "^6[%s]^7 Created ^5%s^7 in ^2'addon_inventory'^7"
                    
            print(string.format(msg, GetCurrentResourceName(), societyName))
        end
    end)
end

MySQL.ready(function()
	registerSocieties()
end)