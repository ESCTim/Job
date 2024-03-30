
local spawnedVehicles = {}

function OpenVehicleSpawnerMenu(type, station, part, partNum)
    local playerCoords = GetEntityCoords(PlayerPedId())

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title = "Fahrzeug Funktionen",
		align = 'top-left',
		elements = {
			{label = "Garage öffnen", action = 'garage'},
			{label = "Fahrzeug in die Garage stellen", action = 'store_garage'},
			{label = "Fahrzeug Shop", action = 'buy_vehicle'}
	}}, function(data, menu)
		if data.current.action == 'buy_vehicle' then
			local shopElements = {}
			local shopCoords = Config.Jobs[ESX.PlayerData.job.name][part][partNum].InsideShop
			local authorizedVehicles = Config.Jobs[ESX.PlayerData.job.name].AuthorizedVehicles[type][ESX.PlayerData.job.grade_name]

			if #authorizedVehicles > 0 then
				for k, vehicle in ipairs(authorizedVehicles) do
					if IsModelInCdimage(vehicle.model) then
						local vehicleLabel = GetDisplayNameFromVehicleModel(vehicle.model)

						table.insert(shopElements, {
							label = ('%s - <span style="color:green;">%s</span>'):format(vehicleLabel, ESX.Math.GroupDigits(vehicle.price) .. "$"),
							name  = vehicleLabel,
							model = vehicle.model,
							price = vehicle.price,
							props = vehicle.props,
							type  = type
						})
					end
				end

				if #shopElements > 0 then
					OpenShopMenu(shopElements, playerCoords, shopCoords)
				else
					TriggerEvent('le_core:hud:notify', 'error', "Garage", 'Du darfst dieses Fahrzeug nicht kaufen.')
				end
			else
				TriggerEvent('le_core:hud:notify', 'error', "Garage", 'Du darfst dieses Fahrzeug nicht kaufen.')
			end
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('le_core:vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					local allVehicleProps = {}

					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)

						if IsModelInCdimage(props.model) then
							local vehicleName = GetDisplayNameFromVehicleModel(props.model)
							local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

							if v.stored then
								label = label .. ('<span style="color:green;">%s</span>'):format("Eingelagert")
							else
								label = label .. ('<span style="color:darkred;">%s</span>'):format("Nicht in der Garage")
							end

							table.insert(garage, {
								label = label,
								stored = v.stored,
								model = props.model,
								plate = props.plate
							})

							allVehicleProps[props.plate] = props
						end
					end

					if #garage > 0 then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
							title = "Fahrzeug Funktionen",
							align = 'top-left',
							elements = garage
						}, function(data2, menu2)
							if data2.current.stored then
								local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(ESX.PlayerData.job.name, station, part, partNum)

								if foundSpawn then
									menu2.close()

									ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
										local vehicleProps = allVehicleProps[data2.current.plate]
										ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

										TriggerServerEvent('le_core:vehicleshop:setJobVehicleState', data2.current.plate, false)

										TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

										TriggerEvent('le_core:hud:notify', 'success', 'Garage', 'Dein Fahrzeug wurde ausgeparkt')
										exports['le_core']:setVehicle(data2.current.plate, 'store', false)
									end)
								end
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Garage', 'Es ist kein Fahrzeug in der Nähe')
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					else
						TriggerEvent('le_core:hud:notify', 'error', 'Garage', 'Du hast keine Fahrzeuge in deiner Garage.')
					end
				else
					TriggerEvent('le_core:hud:notify', 'error', 'Garage', 'Du hast keine Fahrzeuge in deiner Garage.')
				end
			end, type)
		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then
		for k, v in ipairs(vehicles) do
			local vehicleProps = ESX.Game.GetVehicleProperties(v)
            TriggerServerEvent('le_core:garage:saveProps', ESX.Math.Trim(GetVehicleNumberPlateText(v)), vehicleProps)
			
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		TriggerEvent('le_core:hud:notify', 'success', 'Garage', 'Kein Fahrzeug in der Nähe')
		return
	end

	ESX.TriggerServerCallback('le_jobpack:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			CreateThread(function()
				BeginTextCommandBusyspinnerOn('STRING')
				AddTextComponentSubstringPlayerName('Versuch das Fahrzeug zu entfernen, stell sicher, dass sich kein Spieler in der Nähe befindet.')
				EndTextCommandBusyspinnerOn(4)

				while IsBusy do
					Wait(100)
				end

				BusyspinnerOff()
			end)

			while DoesEntityExist(vehicleId.vehicle) do
				Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			IsBusy = false
			TriggerEvent('le_core:hud:notify', 'success', 'Garage', 'Das Fahrzeug ist in deiner Garage.')
			exports['le_core']:setVehicle(vehicleId.plate, 'store', true)
		else
			TriggerEvent('le_core:hud:notify', 'success', 'Garage', 'Kein Fahrzeug in der Nähe')
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(job, station, part, partNum)
	print(job, station, part, partNum)
	local spawnPoints = Config.Jobs[ESX.PlayerData.job.name][part][partNum].SpawnPoints
	--local spawnPoints = Config.Jobs[job][station][part][partNum].SpawnPoints
	--local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		TriggerEvent('le_core:hud:notify', 'error', 'Garage', 'Alle Spawnpunkte sind zurzeit belegt!')
		return false
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title = "Fahrzeug Shop",
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title = "Willst du dieses Fahrzeug kaufen?",
			align = 'top-left',
			elements = {
				{label = "Nein", value = 'no'},
				{label = "Ja", value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['le_core']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('le_jobpack:buyJobVehicle', function (bought)
					if bought then
						TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast dieses Fahrzeug ' .. data.current.name .. 'für $' .. ESX.Math.GroupDigits(data.current.price) .. ' gekauft!')

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)

						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du kannst dir dieses Fahrzeug nicht leisten')

						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(elements[1].model)

		if elements[1].props then
			ESX.Game.SetVehicleProperties(vehicle, elements[1].props)
		end
	end)
end

CreateThread(function()
	while true do
		Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
		else
			Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName('The vehicle is currently ~g~DOWNLOADING & LOADING~s~ please wait')
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end