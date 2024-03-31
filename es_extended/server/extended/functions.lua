ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback "%s" does not exist. Make sure that the server sided file really is loading, an error in that file might cause it to not load.'):format(name))
	end
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item](source, item)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] then
		return ESX.Items[item].label
	end
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.IsJob3 = function(job)
	if ESX.Jobs[job] then
		if ESX.Jobs[job].job3 then
			return true
		else
			return false
		end
	end
end

-- Advanced ESX xPlayer lol

-- money

ESX.AddPlayerMoney = function(source, money, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].addMoney(money, script)
	else
		print('Spieler ist nicht Online für EVENT: für EVENT: addmoney ' .. source)
	end
end

ESX.RemovePlayerMoney = function(source, money, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].removeMoney(money, script)
	else
		print('Spieler ist nicht Online für EVENT: removemoney ' .. source)
	end
end

ESX.AddPlayerAccountMoney = function(source, accountName, money, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].addAccountMoney(accountName, money, script)
	else
		print('Spieler ist nicht Online für EVENT: addaccountmoney ' .. source)
	end
end

ESX.RemovePlayerAccountMoney = function(source, accountName, money, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].removeAccountMoney(accountName, money, script)
	else
		print('Spieler ist nicht Online für EVENT: removeaccountmoney ' .. source)
	end
end

-- item

ESX.AddPlayerInventoryItem = function(source, itemName, itemCount, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].addInventoryItem(itemName, itemCount, script)
	else
		print('Spieler ist nicht Online für EVENT: addinventoryitem ' .. source)
	end
end

ESX.RemovePlayerInventoryItem = function(source, itemName, itemCount, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].removeInventoryItem(itemName, itemCount, script)
	else
		print('Spieler ist nicht Online für EVENT: removeinventoryitem ' .. source)
	end
end

ESX.PlayerCanCarryItem = function(source, itemName, itemCount)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].canCarryItem(itemName, itemCount)
	else
		print('Spieler ist nicht Online für EVENT: cancarryitem ' .. source)
	end
end

-- weapon

ESX.AddPlayerWeapon = function(source, weaponName, ammo)
	if ESX.Players[tonumber(source)] ~= nil then

		print('^3ESX.AddPlayerWeapon^0('..source..', '..weaponName..', '..ammo..')')
		ESX.Players[tonumber(source)].addWeapon(weaponName, ammo)
	else
		print('Spieler ist nicht Online für EVENT: addweapon ' .. source)
	end
end

ESX.RemovePlayerWeapon = function(source, weaponName, ammo, target)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].removeWeapon(weaponName, target)
	else
		print('Spieler ist nicht Online für EVENT: removeweapon ' .. source)
	end
end

ESX.HasPlayerWeapon = function(source, weaponName)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].hasWeapon(weaponName)
	else
		print('Spieler ist nicht Online für EVENT: hasweapon ' .. source)
	end
end

ESX.AddPlayerWeaponAmmo = function(source, weaponName, ammoCount)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].addWeaponAmmo(weaponName, ammoCount)
	else
		print('Spieler ist nicht Online für EVENT: addweaponammo ' .. source)
	end
end

ESX.UpdatePlayerWeaponAmmo = function(source, weaponName, ammoCount)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].updateWeaponAmmo(weaponName, ammoCount)
	else
		print('Spieler ist nicht Online für EVENT: updateweaponammo ' .. source)
	end
end

ESX.RemovePlayerWeaponAmmo = function(source, weaponName, ammoCount)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].removeWeaponAmmo(weaponName, ammoCount)
	else
		print('Spieler ist nicht Online für EVENT: removeplayerweaponammo ' .. source)
	end
end

-- weapon comp

ESX.AddPlayerWeaponComponent = function(source, weaponName, weaponComponent)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].addWeaponComponent(weaponName, weaponComponent)
	else
		print('Spieler ist nicht Online für EVENT: addplayerweaponcomponent ' .. source)
	end
end

ESX.RemovePlayerWeaponComponent = function(source, weaponName, weaponComponent)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].removeWeaponComponent(weaponName, weaponComponent)
	else
		print('Spieler ist nicht Online für EVENT: removeweaponcomponent ' .. source)
	end
