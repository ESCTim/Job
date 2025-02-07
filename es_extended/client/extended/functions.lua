ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
ESX.TimeoutCallbacks          = {}

ESX.UI                        = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Streaming                 = {}

ESX.SetTimeout = function(msec, cb)
	table.insert(ESX.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #ESX.TimeoutCallbacks
end

ESX.ClearTimeout = function(i)
	ESX.TimeoutCallbacks[i] = nil
end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

ESX.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('esxAdvancedNotification', msg)
	BeginTextCommandThefeedPost('esxAdvancedNotification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

ESX.ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('esxHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('esxHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('esxHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

ESX.ShowFloatingHelpNotification = function(msg, coords)
	AddTextEntry('esxFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

ESX.TriggerServerCallback = function(name, cb, ...)
	ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

	TriggerServerEvent('esx:triggerServerCallback', name, ESX.CurrentRequestId, ...)

	if ESX.CurrentRequestId < 65535 then
		ESX.CurrentRequestId = ESX.CurrentRequestId + 1
	else
		ESX.CurrentRequestId = 0
	end
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		script = 'extended',
		action = 'inventoryNotification',
		add = add,
		item = item,
		count = count
	})
end

ESX.Game.GetPedMugshot = function(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

ESX.Game.Teleport = function(entity, coords, cb)
	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		local timeout = 0

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
			Wait(0)
			timeout = timeout + 1
		end

		SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
		end
	end

	if cb then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

ESX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

ESX.Game.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

ESX.Game.GetClosestPlayer = function(coords) return ESX.Game.GetClosestEntity(ESX.Game.GetPlayers(true, true), true, coords, nil) end
ESX.Game.GetClosestVehicle = function(coords, modelFilter) return ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, coords, modelFilter) end
ESX.Game.GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(ESX.Game.GetVehicles(), false, coords, maxDistance) end
ESX.Game.IsSpawnPointClear = function(coords, maxDistance) return #ESX.Game.GetVehiclesInArea(coords, maxDistance) == 0 end

ESX.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

ESX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

-- ESX.Game.GetVehicleProperties = function(vehicle)
-- 	if DoesEntityExist(vehicle) then
-- 		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
-- 		local paintType1, whoCaresColor1, nnn = GetVehicleModColor_1(vehicle)
-- 		local paintType2, whoCaresColor2 = GetVehicleModColor_2(vehicle)
-- 		local color3 = {}
-- 		local color4 = {}
-- 		color3[1], color3[2], color3[3] = GetVehicleCustomPrimaryColour(vehicle)
-- 		color4[1], color4[2], color4[3] = GetVehicleCustomSecondaryColour(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
-- 		local dshcolor = GetVehicleDashboardColour(vehicle)
-- 		local intcolor = GetVehicleInteriorColour(vehicle)
-- 		local drift = GetDriftTyresEnabled(vehicle)
-- 		local extras = {}

-- 		for id=0, 12 do
-- 			if DoesExtraExist(vehicle, id) then
-- 				local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
-- 				extras[tostring(id)] = state
-- 			end
-- 		end

-- 		return {
-- 			model             = GetEntityModel(vehicle),

-- 			plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
-- 			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

-- 			bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
-- 			engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

-- 			fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
-- 			dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
-- 			color1            = colorPrimary,
-- 			color2            = colorSecondary,
-- 			color3            = color3,
-- 			color4            = color4,
-- 			paintType		  = {paintType1, paintType2},
-- 			ColorType 		  = {whoCaresColor1, whoCaresColor2},	
-- 			pearlescentColor  = pearlescentColor,
-- 			wheelColor        = wheelColor,
-- 			dshcolor 		  = dshcolor,
-- 			intcolor 		  = intcolor,
-- 			drift			  = drift,
			
-- 			wheels            = GetVehicleWheelType(vehicle),
-- 			windowTint        = GetVehicleWindowTint(vehicle),
-- 			xenonColor        = GetVehicleXenonLightsColour(vehicle),

-- 			neonEnabled       = {
-- 				IsVehicleNeonLightEnabled(vehicle, 0),
-- 				IsVehicleNeonLightEnabled(vehicle, 1),
-- 				IsVehicleNeonLightEnabled(vehicle, 2),
-- 				IsVehicleNeonLightEnabled(vehicle, 3)
-- 			},

-- 			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
-- 			extras            = extras,
-- 			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

-- 			modSpoilers       = GetVehicleMod(vehicle, 0),
-- 			modFrontBumper    = GetVehicleMod(vehicle, 1),
-- 			modRearBumper     = GetVehicleMod(vehicle, 2),
-- 			modSideSkirt      = GetVehicleMod(vehicle, 3),
-- 			modExhaust        = GetVehicleMod(vehicle, 4),
-- 			modFrame          = GetVehicleMod(vehicle, 5),
-- 			modGrille         = GetVehicleMod(vehicle, 6),
-- 			modHood           = GetVehicleMod(vehicle, 7),
-- 			modFender         = GetVehicleMod(vehicle, 8),
-- 			modRightFender    = GetVehicleMod(vehicle, 9),
-- 			modRoof           = GetVehicleMod(vehicle, 10),

-- 			modEngine         = GetVehicleMod(vehicle, 11),
-- 			modBrakes         = GetVehicleMod(vehicle, 12),
-- 			modTransmission   = GetVehicleMod(vehicle, 13),
-- 			modHorns          = GetVehicleMod(vehicle, 14),
-- 			modSuspension     = GetVehicleMod(vehicle, 15),
-- 			modArmor          = GetVehicleMod(vehicle, 16),

-- 			modTurbo          = IsToggleModOn(vehicle, 18),
-- 			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
-- 			modXenon          = IsToggleModOn(vehicle, 22),
-- 			modWheelVariat	  = GetVehicleModVariation(vehicle,23),
-- 			modTyresBurst     = GetVehicleTyresCanBurst(vehicle),

-- 			modFrontWheels    = GetVehicleMod(vehicle, 23),
-- 			modBackWheels     = GetVehicleMod(vehicle, 24),

-- 			modPlateHolder    = GetVehicleMod(vehicle, 25),
-- 			modVanityPlate    = GetVehicleMod(vehicle, 26),
-- 			modTrimA          = GetVehicleMod(vehicle, 27),
-- 			modOrnaments      = GetVehicleMod(vehicle, 28),
-- 			modDashboard      = GetVehicleMod(vehicle, 29),
-- 			modDial           = GetVehicleMod(vehicle, 30),
-- 			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
-- 			modSeats          = GetVehicleMod(vehicle, 32),
-- 			modSteeringWheel  = GetVehicleMod(vehicle, 33),
-- 			modShifterLeavers = GetVehicleMod(vehicle, 34),
-- 			modAPlate         = GetVehicleMod(vehicle, 35),
-- 			modSpeakers       = GetVehicleMod(vehicle, 36),
-- 			modTrunk          = GetVehicleMod(vehicle, 37),
-- 			modHydrolic       = GetVehicleMod(vehicle, 38),
-- 			modEngineBlock    = GetVehicleMod(vehicle, 39),
-- 			modAirFilter      = GetVehicleMod(vehicle, 40),
-- 			modStruts         = GetVehicleMod(vehicle, 41),
-- 			modArchCover      = GetVehicleMod(vehicle, 42),
-- 			modAerials        = GetVehicleMod(vehicle, 43),
-- 			modTrimB          = GetVehicleMod(vehicle, 44),
-- 			modTank           = GetVehicleMod(vehicle, 45),
-- 			modWindows        = GetVehicleMod(vehicle, 46),
-- 			modLivery         = GetVehicleLivery(vehicle),
-- 			modLivery2         = GetVehicleMod(vehicle, 48),
-- 		}
-- 	else
-- 		return
-- 	end
-- end

ESX.Game.GetVehicleProperties = function(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
    local customPrimaryColor = nil
    if hasCustomPrimaryColor then
        customPrimaryColor = {GetVehicleCustomPrimaryColour(vehicle)}
    end

    local hasCustomXenonColor, customXenonColorR, customXenonColorG, customXenonColorB = GetVehicleXenonLightsCustomColor(vehicle)
    local customXenonColor = nil
    if hasCustomXenonColor then 
        customXenonColor = {customXenonColorR, customXenonColorG, customXenonColorB}
    end
    
    local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
    local customSecondaryColor = nil
    if hasCustomSecondaryColor then
        customSecondaryColor = {GetVehicleCustomSecondaryColour(vehicle)}
    end

    local extras = {}
    for extraId = 0, 20 do
        if DoesExtraExist(vehicle, extraId) then
            extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
        end
    end

    local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
    local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

    local TyresIndex = { -- Wheel index list according to the number of vehicle wheels.
        ['2'] = {0, 4}, -- Bike and cycle.
        ['3'] = {0, 1, 4, 5}, -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
        ['4'] = {0, 1, 4, 5}, -- Vehicle with 4 wheels.
        ['6'] = {0, 1, 2, 3, 4, 5} -- Vehicle with 6 wheels.
    }

    if TyresIndex[numWheels] then
        for tyre, idx in pairs(TyresIndex[numWheels]) do
            tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
        end
    end

    for windowId = 0, 7 do -- 13
        windowsBroken[tostring(windowId)] = not IsVehicleWindowIntact(vehicle, windowId)
    end

    local numDoors = GetNumberOfVehicleDoors(vehicle)
    if numDoors and numDoors > 0 then
        for doorsId = 0, numDoors do
            doorsBroken[tostring(doorsId)] = IsVehicleDoorDamaged(vehicle, doorsId)
        end
    end

    return {
        model = GetEntityModel(vehicle),
        doorsBroken = doorsBroken,
        windowsBroken = windowsBroken,
        tyreBurst = tyreBurst,
        plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

        bodyHealth = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
        engineHealth = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
        tankHealth = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),
        fuelLevel = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
        dirtLevel = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),

        color1 = colorPrimary,
        color2 = colorSecondary,
        customPrimaryColor = customPrimaryColor,
        customSecondaryColor = customSecondaryColor,
        dashboardColor = GetVehicleDashboardColour(vehicle),
        interiorColor = GetVehicleInteriorColour(vehicle),
        pearlescentColor = pearlescentColor,
        wheelColor = wheelColor,
        
        wheels = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),

        xenonColor = GetVehicleXenonLightsColor(vehicle),
        customXenonColor = customXenonColor,
        
        neonEnabled = {IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1), IsVehicleNeonLightEnabled(vehicle, 2), IsVehicleNeonLightEnabled(vehicle, 3)},
        neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),

        extras = extras,
        tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

        modSpoilers = GetVehicleMod(vehicle, 0),
        modFrontBumper = GetVehicleMod(vehicle, 1),
        modRearBumper = GetVehicleMod(vehicle, 2),
        modSideSkirt = GetVehicleMod(vehicle, 3),
        modExhaust = GetVehicleMod(vehicle, 4),
        modFrame = GetVehicleMod(vehicle, 5),
        modGrille = GetVehicleMod(vehicle, 6),
        modHood = GetVehicleMod(vehicle, 7),
        modFender = GetVehicleMod(vehicle, 8),
        modRightFender = GetVehicleMod(vehicle, 9),
        modRoof = GetVehicleMod(vehicle, 10),

        modEngine = GetVehicleMod(vehicle, 11),
        modBrakes = GetVehicleMod(vehicle, 12),
        modTransmission = GetVehicleMod(vehicle, 13),
        modHorns = GetVehicleMod(vehicle, 14),
        modSuspension = GetVehicleMod(vehicle, 15),
        modArmor = GetVehicleMod(vehicle, 16),

        modTurbo = IsToggleModOn(vehicle, 18),
        modSmokeEnabled = IsToggleModOn(vehicle, 20),
        modXenon = IsToggleModOn(vehicle, 22),

        modFrontWheels = GetVehicleMod(vehicle, 23),
        modBackWheels = GetVehicleMod(vehicle, 24),

        modPlateHolder = GetVehicleMod(vehicle, 25),
        modVanityPlate = GetVehicleMod(vehicle, 26),
        modTrimA = GetVehicleMod(vehicle, 27),
        modOrnaments = GetVehicleMod(vehicle, 28),
        modDashboard = GetVehicleMod(vehicle, 29),
        modDial = GetVehicleMod(vehicle, 30),
        modDoorSpeaker = GetVehicleMod(vehicle, 31),
        modSeats = GetVehicleMod(vehicle, 32),
        modSteeringWheel = GetVehicleMod(vehicle, 33),
        modShifterLeavers = GetVehicleMod(vehicle, 34),
        modAPlate = GetVehicleMod(vehicle, 35),
        modSpeakers = GetVehicleMod(vehicle, 36),
        modTrunk = GetVehicleMod(vehicle, 37),
        modHydrolic = GetVehicleMod(vehicle, 38),
        modEngineBlock = GetVehicleMod(vehicle, 39),
        modAirFilter = GetVehicleMod(vehicle, 40),
        modStruts = GetVehicleMod(vehicle, 41),
        modArchCover = GetVehicleMod(vehicle, 42),
        modAerials = GetVehicleMod(vehicle, 43),
        modTrimB = GetVehicleMod(vehicle, 44),
        modTank = GetVehicleMod(vehicle, 45),
        modDoorR = GetVehicleMod(vehicle, 47),
        modLivery = GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) or GetVehicleMod(vehicle, 48),
        modLightbar = GetVehicleMod(vehicle, 49)
    }
