CreateThread(function()
	SetMapName('San Andreas')
	SetGameType('Server Name')
end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	if not ESX.Players[source] then
		onPlayerJoined(source)
	end
end)

function onPlayerJoined(playerId)
	local discordIdentifier = ''
	local identifier

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.gsub(v, "license:", "")
			break
		end
	end


	for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'discord:') then
			discordIdentifier = v
			break
		end
	end

	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			print('Double #1')
			DropPlayer(playerId, 'Du bist bereits auf dem Server!')
			ESX.SavePlayer(playerId, function()
				ESX.Players[playerId] = nil
				print('Speicher Spieler mit ID:' .. playerId)
			end)
		else
			MySQL.Async.fetchScalar('SELECT 1 FROM users WHERE identifier = @identifier', {
				['@identifier'] = identifier
			}, function(result)
				if result then
					loadESXPlayer(identifier, playerId, discordIdentifier)
				else
					MySQL.Async.execute('INSERT INTO users (identifier, name, discord) VALUES (@identifier, @name, @discord)', {
						['@identifier'] = identifier,
						['@name'] = GetPlayerName(playerId),
						['@discord'] = discordIdentifier
					}, function(rowsChanged)
						loadESXPlayer(identifier, playerId, discordIdentifier)
					end)
				end
			end)
		end
	else
		DropPlayer(playerId, 'Steam wurde nicht gefunden.')
	end
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local playerId, identifier = source
	Wait(100)

	for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

	if identifier then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)
		if xTarget then
			print('Double #2')
			deferrals.done('Du bist bereits auf dem Server!')
			ESX.SavePlayer(xTarget.source, function()
				ESX.Players[xTarget.source] = nil
				print('Speicher Spieler mit ID:' .. xTarget.source)
			end)
		else
			deferrals.done()
		end
	else
		deferrals.done('Steam wurde nicht gefunden.')
	end
end)