end

ESX.HasPlayerWeaponComponent = function(source, weaponName, weaponComponent)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].hasWeaponComponent(weaponName, weaponComponent)
	else
		print('Spieler ist nicht Online für EVENT: hasweaponcomponent ' .. source)
	end
end

-- weapon tint

ESX.GetPlayerWeaponTint = function(source, weaponName)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getWeaponTint(weaponName)
	else
		print('Spieler ist nicht Online für EVENT: getweapontint ' .. source)
	end
end

ESX.SetPlayerWeaponTint = function(source, weaponName, weaponTintIndex)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].setWeaponTint(weaponName, weaponTintIndex)
	else
		print('Spieler ist nicht Online für EVENT: setweapontint ' .. source)
	end
end

--WEAPON DAMAGE

ESX.GetPlayerWeaponHealth = function(source, weaponName)
    if ESX.Players[tonumber(source)] ~= nil then
        return ESX.Players[tonumber(source)].getWeaponHealth(weaponName)
    else
        print('Spieler ist nicht Online für EVENT: getWeaponHealth ' .. source)
    end
end

ESX.SetPlayerWeaponHealth = function(source, weaponName, newHealth)
    if ESX.Players[tonumber(source)] ~= nil then
        return ESX.Players[tonumber(source)].setWeaponHealth(weaponName, newHealth)
    else
        print('Spieler ist nicht Online für EVENT: setWeaponHealth ' .. source)
    end
end

-- all getters

ESX.GetPlayerNeu = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getNeu()
	else
		print('Spieler ist nicht Online für EVENT: getneu ' .. source)
	end
end

ESX.GetPlayerRPName = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getRPName()
	else
		print('Spieler ist nicht Online für EVENT: getrpname ' .. source)
	end
end

ESX.GetPlayerReviveTimer = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getReviveTimer()
	else
		print('Spieler ist nicht Online für EVENT: getrevivetimer ' .. source)
	end
end

ESX.GetPlayerIdentifier = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getIdentifier()
	else
		print('Spieler ist nicht Online für EVENT: getidentifier ' .. source)
	end
end

ESX.GetPlayerDiscordIdentifier = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getDiscordIdentifier()
	end
end

ESX.GetPlayerAccount = function(source, account)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getAccount(account)
	else
		print('Spieler ist nicht Online für EVENT: getaccount ' .. source)
	end
end

ESX.GetPlayerAccounts = function(source, minimal)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getAccounts(minimal)
	else
		print('Spieler ist nicht Online für EVENT: getaccounts ' .. source)
	end
end

ESX.GetPlayerMoney = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getMoney()
	else
		print('Spieler ist nicht Online für EVENT: getmoney ' .. source)
	end
end

ESX.GetPlayerInventoryItem = function(source, itemName)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getInventoryItem(itemName)
	else
		print('Spieler ist nicht Online für EVENT: getinventoryitem ' .. source)
	end
end

ESX.GetPlayerInventory = function(source, minimal)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getInventory(minimal)
	else
		print('Spieler ist nicht Online für EVENT: getinventory ' .. source)
	end
end

ESX.GetPlayerLoadout = function(source, minimal)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getLoadout(minimal)
	else
		print('Spieler ist nicht Online für EVENT: getloadout ' .. source)
	end
end

ESX.GetPlayerJob = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getJob()
	else
		print('Spieler ist nicht Online für EVENT: getjob ' .. source)
		return 'player is not online'
	end
end

ESX.GetPlayerJob2 = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getJob2()
	else
		print('Spieler ist nicht Online für EVENT: getjob2 ' .. source)
	end
end

ESX.GetPlayerJob3 = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getJob3()
	else
		print('Spieler ist nicht Online für EVENT: getjob3 ' .. source)
		return 'player is not online'
	end
end

ESX.GetPlayerName = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return GetPlayerName(source)
	else
		print('Spieler ist nicht Online für EVENT: getname ' .. source)
	end
end

ESX.GetPlayerWeapon = function(source, weaponName)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getWeapon(weaponName)
	else
		print('Spieler ist nicht Online für EVENT: getweapon ' .. source)
	end
end

