function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, job2, job3, loadout, name, coords, level, timePlay, rpName, revivetimer, neu, pin, skin, dim, iban, jail, dateofbirth, sex, height, personal, firstname, lastname, married, discordIdentifier)
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.job2 = job2
	self.job3 = job3
	self.loadout = loadout
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	self.level = level
	self.timePlay = timePlay
	self.rpName = rpName
	self.revivetimer = revivetimer
	self.neu = neu
	self.pin = pin
	self.skin = skin
	self.dim = dim
	self.iban = iban
	self.jail = jail
	self.dateofbirth = dateofbirth
	self.sex = sex
	self.height = height
	self.personal = personal
	self.firstname = firstname
	self.lastname = lastname
	self.married = married
	self.discordIdentifier = discordIdentifier

	self.getDiscordIdentifier = function()
		return self.discordIdentifier
	end

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))

	self.getMarried = function()
		return self.married
	end

	self.setMarried = function(married)
		self.married = married
	end

	self.getFirstname = function()
		return self.firstname
	end

	self.setFirstname = function(firstname)
		self.firstname = firstname
	end

	self.getLastname = function()
		return self.lastname
	end

	self.setLastname = function(lastname)
		self.lastname = lastname
	end

	self.getJail = function()
		return self.jail
	end

	self.setJail = function(jail)
		self.jail = jail
	end

	self.getIban = function()
		return self.iban
	end

	self.setIban = function(iban)
		self.iban = iban
	end

	self.getDim = function()
		return self.dim
	end

	self.setDim = function(dim)
		self.dim = dim
	end

	self.getNeu = function()
		return self.neu
	end

	self.setNeu = function(neu)
		self.neu = neu
	end

	self.getDateOfBirth = function()
		return self.dateofbirth
	end

	self.setDateOfBirth = function(dateofbirth)
		self.dateofbirth = dateofbirth
	end

	self.getSex = function()
		return self.sex
	end

	self.setSex = function(sex)
		self.sex = sex
	end

	self.getHeight = function()
		return self.height
	end

	self.setHeight = function(height)
		self.height = height
	end

	self.getSkin = function()
		return self.skin
	end

	self.setSkin = function(skin)
		self.skin = skin
	end

	self.getPin = function()
		return self.pin
	end

	self.setPin = function(pin)
		self.pin = pin
	end

	self.setRPName = function(rpName)
        self.rpName = rpName
    end

    self.getRPName = function()
        return self.rpName
    end

	self.setReviveTimer = function(reviveTimer)
        self.revivetimer = reviveTimer
    end

    self.getReviveTimer = function()
        return self.revivetimer
    end

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.setCoords = function(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	self.updateCoords = function(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.setLevel = function(level)
		self.updateLevel(level)
	end

	self.updateLevel = function(level)
		self.level = level
		self.triggerEvent('esx:setLevel', self.level)
	end

	self.getLevel = function()
		return self.level
	end

	self.setTimePlay = function(timePlay)
		self.timePlay = timePlay
	end

	self.getTimePlay = function()
		return self.timePlay
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		return self.getAccount('money').money
	end

	self.addMoney = function(money, script)
		money = ESX.Math.Round(money)
		if script ~= nil then
			self.addAccountMoney('money', money, script)
		end
	end

	self.removeMoney = function(money, script)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('money', money, script)
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.setGroup = function(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.identifier, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))
	end

	self.getGroup = function()
		return self.group
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getPersonal = function(minimal)
		if minimal then
			return json.encode(self.personal)
		else
			return self.personal
		end
	end

	self.setPersonal = function(have, green, begintime, endtime)
		self.personal = {}

		table.insert(self.personal, {
			have = have,
			green = green,
			begintime = begintime,
			endtime = endtime
		})
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getJob = function()
		return self.job
	end

	self.getJob2 = function()
		return self.job2
	end

	self.getJob3 = function()
		return self.job3
	end

	self.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							table.insert(components, component)
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setAccountMoney = function(accountName, money)
		print('[^1setAccountMoney^0] ^3'..string.upper(accountName).. ' ^0'..money..'^2$')
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money, script)
		if script ~= nil and money >= 10000000 then
			print('[^2addAccountMoney^0] ^3' .. GetPlayerName(self.source) .. ' ^2' ..string.upper(accountName)..'^0 ' ..money..'^2$^0 [^3'..script..'^0]')
			exports['le_core']:log(self.source, 'Sus shit', 'Der Spieler ' .. GetPlayerName(self.source) .. ' bekommt ' .. ' ' .. money .. '$ (' .. accountName .. ') vom script ' .. script, 'https://discord.com/api/webhooks/1094699527681888266/NIAZJyDWlH8lkcFx_ifcrgiQpDHcDJEfOvhwD6B5zt2HFOoZnVl4Il7UfhCr6h9Q-xQd')
		end
		
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money, script)
		if script ~= nil and money >= 10000000 then
			print('[^1removeAccountMoney^0] ^3' .. GetPlayerName(self.source) .. ' ^2' .. string.upper(accountName)..'^0 '..money..'^2$^0 [^3'..script..'^0]')
			exports['le_core']:log(self.source, 'Sus shit', 'Der Spieler ' .. GetPlayerName(self.source) .. ' entfernt ' .. ' ' .. money .. '$ (' .. accountName .. ') vom script ' .. script, 'https://discord.com/api/webhooks/1094699527681888266/NIAZJyDWlH8lkcFx_ifcrgiQpDHcDJEfOvhwD6B5zt2HFOoZnVl4Il7UfhCr6h9Q-xQd')
		end

		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		return
	end

	self.addInventoryItem = function(name, count, script)
		count = tonumber(count)
		
		if count >= 0 then
			local item = self.getInventoryItem(name)

			if item then
				count = ESX.Math.Round(count)
				item.count = item.count + count
				self.weight = self.weight + (item.weight * count)

				if script ~= nil and count >= 150 then
					print('[^2addInventoryItem^0] ^3' .. GetPlayerName(self.source) .. ' ^2 ' .. count .. 'x ^2' .. string.upper(name)..'^0 [^3'..script..'^0]')
					exports['le_core']:log(self.source, 'Sus shit', 'Der Spieler ' .. GetPlayerName(self.source) .. ' bekommt ' .. ' ' .. count .. 'x ' .. name .. ' vom script ' .. script, 'https://discord.com/api/webhooks/1094699527681888266/NIAZJyDWlH8lkcFx_ifcrgiQpDHcDJEfOvhwD6B5zt2HFOoZnVl4Il7UfhCr6h9Q-xQd')
				end
	
				TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
				self.triggerEvent('esx:addInventoryItem', item.name, item.count)
			end
		end
	end

	self.removeInventoryItem = function(name, count, script)
		count = tonumber(count)

		if count >= 0 then
			local item = self.getInventoryItem(name)

			if item then
				count = ESX.Math.Round(count)
				local newCount = item.count - count
	
				if newCount >= 0 then
					item.count = newCount
					self.weight = self.weight - (item.weight * count)
	
					if script ~= nil and count >= 150 then
						print('[^1removeInventoryItem^0] ^3' .. GetPlayerName(self.source) .. ' ^2 ' .. count .. 'x ^2' .. string.upper(name)..'^0 [^3'..script..'^0]')
						exports['le_core']:log(self.source, 'Sus shit', 'Der Spieler ' .. GetPlayerName(self.source) .. ' entfernt ' .. ' ' .. count .. 'x ' .. name .. ' vom script ' .. script, 'https://discord.com/api/webhooks/1094699527681888266/NIAZJyDWlH8lkcFx_ifcrgiQpDHcDJEfOvhwD6B5zt2HFOoZnVl4Il7UfhCr6h9Q-xQd')
					end

					TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
					self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
				end
			end
		end
	end

	self.setInventoryItem = function(name, count, script)
		if count >= 0 then
			local item = self.getInventoryItem(name)

			if item and count >= 0 then
				count = ESX.Math.Round(count)
	
				if count > item.count then
					self.addInventoryItem(item.name, count - item.count, script)
				else
					self.removeInventoryItem(item.name, item.count - count, script)
				end
			end
		end
	end

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label
			self.job.dienst = false
			self.job.legal = jobObject.legal

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.setJob2 = function(job, grade, type)
		grade = tostring(grade)

		self.job2.id = job
		self.job2.type = type
		self.job2.grade = grade

		TriggerEvent('esx:setJob2', self.source, self.job2)
		self.triggerEvent('esx:setJob2', self.job2)
	end

	self.setJob3 = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job3))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job3.id    = jobObject.id
			self.job3.name  = jobObject.name
			self.job3.label = jobObject.label
			self.job3.dienst = false
			self.job3.legal = jobObject.legal

			self.job3.grade        = tonumber(grade)
			self.job3.grade_name   = gradeObject.name
			self.job3.grade_label  = gradeObject.label
			self.job3.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job3.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job3.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job3.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job3.skin_female = {}
			end

			TriggerEvent('esx:setJob3', self.source, self.job3, lastJob)
			self.triggerEvent('esx:setJob3', self.job3)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob3() usage for "%s"'):format(self.identifier))
		end
	end

	self.setJobDienst = function(state)
		self.job.dienst = state
		TriggerEvent('esx:setJobDienst', self.source, self.job, state)
		self.triggerEvent('esx:setJobDienst', self.job, state)
	end

	self.addWeapon = function(weaponName, ammo)
		local weaponName = string.upper(weaponName)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)
			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			self.triggerEvent('esx:addWeapon', weaponName, ammo)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)
		local ammoCount = tonumber(ammoCount)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	self.setWeaponTint = function(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	self.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.setWeaponHealth = function(weaponName, newHealth)
        local loadoutNum, weapon = self.getWeapon(weaponName)
        if weapon then
            self.loadout[loadoutNum].health = newHealth
        end
    end

    self.getWeaponHealth = function(weaponName)
        local loadoutNum, weapon = self.getWeapon(weaponName)
        if weapon then
            return weapon.health
        end
        return nil
    end

	self.removeWeapon = function(weaponName, target)
		local weaponLabel

		for k, v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2, v2 in pairs(v.components) do
					if target ~= 'dead' then
						if target == nil then
							if ESX.PlayerCanCarryItem(self.source, v2, 1) then
								self.addInventoryItem(v2, 1)
							end
						else
							if ESX.PlayerCanCarryItem(target, v2, 1) then
								ESX.AddPlayerInventoryItem(target, v2, 1, GetCurrentResourceName())
							end
						end
					end
				end

				for k2, v2 in pairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName)
			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					--self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	return self
end