function loadESXPlayer(identifier, playerId, discordIdentifier)
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		loadout = {},
		playerName = GetPlayerName(playerId),
		weight = 0,
		reviveTimer = 0,
		level = 0,
		timePlay = 0,
		rpName = '',
		neu = false,
		pin = 0,
		skin = nil,
		dim = 0,
		iban = 'DE',
		jail = 0,
		job2 = {},
		job3 = {},
		sex = 'm',
		height = nil,
		dateofbirth = nil,
		personal = {},
		firstname = '',
		lastname = '',
		married = 'nix'
	}

	MySQL.Async.fetchAll('SELECT job3, job3_grade, id, married, personal, dateofbirth, height, sex, jail, iban, dim, skin, pin, neu, dienst, revivetimer, firstname, lastname, money, bank, black_money, coins, halloween, job, job_grade, `group`, loadout, position, inventory, level, timePlay, job2, job2_grade, job2_type FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local job, grade, jobObject, gradeObject = result[1].job, tostring(result[1].job_grade)
		local job3, grade3, jobObject3, gradeObject3 = result[1].job3, tostring(result[1].job3_grade)
		local foundItems, foundAccounts = {}, {}

		if result[1].money and result[1].bank then
			local accountsDB = '{"money":' .. result[1].money .. ',"bank":' .. result[1].bank .. ',"black_money":' .. result[1].black_money .. ', "coins":' .. result[1].coins .. ', "halloween":' .. result[1].halloween .. '}'

			local accounts = json.decode(accountsDB)

			for account,money in pairs(accounts) do
				foundAccounts[account] = money
			end
		end

		if result[1].neu then
			if result[1].neu == '1' then
				userData.neu = true
			elseif result[1].neu == '0' then
				userData.neu = false
			end
		else
			userData.neu = true
		end

		if result[1].skin then
			userData.skin = json.decode(result[1].skin)
		else
			userData.skin = nil
		end

		if result[1].pin then
			userData.pin = result[1].pin
		else
			userData.pin = 0
		end

		-- if result[1].id then
		-- 	ESX.PlayersUniqueIds[playerId] = result[1].id
		-- 	ESX.PlayersUniqueToIds[result[1].id] = playerId
		-- end

		if result[1].dim then
			userData.dim = result[1].dim
		else
			userData.dim = 0
		end

		if result[1].jail then
			userData.jail = result[1].jail
		else
			userData.jail = 0
		end

		if result[1].height then
			userData.height = result[1].height
		else
			userData.height = 0
		end

		if result[1].dateofbirth then
			userData.dateofbirth = result[1].dateofbirth
		else
			userData.dateofbirth = '01.01.1970'
		end

		if result[1].married then
			userData.married = result[1].married
		else
			userData.married = 'nix'
		end

		if result[1].sex then
			userData.sex = result[1].sex
		else
			userData.sex = 'm'
		end

		if result[1].iban then
			userData.iban = result[1].iban
		else
			userData.iban = createIBAN(identifier)
		end

		if result[1].personal then
			shitty = json.decode(result[1].personal)[1]

			if os.time() >= shitty.endtime then
				table.insert(userData.personal, {
					have = true,
					green = false,
					begintime = os.time(),
					endtime = os.time() + 604800
				})
			else
				table.insert(userData.personal, {
					have = true,
					green = false,
					begintime = os.time(),
					endtime = os.time() + 604800
				})
			end
		else
			table.insert(userData.personal, {
				have = true,
				green = false,
				begintime = os.time(),
				endtime = os.time() + 604800
			})
		end

		for account,label in pairs(Config.Accounts) do
			table.insert(userData.accounts, {
				name = account,
				money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
				label = label
			})
		end

		if result[1].revivetimer then
			userData.revivetimer = result[1].revivetimer
		else
			userData.revivetimer = 0
		end
			
		if result[1].firstname ~= '' and result[1].lastname ~= '' then
            userData.rpName = result[1].firstname .. " " .. result[1].lastname
			userData.firstname = result[1].firstname
			userData.lastname = result[1].lastname
		else
            userData.rpName = "Max Mustermann"
			userData.firstname = 'Max'
			userData.lastname = 'Mustermann'
		end

		if ESX.DoesJobExist(job, grade) then
			jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job, grade))
			job, grade = 'unemployed', '0'
			jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
		end

		if ESX.DoesJobExist(job3, grade3) then
			jobObject3, gradeObject3 = ESX.Jobs[job3], ESX.Jobs[job3].grades[grade3]
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid job 3 system for %s [job: %s, grade: %s]'):format(identifier, job3, grade3))
			job3, grade3 = 'unemployed', '0'
			jobObject3, gradeObject3 = ESX.Jobs[job3], ESX.Jobs[job3].grades[grade3]
		end

		userData.job.id = jobObject.id
		userData.job.name = jobObject.name
		userData.job.label = jobObject.label
		userData.job.dienst = (result[1].dienst or false)
		userData.job.legal = jobObject.legal

		userData.job.grade = tonumber(grade)
		userData.job.grade_name = gradeObject.name
		userData.job.grade_label = gradeObject.label
		userData.job.grade_salary = gradeObject.salary

		userData.job.skin_male = {}
		userData.job.skin_female = {}

		if gradeObject.skin_male then userData.job.skin_male = json.decode(gradeObject.skin_male) end
		if gradeObject.skin_female then userData.job.skin_female = json.decode(gradeObject.skin_female) end

		userData.job3.id = jobObject3.id
		userData.job3.name = jobObject3.name
		userData.job3.label = jobObject3.label
		userData.job3.dienst = (result[1].dienst or false)
		userData.job3.legal = jobObject3.legal

		userData.job3.grade = tonumber(grade3)
		userData.job3.grade_name = gradeObject3.name
		userData.job3.grade_label = gradeObject3.label
		userData.job3.grade_salary = gradeObject3.salary

		userData.job3.skin_male = {}
		userData.job3.skin_female = {}

		if gradeObject3.skin_male then userData.job3.skin_male = json.decode(gradeObject3.skin_male) end
		if gradeObject3.skin_female then userData.job3.skin_female = json.decode(gradeObject3.skin_female) end

		userData.job2.id = result[1].job2
		userData.job2.type = result[1].job2_type
		userData.job2.grade = result[1].job2_grade

		if result[1].inventory and result[1].inventory ~= '' then
			local inventory = json.decode(result[1].inventory)

			for name,count in pairs(inventory) do
				local item = ESX.Items[name]

				if item then
					foundItems[name] = count
				end
			end
		end

		for name, item in pairs(ESX.Items) do
			local count = foundItems[name] or 0
			if count > 0 then userData.weight = userData.weight + (item.weight * count) end

			table.insert(userData.inventory, {
				name = name,
				count = count,
				label = item.label,
				weight = item.weight,
				usable = ESX.UsableItemsCallbacks[name] ~= nil,
				rare = item.rare,
				canRemove = item.canRemove
			})
		end

		table.sort(userData.inventory, function(a, b)
			return a.label < b.label
		end)

		if result[1].group then
			userData.group = result[1].group
		else
			userData.group = 'user'
		end

		if result[1].loadout and result[1].loadout ~= '' then
			local loadout = json.decode(result[1].loadout)

			for name, weapon in pairs(loadout) do
				local label = ESX.GetWeaponLabel(name)

				if label then
					if not weapon.components then weapon.components = {} end
					if not weapon.tintIndex then weapon.tintIndex = 0 end

					table.insert(userData.loadout, {
						name = name,
						ammo = weapon.ammo,
                        health = weapon.health,
						label = label,
						components = weapon.components,
						tintIndex = weapon.tintIndex
					})
				end
			end
		end

		if result[1].position and result[1].position ~= '' then
			userData.coords = json.decode(result[1].position)
		else
			print('loaded')
			userData.coords = 	{x = -1537.37, y = -941.65, z = 11.57, heading = 314.41}
		end
			
		if result[1].level then
			userData.level = result[1].level
		else
			userData.level = 0
		end

		if result[1].timePlay then
			userData.timePlay = result[1].timePlay
		else
			userData.timePlay = 0
		end

		local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory, userData.weight, userData.job, userData.job2, userData.job3, userData.loadout, userData.playerName, userData.coords, userData.level, userData.timePlay, userData.rpName, userData.revivetimer, userData.neu, userData.pin, userData.skin, userData.dim, userData.iban, userData.jail, userData.dateofbirth, userData.sex, userData.height, userData.personal, userData.firstname, userData.lastname, userData.married, discordIdentifier)
		ESX.Players[playerId] = xPlayer
		TriggerEvent('esx:playerLoaded', playerId, xPlayer)
		TriggerEvent('le_core:esx:playerLoaded', playerId, xPlayer)
	
		xPlayer.triggerEvent('esx:playerLoaded', {
			accounts = xPlayer.getAccounts(),
			coords = xPlayer.getCoords(),
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			loadout = xPlayer.getLoadout(),
			maxWeight = xPlayer.getMaxWeight(),
			money = xPlayer.getMoney(),
			level = xPlayer.getLevel(),
			rpName = xPlayer.getRPName(),
			revivetimer = xPlayer.getReviveTimer(),
			neu = xPlayer.getNeu(),
			group = xPlayer.getGroup(),
			dim = xPlayer.getDim(),
			jail = xPlayer.getJail(),
			job2 = xPlayer.getJob2(),
			job3 = xPlayer.getJob3(),
			pin = xPlayer.getPin()
		})
	
		print(('[^Server Name^7] Spieler "%s^7" hat sich Verbunden. ID: %s'):format(xPlayer.getName(), playerId))
		print(('[' .. GetCurrentResourceName() .. '] [^Server Name^7] Spieler "%s^7" hat sich Verbunden. ID: %s'):format(xPlayer.getName(), playerId))
	end)