ESX.GetPlayerPin = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getPin()
	else
		print('Spieler ist nicht Online für EVENT: getpin ' .. source)
	end
end

ESX.GetPlayerGroup = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getGroup()
	else
		print('Spieler ist nicht Online für EVENT: getgroup ' .. source)
	end
end

ESX.GetPlayerSkin = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getSkin()
	else
		print('Spieler ist nicht Online für EVENT: getskin ' .. source)
	end
end

ESX.GetPlayerDim = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getDim()
	else
		print('Spieler ist nicht Online für EVENT: getdim ' .. source)
	end
end

ESX.GetPlayerCoords = function(source, vector)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getCoords(vector)
	else
		print('Spieler ist nicht Online für EVENT: getcoords ' .. source)
	end
end

ESX.GetPlayerIBAN = function(source, iban)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getIban(iban)
	else
		print('Spieler ist nicht Online für EVENT: getiban ' .. source)
	end
end

ESX.GetPlayerJail = function(source, jail)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getJail(jail)
	else
		print('Spieler ist nicht Online für EVENT: getjail ' .. source)
	end
end

ESX.GetPlayerTimePlay = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getTimePlay()
	else
		print('Spieler ist nicht Online für EVENT: gettimeplay ' .. source)
	end
end

ESX.GetPlayerLevel = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getLevel()
	else
		print('Spieler ist nicht Online für EVENT: getlevel ' .. source)
	end
end

ESX.GetPlayerDateOfBirth = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getDateOfBirth()
	else
		print('Spieler ist nicht Online für EVENT: getdateofbirth ' .. source)
	end
end

ESX.GetPlayerSex = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getSex()
	else
		print('Spieler ist nicht Online für EVENT: getsex ' .. source)
	end
end

ESX.GetPlayerHeight = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getHeight()
	else
		print('Spieler ist nicht Online für EVENT: getheight ' .. source)
	end
end

ESX.GetPlayerPersonal = function(source, minimal)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getPersonal(minimal)
	else
		print('Spieler ist nicht Online für EVENT: getpersonal ' .. source)
	end
end

ESX.GetPlayerFirstName = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getFirstname()
	else
		print('Spieler ist nicht Online für EVENT: getfirstname ' .. source)
	end
end

ESX.GetPlayerLastName = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getLastname()
	else
		print('Spieler ist nicht Online für EVENT: getlastname ' .. source)
	end
end

ESX.GetPlayerMarried = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getMarried()
	else
		print('Spieler ist nicht Online für EVENT: getmarried ' .. source)
	end
end

ESX.GetPlayerWeight = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getWeight()
	else
		print('Spieler ist nicht Online für EVENT: getweight ' .. source)
	end
end

ESX.GetPlayerMaxWeight = function(source)
	if ESX.Players[tonumber(source)] ~= nil then
		return ESX.Players[tonumber(source)].getMaxWeight()
	else
		print('Spieler ist nicht Online für EVENT: getmaxweight ' .. source)
	end
end

-- all setters

ESX.SetPlayerNeu = function(source, neu)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setNeu(neu)
	else
		print('Spieler ist nicht Online für EVENT: setneu ' .. source)
	end
end

ESX.SetPlayerRPName = function(source, name)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setRPName(name)
	else
		print('Spieler ist nicht Online für EVENT: setrpname ' .. source)
	end
end

ESX.SetPlayerReviveTimer = function(source, reviveTimer)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setReviveTimer(reviveTimer)
	else
		print('Spieler ist nicht Online für EVENT: setrevivetimer ' .. source)
	end
end

ESX.SetPlayerInventoryItem = function(source, itemName, itemCount, script)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setInventoryItem(itemName, itemCount, script)
	else
		print('Spieler ist nicht Online für EVENT: setinventoryitem ' .. source)
	end
end

ESX.SetPlayerJob = function(source, job, grade)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setJob(job, grade)
	else
		print('Spieler ist nicht Online für EVENT: setjob ' .. source)
	end
end

ESX.SetPlayerJob2 = function(source, job, grade, type)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setJob2(job, grade, type)
	else
		print('Spieler ist nicht Online für EVENT: setjob2 ' .. source)
	end
end