end


-- ESX.Game.SetVehicleProperties = function(vehicle, props)
-- 	if DoesEntityExist(vehicle) then
-- 		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
-- 		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
-- 		SetVehicleModKit(vehicle, 0)

-- 		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
-- 		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
-- 		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
-- 		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
-- 		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
-- 		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
-- 		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
-- 		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
-- 		if props.color3 ~= nil then 
-- 			ClearVehicleCustomPrimaryColour(vehicle)
-- 			SetVehicleCustomPrimaryColour(vehicle, props.color3[1], props.color3[2], props.color3[3])
-- 		end
-- 		if props.color4 ~= nil then
-- 			ClearVehicleCustomSecondaryColour(vehicle)
-- 			SetVehicleCustomSecondaryColour(vehicle, props.color4[1], props.color4[2], props.color4[3])
-- 		end
-- 		if props.paintType ~= nil then
-- 			local coraplicarp = 0
-- 			local coraplicars = 0
-- 			if props.ColorType then
-- 				coraplicarp = props.ColorType[1]
-- 				coraplicars = props.ColorType[2]
-- 			end
-- 			SetVehicleModColor_1(vehicle, props.paintType[1], coraplicarp, 0)
-- 			SetVehicleModColor_2(vehicle, props.paintType[2], coraplicars)
-- 		end
-- 		if props.dshcolor ~= nil then
-- 			SetVehicleDashboardColour(vehicle, props.dshcolor)
-- 		end
-- 		if props.intcolor ~= nil then
-- 			SetVehicleInteriorColour(vehicle, props.intcolor)
-- 		end
-- 		if props.drift ~= nil then
-- 			SetDriftTyresEnabled(vehicle,props.drift)
-- 		end