end

function createIBAN(identifier)
	identifier = string.gsub(identifier, 'steam:', '')
	local partOne = identifier:sub(1, 2)
	local partTwo = identifier:sub(3, 6)
	local partThree = identifier:sub(7, 10)
	local partFour = identifier:sub(11, 14)
	local partSix = identifier:sub(15, 15)

	local iban = 'DE' .. partOne .. ' ' .. partTwo .. ' ' .. partThree .. ' ' .. partFour .. ' ' .. partSix .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9)
	
	return string.upper(iban)
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == 'le_core' then
		Wait(250)
		local xPlayers = ESX.GetPlayers()

		for k, v in pairs(xPlayers) do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[k])

			TriggerEvent('le_core:esx:playerLoaded', xPlayer.source, xPlayer)
		end
	end
end)

local function GetAllIdentifiers(playerId)
    local string = ''

    for k, v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.find(v, 'steam') then
            string = string .. v
        elseif string.find(v, 'license') then
            stringw = string .. '\n' .. v
        elseif string.find(v, 'xbl') then
            string = string .. '\n' .. v
        elseif string.find(v, 'discord') then
            string = string .. '\n' .. v
        elseif string.find(v, 'live') then
            string = string .. '\n' .. v
        elseif string.find(v, 'fivem') then
            string = string .. '\n' .. v
        elseif string.find(v, 'ip') then
            string = string .. '\n' .. v
        end
    end

    return string