ESX.SetPlayerJob3 = function(source, job, grade)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setJob3(job, grade)
	else
		print('Spieler ist nicht Online für EVENT: setjob3 ' .. source)
	end
end

ESX.SetPlayerJobDienst = function(source, state)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setJobDienst(state)
	else
		print('Spieler ist nicht Online für EVENT: setjobdienst ' .. source)
	end
end

ESX.SetPlayerPin = function(source, pin)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setPin(pin)
	else
		print('Spieler ist nicht Online für EVENT: setpin ' .. source)
	end
end

ESX.SetPlayerGroup = function(source, group)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setGroup(group)
	else
		print('Spieler ist nicht Online für EVENT: setgroup ' .. source)
	end
end

ESX.SetPlayerSkin = function(source, skin)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setSkin(skin)
	else
		print('Spieler ist nicht Online für EVENT: setskin ' .. source)
	end
end

ESX.SetPlayerDim = function(source, dim)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setDim(dim)
	else
		print('Spieler ist nicht Online für EVENT: setdim ' .. source)
	end
end

ESX.SetPlayerCoords = function(source, coords)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setCoords(coords)
	else
		print('Spieler ist nicht Online für EVENT: setcoords ' .. source)
	end
end

ESX.SetPlayerIBAN = function(source, iban)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setIban(iban)
	else
		print('Spieler ist nicht Online für EVENT: setiban ' .. source)
	end
end

ESX.SetPlayerJail = function(source, jail)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setJail(jail)
	else
		print('Spieler ist nicht Online für EVENT: setjail ' .. source)
	end
end

ESX.SetPlayerTimePlay = function(source, timePlay)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setTimePlay(timePlay)
	else
		print('Spieler ist nicht Online für EVENT: settimeplay ' .. source)
	end
end

ESX.SetPlayerLevel = function(source, level)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setLevel(level)
	else
		print('Spieler ist nicht Online für EVENT: setlevel ' .. source)
	end
end

ESX.SetPlayerDateOfBirth = function(source, dateofbirth)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setDateOfBirth(dateofbirth)
	else
		print('Spieler ist nicht Online für EVENT: setdateofbirth ' .. source)
	end
end

ESX.SetPlayerSex = function(source, sex)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setSex(sex)
	else
		print('Spieler ist nicht Online für EVENT: setsex ' .. source)
	end
end

ESX.SetPlayerHeight = function(source, height)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setHeight(height)
	else
		print('Spieler ist nicht Online für EVENT: setheight ' .. source)
	end
end

ESX.SetPlayerPersonal = function(source, have, green, begintime, endtime)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setPersonal(have, green, begintime, endtime)
	else
		print('Spieler ist nicht Online für EVENT: setpersonal ' .. source)
	end
end

ESX.SetPlayerFirstName = function(source, firstname)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setFirstname(firstname)
	else
		print('Spieler ist nicht Online für EVENT: setfirstname ' .. source)
	end
end

ESX.SetPlayerLastName = function(source, lastname)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setLastname(lastname)
	else
		print('Spieler ist nicht Online für EVENT: setlastname ' .. source)
	end
end

ESX.SetPlayerMarried = function(source, married)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setMarried(married)
	else
		print('Spieler ist nicht Online für EVENT: setmarried ' .. source)
	end
end

ESX.SetPlayerMaxWeight = function(source, weight)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].setMaxWeight(weight)
	else
		print('Spieler ist nicht Online für EVENT: setmaxweight ' .. source)
	end
end

ESX.UpdatePlayerCoords = function(source, coords)
	if ESX.Players[tonumber(source)] ~= nil then
		ESX.Players[tonumber(source)].updateCoords(coords)
	else
		print('Spieler ist nicht Online für EVENT: updatecoords ' .. source)
	end
end

-- its lol