-- 		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
-- 		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
-- 		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
-- 		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

-- 		if props.neonEnabled then
-- 			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
-- 			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
-- 			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
-- 			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
-- 		end

-- 		if props.extras then
-- 			for id,enabled in pairs(props.extras) do
-- 				if enabled then
-- 					SetVehicleExtra(vehicle, tonumber(id), 0)
-- 				else
-- 					SetVehicleExtra(vehicle, tonumber(id), 1)
-- 				end
-- 			end
-- 		end

-- 		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
-- 		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
-- 		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
-- 		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
-- 		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
-- 		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
-- 		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
-- 		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
-- 		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
-- 		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
-- 		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
-- 		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
-- 		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
-- 		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
-- 		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
-- 		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
-- 		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
-- 		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
-- 		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
-- 		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
-- 		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
-- 		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
-- 		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
-- 		if props.modTyresBurst ~= nil then
-- 			SetVehicleTyresCanBurst(vehicle,props.modTyresBurst)
-- 		end
-- 		if props.modFrontWheels ~= nil then
-- 			local aplicar = false
-- 			if props.modWheelVariat then
-- 				aplicar = props.modWheelVariat
-- 			end
-- 			SetVehicleMod(vehicle, 23, props.modFrontWheels, aplicar)
-- 		end
-- 		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
-- 		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
-- 		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
-- 		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
-- 		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
-- 		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
-- 		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
-- 		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
-- 		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
-- 		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
-- 		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
-- 		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
-- 		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
-- 		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
-- 		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
-- 		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
-- 		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
-- 		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
-- 		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
-- 		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
-- 		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
-- 		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
-- 		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