end

local function log(titel, msg, img, webhook)
    local embed = nil

    if img ~= nil then
        embed = {
            {
                ["image"] = {
                    ["url"] = img,
                },
                ["author"] = {
                    ["name"] = "Server Name",
                    ["url"] = "https://discord.gg/xxx",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/1115618229444948099/1115620511226011648/LE_Communitymanagement.gif"
                },
                ["color"] = "3447003",
                ["title"] = "**" .. titel .. "**",
                ["description"] = msg,
                ["footer"] = {
                    ["text"] = "Logs - Server Name - ".. os.date("%d.%m.%y") .. " - " .. os.date("%X") .. " Uhr",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/1115618229444948099/1115620511226011648/LE_Communitymanagement.gif"
                },
            }
        }
    else
        embed = {
            {
                ["author"] = {
                    ["name"] = "Server Name",
                    ["url"] = "https://discord.gg/xxx",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/1115618229444948099/1115620511226011648/LE_Communitymanagement.gif"
                },
                ["color"] = "3447003",
                ["title"] = "**" .. titel .. "**",
                ["description"] = msg,
                ["footer"] = {
                    ["text"] = "Logs - Server Name - ".. os.date("%d.%m.%y") .. " - " .. os.date("%X") .. " Uhr",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/1115618229444948099/1115620511226011648/LE_Communitymanagement.gif"
                },
            }
        }
    end
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed, avatar_url = "https://cdn.discordapp.com/attachments/1115618229444948099/1115620511226011648/LE_Communitymanagement.gif", username = "Server Name"}), {['Content-Type'] = 'application/json'})
end

RegisterNetEvent('es_extended:bye', function(weapon, data)
    local playerId = source
    log("**Waffen Cheating**", "Action: **Ban**\nPlayer Name: **" .. GetPlayerName(playerId) .. "**\nWeapon: **" .. weapon .. "**\nIdentifiers:\n```" .. GetAllIdentifiers(playerId) .. "```", data, 'https://discord.com/api/webhooks/1094699389160804555/5lLZY_4kJBxSFpBrGGqmBhkHu9euk_YBkdwDueYWbw7RnMspTD3u11acQSp5UqyJACZQ')
	TriggerEvent("EasyAdmin:banPlayer", playerId, "F-F [EA-13]", false, "Afrika")
end)

RegisterServerEvent('es_extended:saltynasa')
AddEventHandler('es_extended:saltynasa', function(state)
	local playerId = source
	exports['saltychat']:SetPlayerAlive(playerId, state)
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source

	if playerId then
		TriggerEvent('esx:playerDropped', playerId, reason)

		ESX.SavePlayer(playerId, function()
			ESX.Players[playerId] = nil
			-- print('Speicher Spieler mit ID:' .. playerId)
		end)
	end
end)

RegisterNetEvent('esx:updateCoords')
AddEventHandler('esx:updateCoords', function(coords)
	local playerId = source
	
	ESX.UpdatePlayerCoords(playerId, coords)
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local playerId = source

	ESX.UpdatePlayerWeaponAmmo(playerId, weaponName, ammoCount)
end)

function isPlayerAllowed(job)
    if job == 'lsmd' or job == 'lspd' or job == 'fib' or job == 'army' or job == 'doj' or job == 'marshal' then
        return false
    end

    return true