ESX.SavePlayer = function(playerId, cb)
	local asyncTasks = {}

	table.insert(asyncTasks, function(cb2)
		local money, bank, black_money, coins, halloween = ESX.GetPlayerMoney(playerId), ESX.GetPlayerAccount(playerId, 'bank'), ESX.GetPlayerAccount(playerId, 'black_money'), ESX.GetPlayerAccount(playerId, 'coins'), ESX.GetPlayerAccount(playerId, 'halloween')
		local job = ESX.GetPlayerJob(playerId)
		local group = ESX.GetPlayerGroup(playerId)
		local loadout = ESX.GetPlayerLoadout(playerId, true)
		local coords = ESX.GetPlayerCoords(playerId)
		local identifier = ESX.GetPlayerIdentifier(playerId)
		local discordIdentifier = ESX.GetPlayerDiscordIdentifier(playerId)
		local inventory = ESX.GetPlayerInventory(playerId, true)
		local dim = ESX.GetPlayerDim(playerId)
		local iban = ESX.GetPlayerIBAN(playerId)
		local jail = ESX.GetPlayerJail(playerId)
		local job2 = ESX.GetPlayerJob2(playerId)
		local job3 = ESX.GetPlayerJob3(playerId)
		local level = ESX.GetPlayerLevel(playerId)
		local timePlay = ESX.GetPlayerTimePlay(playerId)
		local reviveTimer = ESX.GetPlayerReviveTimer(playerId)
		if discordIdentifier ~= nil and reviveTimer ~= nil and money ~= nil and bank ~= nil and black_money ~= nil and coins ~= nil and halloween ~= nil and job ~= nil and job3 ~= nil and group ~= nil and loadout ~= nil and coords ~= nil and identifier ~= nil and inventory ~= nil and dim ~= nil and iban ~= nil and jail ~= nil and job2 ~= nil and level ~= nil and timePlay ~= nil then
			MySQL.Async.execute('UPDATE users SET discord = @discord, revivetimer = @revivetimer, job3 = @job3, job3_grade = @job3_grade, level = @level, timePlay = @timePlay, job2 = @job2, job2_type = @job2_type, job2_grade = @job2_grade, jail = @jail, iban = @iban, black_money = @black_money, coins = @coins, money = @money, halloween = @halloween, bank = @bank, job = @job, job_grade = @job_grade, dienst = @dienst, `group` = @group, loadout = @loadout, position = @position, inventory = @inventory, dim = @dim WHERE identifier = @identifier', {
				['@money'] = money,
				['@bank'] = bank.money,
				['@black_money'] = black_money.money,
				['@coins'] = coins.money,
				['@halloween'] = halloween.money,
				['@job'] = job.name,
				['@job_grade'] = job.grade,
				['@job3'] = job3.name,
				['@job3_grade'] = job3.grade,
				['@dienst'] = job.dienst,
				['@group'] = group,
				['@loadout'] = json.encode(loadout),
				['@position'] = json.encode(coords),
				['@identifier'] = identifier,
				['@inventory'] = json.encode(inventory),
				['@dim'] = dim,
				['@iban'] = iban,
				['@jail'] = jail,
				['@job2'] = job2.id,
				['@job2_type'] = job2.type,
				['@job2_grade'] = job2.grade,
				['@level'] = level,
				['@timePlay'] = timePlay,
				['@revivetimer'] = reviveTimer,
				['@discord'] = discordIdentifier
			}, function(rowsChanged)
				-- print(rowsChanged)
				cb2()
			end)
		else
			print('failed to save an player ' .. playerId)
		end
	end)

	Async.parallel(asyncTasks, function(results)
		if cb then
			--print(('[^Server Name^7] Spieler gespeichert "%s  mit der ID: %s^3"'):format(ESX.GetPlayerRPName(playerId), playerId))

			cb()
		end
	end)
end

ESX.SavePlayers = function(cb)
	local xPlayers = exports['le_core']:GetPlayersFix()
	local startTime = GetGameTimer()

	local asyncTasks = {}

	for k, v in pairs(xPlayers) do
		table.insert(asyncTasks, function(cb2)
			if ESX.Players[v.playerId] ~= nil then
				ESX.SavePlayer(v.playerId, cb2)
			end
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		local performance = tostring((GetGameTimer() - startTime) / 1000.0)
		print(('[^Server Name^7] Saved %s player(s) in %s sec'):format(#xPlayers, performance))
		if cb then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		SetTimeout(60 * 1000 * 120, saveData)
	end

	SetTimeout(60 * 1000 * 120, saveData)
end