-- 		if props.modLivery then
-- 			SetVehicleLivery(vehicle, props.modLivery)
-- 		end
-- 		if props.modLivery2 then
-- 			SetVehicleMod(vehicle, 48, props.modLivery2, false)
-- 		end
-- 	end
-- end

ESX.Game.SetVehicleProperties = function(vehicle, props)
    if not DoesEntityExist(vehicle) then
        return
    end
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    SetVehicleModKit(vehicle, 0)
    if props.plate ~= nil then
        SetVehicleNumberPlateText(vehicle, props.plate)
    end
    if props.plateIndex ~= nil then
        SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
    end
    if props.bodyHealth ~= nil then
        SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
    end
    if props.engineHealth ~= nil then
        SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
    end
    if props.tankHealth ~= nil then
        SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
    end
    if props.fuelLevel ~= nil then
        SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
    end
    if props.dirtLevel ~= nil then
        SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
    end
    if props.customPrimaryColor ~= nil then
        SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3])
    end
    if props.customSecondaryColor ~= nil then
        SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3])
    end
    if props.color1 ~= nil then
        SetVehicleColours(vehicle, props.color1, colorSecondary)
    end
    if props.color2 ~= nil then
        SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
    end
    if props.interiorColor then
        SetVehicleInteriorColor(vehicle, props.interiorColor)
    end
    if props.dashboardColor then
        SetVehicleDashboardColour(vehicle, props.dashboardColor)
    end
    if props.pearlescentColor ~= nil then
        SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
    end
    if props.wheelColor ~= nil then
        SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
    end
    if props.wheels ~= nil then
        SetVehicleWheelType(vehicle, props.wheels)
    end
    if props.windowTint ~= nil then
        SetVehicleWindowTint(vehicle, props.windowTint)
    end
    if props.neonEnabled ~= nil then
        SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
        SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
        SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
        SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
    end
    if props.extras ~= nil then
        for extraId, enabled in pairs(props.extras) do
            SetVehicleExtra(vehicle, tonumber(extraId), enabled and 0 or 1)
        end
    end
    if props.neonColor ~= nil then
        SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
    end
    if props.xenonColor ~= nil then
        SetVehicleXenonLightsColor(vehicle, props.xenonColor)
    end
    if props.customXenonColor ~= nil then
        SetVehicleXenonLightsCustomColor(vehicle, props.customXenonColor[1], props.customXenonColor[2], props.customXenonColor[3])
    end
    if props.modSmokeEnabled ~= nil then
        ToggleVehicleMod(vehicle, 20, true)
    end
    if props.tyreSmokeColor ~= nil then
        SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
    end
    if props.modSpoilers ~= nil then
        SetVehicleMod(vehicle, 0, props.modSpoilers, false)
    end
    if props.modFrontBumper ~= nil then
        SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
    end
    if props.modRearBumper ~= nil then
        SetVehicleMod(vehicle, 2, props.modRearBumper, false)
    end
    if props.modSideSkirt ~= nil then
        SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
    end
    if props.modExhaust ~= nil then
        SetVehicleMod(vehicle, 4, props.modExhaust, false)
    end
    if props.modFrame ~= nil then
        SetVehicleMod(vehicle, 5, props.modFrame, false)
    end
    if props.modGrille ~= nil then
        SetVehicleMod(vehicle, 6, props.modGrille, false)
    end
    if props.modHood ~= nil then
        SetVehicleMod(vehicle, 7, props.modHood, false)
    end
    if props.modFender ~= nil then
        SetVehicleMod(vehicle, 8, props.modFender, false)
    end
    if props.modRightFender ~= nil then
        SetVehicleMod(vehicle, 9, props.modRightFender, false)
    end
    if props.modRoof ~= nil then
        SetVehicleMod(vehicle, 10, props.modRoof, false)
    end
    if props.modEngine ~= nil then
        SetVehicleMod(vehicle, 11, props.modEngine, false)
    end
    if props.modBrakes ~= nil then
        SetVehicleMod(vehicle, 12, props.modBrakes, false)
    end
    if props.modTransmission ~= nil then
        SetVehicleMod(vehicle, 13, props.modTransmission, false)
    end
    if props.modHorns ~= nil then
        SetVehicleMod(vehicle, 14, props.modHorns, false)
    end
    if props.modSuspension ~= nil then
        SetVehicleMod(vehicle, 15, props.modSuspension, false)
    end
    if props.modArmor ~= nil then
        SetVehicleMod(vehicle, 16, props.modArmor, false)
    end
    if props.modTurbo ~= nil then
        ToggleVehicleMod(vehicle, 18, props.modTurbo)
    end
    if props.modXenon ~= nil then
        ToggleVehicleMod(vehicle, 22, props.modXenon)
    end
    if props.modFrontWheels ~= nil then
        SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
    end
    if props.modBackWheels ~= nil then
        SetVehicleMod(vehicle, 24, props.modBackWheels, false)
    end
    if props.modPlateHolder ~= nil then
        SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
    end
    if props.modVanityPlate ~= nil then
        SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
    end
    if props.modTrimA ~= nil then
        SetVehicleMod(vehicle, 27, props.modTrimA, false)
    end
    if props.modOrnaments ~= nil then
        SetVehicleMod(vehicle, 28, props.modOrnaments, false)
    end
    if props.modDashboard ~= nil then
        SetVehicleMod(vehicle, 29, props.modDashboard, false)
    end
    if props.modDial ~= nil then
        SetVehicleMod(vehicle, 30, props.modDial, false)
    end
    if props.modDoorSpeaker ~= nil then
        SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
    end
    if props.modSeats ~= nil then
        SetVehicleMod(vehicle, 32, props.modSeats, false)
    end
    if props.modSteeringWheel ~= nil then
        SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
    end
    if props.modShifterLeavers ~= nil then
        SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
    end
    if props.modAPlate ~= nil then
        SetVehicleMod(vehicle, 35, props.modAPlate, false)
    end
    if props.modSpeakers ~= nil then
        SetVehicleMod(vehicle, 36, props.modSpeakers, false)
    end
    if props.modTrunk ~= nil then
        SetVehicleMod(vehicle, 37, props.modTrunk, false)
    end
    if props.modHydrolic ~= nil then
        SetVehicleMod(vehicle, 38, props.modHydrolic, false)
    end
    if props.modEngineBlock ~= nil then
        SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
    end
    if props.modAirFilter ~= nil then
        SetVehicleMod(vehicle, 40, props.modAirFilter, false)
    end
    if props.modStruts ~= nil then
        SetVehicleMod(vehicle, 41, props.modStruts, false)
    end
    if props.modArchCover ~= nil then
        SetVehicleMod(vehicle, 42, props.modArchCover, false)
    end
    if props.modAerials ~= nil then
        SetVehicleMod(vehicle, 43, props.modAerials, false)
    end
    if props.modTrimB ~= nil then
        SetVehicleMod(vehicle, 44, props.modTrimB, false)
    end
    if props.modTank ~= nil then
        SetVehicleMod(vehicle, 45, props.modTank, false)
    end
    if props.modWindows ~= nil then
        SetVehicleMod(vehicle, 46, props.modWindows, false)
    end

    if props.modLivery ~= nil then
        SetVehicleMod(vehicle, 48, props.modLivery, false)
        SetVehicleLivery(vehicle, props.modLivery)
    end

    if props.windowsBroken ~= nil then
        for k, v in pairs(props.windowsBroken) do
            if v then
                SmashVehicleWindow(vehicle, tonumber(k))
            end
        end
    end

    if props.doorsBroken ~= nil then
        for k, v in pairs(props.doorsBroken) do
            if v then
                SetVehicleDoorBroken(vehicle, tonumber(k), true)
            end
        end
    end

    if props.tyreBurst ~= nil then
        for k, v in pairs(props.tyreBurst) do
            if v then
                SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0)
            end
        end
    end
end

ESX.Game.Utils.DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	ESX.ServerCallbacks[requestId](...)
	ESX.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
	ESX.ShowNotification(msg)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	ESX.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg, thisFrame, beep, duration)
	ESX.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

-- SetTimeout
CreateThread(function()
	while true do
		Wait(0)
		local currTime = GetGameTimer()

		for i=1, #ESX.TimeoutCallbacks, 1 do
			if ESX.TimeoutCallbacks[i] then
				if currTime >= ESX.TimeoutCallbacks[i].time then
					ESX.TimeoutCallbacks[i].cb()
					ESX.TimeoutCallbacks[i] = nil
				end
			end
		end
	end
end)