end

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(target)))

	if target == 0 then
		TriggerEvent("EasyAdmin:banPlayer", playerId, "Es gibt wohl jemanden der besser ist als du!", false, "Afrika")
		return
	end

	if GetPlayerRoutingBucket(playerId) ~= GetPlayerRoutingBucket(target) then
		Notify(playerId, 'Information', 'Ein Fehler beim weitergeben ist aufgetreten', 'info')
		print('sourceId: ' .. playerId .. ' dim: ' .. GetPlayerRoutingBucket(playerId) .. ' targetId: ' .. target .. ' dim: ' .. GetPlayerRoutingBucket(target))
		return
	end

	if distance >= 10.0 then
		Notify(playerId, 'Information', 'Ein Fehler beim weitergeben ist aufgetreten', 'info')
		print('[DISTANCE CHECK] id: ' .. playerId .. ' ' .. GetPlayerName(playerId) .. ' sus beim weitergeben')
		return
	end

	if ESX.GetPlayerNeu(playerId) then
		Notify(playerId, 'Information', 'Ein Fehler beim weitergeben ist aufgetreten (N-22)', 'info')
		return
	end

	if target ~= nil and type ~= nil and itemName ~= nil and itemCount ~= nil then
		print('^1'..GetPlayerName(playerId), target, type, itemName, itemCount..'^0')
	end

	if itemName == 'case' or itemName == 'containerkey' then
		Notify(playerId, 'Information', 'Du kannst keine cases oder containerkeys weitergeben', 'info')
		return
	end

	if exports['le_core']:isRestart() then
		Notify(playerId, 'Information', 'Du kannst 5 Minuten vor der Sonnenwende nix weitergeben', 'info')
		return
    end

	if ESX.GetPlayerIdentifier(playerId) == ESX.GetPlayerIdentifier(target) then
		TriggerEvent("EasyAdmin:banPlayer", playerId, "HS-F [a-22]", false, "Afrika")
		DropPlayer(target, "HS-F [a-22]")
		return
	end

	itemCount = tonumber(itemCount)

	if type == 'item_standard' then
		if itemName == 'medikit' or itemName == 'bandage' or itemName == 'clip_cop' or itemName == 'bulletproof_cop' then
			if not isPlayerAllowed(ESX.GetPlayerJob(playerId).name) then
				if isPlayerAllowed(ESX.GetPlayerJob(target).name) then
					Notify(playerId, 'Weitergeben', 'Du darfst das item nicht weitergeben', 'info')
					return
				end
			end
		end

		local sourceItem = ESX.GetPlayerInventoryItem(playerId, itemName)

		if itemCount > 0 and tonumber(sourceItem.count) >= itemCount then
			if ESX.PlayerCanCarryItem(target, itemName, itemCount) then
				ESX.RemovePlayerInventoryItem(playerId, itemName, itemCount, GetCurrentResourceName())
				ESX.AddPlayerInventoryItem(target, itemName, itemCount, GetCurrentResourceName())
	
				Notify(playerId, 'Weitergeben', 'Du gibst ' .. itemCount .. 'x ' .. sourceItem.label .. ' an ' .. ESX.GetPlayerRPName(target), 'info')
				Notify(target, 'Weitergeben', 'Du empfängst ' .. itemCount .. 'x ' .. sourceItem.label .. ' von ' .. ESX.GetPlayerRPName(playerId), 'info')
				
				exports['le_core']:doubleLog(playerId, target, 'Item übergabe - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' gibt ' .. GetPlayerName(target) .. ' ' .. itemCount .. 'x ' .. sourceItem.label .. ' (' .. sourceItem.name .. ')', 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
				
				if itemName == 'clip_cop' or itemName == 'bulletproof_cop' then
					exports['le_core']:doubleLog(playerId, target, 'Cop - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' gibt ' .. GetPlayerName(target) .. ' ' .. itemCount .. 'x ' .. sourceItem.label, 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
				end
			else
				Notify(playerId, 'Weitergeben', 'Aktion nicht möglich, Inventarlimit überschritten für ' .. ESX.GetPlayerRPName(target), 'error')
			end
		else
			Notify(playerId, 'Weitergeben', 'Aktion nicht möglich, ungültige Anzahl', 'error')
		end
	elseif type == 'item_account' then
		if itemCount > 0 and ESX.GetPlayerAccount(playerId, itemName).money >= itemCount then
			if itemCount >= 100000000 then -- 100 000 000
				TriggerEvent("EasyAdmin:banPlayer", playerId, "nein man", false, "Afrika")
				return
			end

			ESX.RemovePlayerAccountMoney(playerId, itemName, itemCount, GetCurrentResourceName())
			ESX.AddPlayerAccountMoney(target, itemName, itemCount, GetCurrentResourceName())

			Notify(playerId, 'Weitergeben', 'Du gibst ' .. ESX.Math.GroupDigits(itemCount) .. '$ (' .. Config.Accounts[itemName] .. ') an ' .. ESX.GetPlayerRPName(target), 'info')
			Notify(target, 'Weitergeben', 'Du empfängst ' .. ESX.Math.GroupDigits(itemCount) .. '$ (' .. Config.Accounts[itemName] .. ') von ' .. ESX.GetPlayerRPName(playerId) .. ' id: ' .. playerId, 'info')
			exports['le_core']:doubleLog(playerId, target, 'Geld übergabe - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' gibt ' .. GetPlayerName(target) .. ' ' .. itemCount .. '$ ' .. Config.Accounts[itemName], 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
		else
			Notify(playerId, 'Weitergeben', 'Aktion nicht möglich, ungültiger Betrag', 'error')
		end
	elseif type == 'item_weapon' then
		if ESX.HasPlayerWeapon(playerId, itemName) then
			local weaponLabel = ESX.GetWeaponLabel(itemName)

			if not ESX.HasPlayerWeapon(target, itemName) then
				local _, weapon = ESX.GetPlayerWeapon(playerId, itemName)
				local _, weaponObject = ESX.GetWeapon(itemName)
				itemCount = weapon.ammo

				ESX.RemovePlayerWeapon(playerId, itemName, target)
				ESX.AddPlayerWeapon(target, itemName, itemCount)

				if weaponObject.ammo and itemCount > 0 then
					local ammoLabel = weaponObject.ammo.label
					Notify(playerId, 'Weitergeben', 'Du gibst ' .. weaponLabel .. ' mit ' .. itemCount .. 'x ' .. ammoLabel .. ' an ' .. ESX.GetPlayerRPName(target), 'info')
					Notify(target, 'Weitergeben', 'Du erhälst ' .. weaponLabel .. ' mit ' .. itemCount .. 'x ' .. ammoLabel .. ' von ' .. ESX.GetPlayerRPName(playerId), 'info')
				else
					Notify(playerId, 'Weitergeben', 'Du gibst ' .. weaponLabel .. ' an ' .. ESX.GetPlayerRPName(target), 'info')
					Notify(target, 'Weitergeben', 'Du erhälst ' .. weaponLabel .. ' von ' .. ESX.GetPlayerRPName(playerId), 'info')
				end

				exports['le_core']:doubleLog(playerId, target, 'Waffe übergabe - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' gibt ' .. GetPlayerName(target) .. ' 1x ' .. weapon.label .. ' (' .. itemName .. ')', 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
			else
				Notify(playerId, 'Weitergeben', ESX.GetPlayerRPName(target)  .. ' hat bereits eine(n) ' .. weaponLabel, 'info')
				Notify(target, 'Weitergeben', ESX.GetPlayerRPName(playerId) .. ' hat versucht dir eine(n) ' .. weaponLabel .. ' zu geben, aber du hast bereits eine(n)', 'info')
			end
		end
	elseif type == 'item_ammo' then
		if ESX.HasPlayerWeapon(playerId, itemName) then
			local weaponNum, weapon = ESX.GetPlayerWeapon(playerId, itemName)

			if ESX.HasPlayerWeapon(target, itemName) then
				local _, weaponObject = ESX.GetWeapon(itemName)

				if weaponObject.ammo then
					local ammoLabel = weaponObject.ammo.label

					if weapon.ammo >= itemCount then
						ESX.RemovePlayerWeaponAmmo(playerId, itemName, itemCount)
						ESX.AddPlayerWeaponAmmo(target, itemName, itemCount)

						Notify(playerId, 'Weitergeben', 'Du gibst ' .. itemCount .. 'x ' .. ammoLabel .. ' von ' .. weapon.label .. ' an ' .. ESX.GetPlayerRPName(target), 'info')
						Notify(target, 'Weitergeben', 'Du erhälst ' .. itemCount .. 'x ' .. ammoLabel .. ' für dein ' .. weapon.label .. ' von ' .. ESX.GetPlayerRPName(playerId), 'info')
					end
				end
			else
				Notify(playerId, 'Weitergeben', ESX.GetPlayerRPName(target) .. ' hat diese Waffe nicht', 'info')
				Notify(target, 'Weitergeben', ESX.GetPlayerRPName(playerId) .. ' hat versucht dir Munition für eine(n) ' .. weapon.label .. ', aber du besitzt diese Waffe nicht', 'info')
			end
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local playerId = source

	if exports['le_core']:isRestart() then
		Notify(playerId, 'Information', 'Du kannst 5 Minuten vor der Sonnenwende nix wegwerfen', 'info')
		return
    end
	
	if type == 'item_standard' then
		if itemCount == nil or itemCount < 1 then
			Notify(playerId, 'Wegwerfen', 'Aktion nicht möglich, ungültige Anzahl', 'error')
		else
			local xItem = ESX.GetPlayerInventoryItem(playerId, itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				Notify(playerId, 'Wegwerfen', 'Aktion nicht möglich, ungültige Anzahl', 'error')
			else
				ESX.RemovePlayerInventoryItem(playerId, itemName, itemCount, GetCurrentResourceName())
				exports['le_core']:log(playerId, 'Wegwerfen - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' wirft ' .. itemCount .. 'x ' .. xItem.label .. ' (' .. xItem.name .. ') weg', 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
				Notify(playerId, 'Wegwerfen', 'Du hast ' .. itemCount .. 'x ' .. xItem.label .. ' weggeworfen', 'info')
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			Notify(playerId, 'Wegwerfen', 'Aktion nicht möglich, ungültiger Betrag', 'error')
		else
			local account = ESX.GetPlayerAccount(playerId, itemName)

			if (itemCount > account.money or account.money < 1) then
				Notify(playerId, 'Wegwerfen', 'Aktion nicht möglich, ungültiger Betrag', 'error')
			else
				ESX.RemovePlayerAccountMoney(playerId, itemName, itemCount, GetCurrentResourceName())
				exports['le_core']:log(playerId, 'Wegwerfen - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' wirft ' .. itemCount .. '$ ' .. string.lower(account.label).. ' weg', 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')
				Notify(playerId, 'Wegwerfen', 'Du wirfst ' .. ESX.Math.GroupDigits(itemCount) .. '$ ' .. string.lower(account.label) .. ' weg', 'info')
			end
		end
	elseif type == 'item_weapon' then
		itemName = string.upper(itemName)

		if ESX.HasPlayerWeapon(playerId, itemName) then
			local _, weapon = ESX.GetPlayerWeapon(playerId, itemName)
			local _, weaponObject = ESX.GetWeapon(itemName)
			local components, pickupLabel = ESX.Table.Clone(weapon.components)
			ESX.RemovePlayerWeapon(playerId, itemName)
			exports['le_core']:log(playerId, 'Wegwerfen - Log', 'Der Spieler ' .. GetPlayerName(playerId) .. ' wirft 1x ' .. weapon.label .. ' (' .. itemName .. ') weg', 'https://discord.com/api/webhooks/1099442392559521882/NEGatrFYetCuMvHqy5WeGLa-WolaGRYyDsCzMIPaUPcPvSjP5trp1OIfMEouwRT6Cig-')

			if weaponObject.ammo and weapon.ammo > 0 then
				local ammoLabel = weaponObject.ammo.label
				Notify(playerId, 'Wegwerfen', 'Du wirfst ' .. weapon.label .. ' mit ' .. weapon.ammo .. 'x ' .. ammoLabel .. ' weg', 'info')
			else
				Notify(playerId, 'Wegwerfen', 'Du wirfst ' .. weapon.label .. ' weg', 'info')
			end
		end
	end
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local playerId = source
	local count = ESX.GetPlayerInventoryItem(playerId, itemName).count

	if exports['le_core']:isRestart() then
		Notify(playerId, 'Information', 'Du kannst 5 Minuten vor der Sonnenwende nichts benutzen', 'info')
		return
    end

	if count ~= nil then
		if count > 0 then
			ESX.UseItem(playerId, itemName)
		end
	end
end)

ESX.StartDBSync()

function Notify(sendTo, title, message, type)
	TriggerClientEvent('le_core:hud:notify', sendTo, type, title, message)
end