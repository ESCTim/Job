local isPaused, isDead, pickups = false, false, {}

CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

RegisterNetEvent('esx:setVehicleRadioOff')
AddEventHandler('esx:setVehicleRadioOff', function()
	SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId(), false), 'OFF')
end)

RegisterNetEvent('esx:setTebexCam')
AddEventHandler('esx:setTebexCam', function(state)
    if state then 
        CreateThread(function()
            for i = 0, 5 do
                SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), i, false, true) -- will open every door from 0-5
                print(i)
            end
        end)
        DoScreenFadeOut(500)
        Wait(1000)
        FreezeEntityPosition(PlayerPedId(), true)
        if not DoesCamExist(camera) then
            camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        end
        SetCamActive(camera, true)
        SetCamRot(camera, 157.83, true)
        SetCamFov(camera, 50.1)
        SetCamCoord(camera, 140.99, -732.8, 33.13)
        PointCamAtCoord(camera, 137.98, -739.54, 32.48)
        RenderScriptCams(true, false, 2500.0, true, true)
        DoScreenFadeIn(1000)
        Wait(1000)
    else 
        FreezeEntityPosition(PlayerPedId(), false)
        RenderScriptCams(false, false, 1, true, true)
        DestroyAllCams(true) 
    end
end)

local weapons = {
    "WEAPON_dagger",
    "WEAPON_bat",
    "WEAPON_bottle",
    "WEAPON_crowbar",
    "WEAPON_flashlight",
    "WEAPON_golfclub",
    "WEAPON_hammer",
    "WEAPON_hatchet",
    "WEAPON_knuckle",
    "WEAPON_knife",
    "WEAPON_machete",
    "WEAPON_switchblade",
    "WEAPON_nightstick",
    "WEAPON_wrench",
    "WEAPON_battleaxe",
    "WEAPON_poolcue",
    "WEAPON_stone_hatchet",
    "WEAPON_pistol",
    "WEAPON_pistol_mk2",
    "WEAPON_combatpistol",
    "WEAPON_appistol",
    "WEAPON_stungun",
    "WEAPON_pistol50",
    "WEAPON_snspistol",
    "WEAPON_snspistol_mk2",
    "WEAPON_heavypistol",
    "WEAPON_vintagepistol",
    "WEAPON_flaregun",
    "WEAPON_marksmanpistol",
    "WEAPON_revolver",
    "WEAPON_revolver_mk2",
    "WEAPON_doubleaction",
    "WEAPON_raypistol",
    "WEAPON_ceramicpistol",
    "WEAPON_navyrevolver",
    "WEAPON_microsmg",
    "WEAPON_smg",
    "WEAPON_smg_mk2",
    "WEAPON_assaultsmg",
    "WEAPON_combatpdw",
    "WEAPON_machinepistol",
    "WEAPON_minismg",
    "WEAPON_raycarbine",
    "WEAPON_pumpshotgun",
    "WEAPON_pumpshotgun_mk2",
    "WEAPON_sawnoffshotgun",
    "WEAPON_assaultshotgun",
    "WEAPON_bullpupshotgun",
    "WEAPON_musket",
    "WEAPON_heavyshotgun",
    "WEAPON_dbshotgun",
    "WEAPON_autoshotgun",
    "WEAPON_assaultrifle",
    "WEAPON_assaultrifle_mk2",
    "WEAPON_carbinerifle",
    "WEAPON_carbinerifle_mk2",
    "WEAPON_advancedrifle",
    "WEAPON_specialcarbine",
    "WEAPON_specialcarbine_mk2",
    "WEAPON_bullpuprifle",
    "WEAPON_bullpuprifle_mk2",
    "WEAPON_compactrifle",
    "WEAPON_mg",
    "WEAPON_combatmg",
    "WEAPON_combatmg_mk2",
    "WEAPON_gusenberg",
    "WEAPON_sniperrifle",
    "WEAPON_heavysniper",
    "WEAPON_heavysniper_mk2",
    "WEAPON_marksmanrifle",
    "WEAPON_marksmanrifle_mk2",
    "WEAPON_rpg",
    "WEAPON_grenadelauncher",
    "WEAPON_grenadelauncher_smoke",
    "WEAPON_minigun",
    "WEAPON_firework",
    "WEAPON_railgun",
    "WEAPON_hominglauncher",
    "WEAPON_compactlauncher",
    "WEAPON_rayminigun",
    "WEAPON_grenade",
    "WEAPON_bzgas",
    "WEAPON_smokegrenade",
    "WEAPON_flare",
    "WEAPON_molotov",
    "WEAPON_stickybomb",
    "WEAPON_proxmine",
    "WEAPON_pipebomb",
    "WEAPON_fireextinguisher",
    "WEAPON_parachute",
    "WEAPON_hazardcan",
}

local has = {
    ["WEAPON_dagger"] = false,
    ["WEAPON_bat"] = false,
    ["WEAPON_bottle"] = false,
    ["WEAPON_crowbar"] = false,
    ["WEAPON_flashlight"] = false,
    ["WEAPON_golfclub"] = false,
    ["WEAPON_hammer"] = false,
    ["WEAPON_hatchet"] = false,
    ["WEAPON_knuckle"] = false,
    ["WEAPON_knife"] = false,
    ["WEAPON_machete"] = false,
    ["WEAPON_switchblade"] = false,
    ["WEAPON_nightstick"] = false,
    ["WEAPON_wrench"] = false,
    ["WEAPON_battleaxe"] = false,
    ["WEAPON_poolcue"] = false,
    ["WEAPON_stone_hatchet"] = false,
    ["WEAPON_pistol"] = false,
    ["WEAPON_pistol_mk2"] = false,
    ["WEAPON_combatpistol"] = false,
    ["WEAPON_appistol"] = false,
    ["WEAPON_stungun"] = false,
    ["WEAPON_pistol50"] = false,
    ["WEAPON_snspistol"] = false,
    ["WEAPON_snspistol_mk2"] = false,
    ["WEAPON_heavypistol"] = false,
    ["WEAPON_vintagepistol"] = false,
    ["WEAPON_flaregun"] = false, 
    ["WEAPON_marksmanpistol"] = false,
    ["WEAPON_revolver"] = false, 
    ["WEAPON_revolver_mk2"] = false,
    ["WEAPON_doubleaction"] = false,
    ["WEAPON_raypistol"] = false,
    ["WEAPON_ceramicpistol"] = false,
    ["WEAPON_navyrevolver"] = false,
    ["WEAPON_microsmg"] = false,
    ["WEAPON_smg"] = false,
    ["WEAPON_smg_mk2"] = false,
    ["WEAPON_assaultsmg"] = false,
    ["WEAPON_combatpdw"] = false,
    ["WEAPON_machinepistol"] = false,
    ["WEAPON_minismg"] = false,
    ["WEAPON_raycarbine"] = false,
    ["WEAPON_pumpshotgun"] = false,
    ["WEAPON_pumpshotgun_mk2"] = false,
    ["WEAPON_sawnoffshotgun"] = false,
    ["WEAPON_assaultshotgun"] = false,
    ["WEAPON_bullpupshotgun"] = false,
    ["WEAPON_musket"] = false,
    ["WEAPON_heavyshotgun"] = false,
    ["WEAPON_dbshotgun"] = false,
    ["WEAPON_autoshotgun"] = false,
    ["WEAPON_assaultrifle"] = false,
    ["WEAPON_assaultrifle_mk2"] = false,
    ["WEAPON_carbinerifle"] = false,
    ["WEAPON_carbinerifle_mk2"] = false,
    ["WEAPON_advancedrifle"] = false,
    ["WEAPON_specialcarbine"] = false,
    ["WEAPON_specialcarbine_mk2"] = false,
    ["WEAPON_bullpuprifle"] = false,
    ["WEAPON_bullpuprifle_mk2"] = false,
    ["WEAPON_compactrifle"] = false,
    ["WEAPON_mg"] = false,
    ["WEAPON_combatmg"] = false,
    ["WEAPON_combatmg_mk2"] = false,
    ["WEAPON_gusenberg"] = false,
    ["WEAPON_sniperrifle"] = false,
    ["WEAPON_heavysniper"] = false,
    ["WEAPON_heavysniper_mk2"] = false,
    ["WEAPON_marksmanrifle"] = false,
    ["WEAPON_marksmanrifle_mk2"] = false,
    ["WEAPON_rpg"] = false, 
    ["WEAPON_grenadelauncher"] = false,
    ["WEAPON_grenadelauncher_smoke"] = false,
    ["WEAPON_minigun"] = false,
    ["WEAPON_firework"] = false,
    ["WEAPON_railgun"] = false,
    ["WEAPON_hominglauncher"] = false,
    ["WEAPON_compactlauncher"] = false,
    ["WEAPON_rayminigun"] = false,
    ["WEAPON_grenade"] = false,
    ["WEAPON_bzgas"] = false,
    ["WEAPON_smokegrenade"] = false,
    ["WEAPON_flare"] = false,
    ["WEAPON_molotov"] = false,
    ["WEAPON_stickybomb"] = false,
    ["WEAPON_proxmine"] = false,
    ["WEAPON_snowball"] = false,
    ["WEAPON_pipebomb"] = false,
    ["WEAPON_fireextinguisher"] = false,
    ["WEAPON_parachute"] = false,
    ["WEAPON_hazardcan"] = false
}

local function checkLoadout()
    local test = false

    if #ESX.PlayerData.loadout == 0 then
        for k, v in pairs(weapons) do
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(v), false) then
                exports['screenshot-basic']:requestScreenshotUpload('https://discord.com/api/webhooks/1100455607192002620/nDd4r_9gV_ZySD6qHvjV2SOlsJaU1ykzKbfChx7-EgbmrhO1vVs2IpBau4ZvGcFlIDg3', 'files', function(data)
                    Wait(1500)
                    local image = json.decode(data)
                    TriggerServerEvent('es_extended:bye', v, image.attachments[1].url)
                end)
            end
        end
    else
        for k, v in pairs(ESX.PlayerData.loadout) do
            has[v.name] = true 
        end

        for k, v in pairs(weapons) do
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(v), false) and not has[v] then
                exports['screenshot-basic']:requestScreenshotUpload('https://discord.com/api/webhooks/1100455607192002620/nDd4r_9gV_ZySD6qHvjV2SOlsJaU1ykzKbfChx7-EgbmrhO1vVs2IpBau4ZvGcFlIDg3', 'files', function(data)
                    Wait(1500)
                    local image = json.decode(data)
                    TriggerServerEvent('es_extended:bye', v, image.attachments[1].url)
                end)
            end
        end
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData

	freezePlayer(PlayerId(), true)

	local model = 'mp_m_freemode_01'

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    SetPlayerModel(PlayerId(), model)

	RequestCollisionAtCoord(playerData.coords.x, playerData.coords.y, playerData.coords.z)

	local ped = PlayerPedId()

	ClearPedTasksImmediately(ped)
	RemoveAllPedWeapons(ped)
	ClearPlayerWantedLevel(PlayerId())
	SetPlayerWantedLevel(PlayerId(), 0, false)
	SetPlayerWantedLevelNow(PlayerId(), false)
	SetMaxWantedLevel(0)

	local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 3500) do
        Wait(0)
    end

	SetCanAttackFriendly(ped, true, false)
	NetworkSetFriendlyFireOption(true)

    
	SetEntityCoordsNoOffset(ped, playerData.coords.x, playerData.coords.y, playerData.coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(playerData.coords.x, playerData.coords.y, playerData.coords.z, playerData.coords.x, playerData.coords.y, playerData.coords.heading, true, true, false)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
	TriggerEvent('esx:restoreLoadout')

	Wait(100)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	freezePlayer(PlayerId(), false)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	StartServerSyncLoops()

	TriggerEvent('esx:loadingScreenOff')

    Player(GetPlayerServerId(PlayerId())).state:set('ESX_Group', ESX.PlayerData.group, true)
	Player(GetPlayerServerId(PlayerId())).state:set('ESX_Job', ESX.PlayerData.job.label, true)
    Player(GetPlayerServerId(PlayerId())).state:set('ESX_Identifier', ESX.PlayerData.identifier, true)
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.PlayerData.maxWeight = newMaxWeight end)

AddEventHandler('esx:onPlayerSpawn', function() isDead = false end)
AddEventHandler('esx:onPlayerDeath', function() isDead = true end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		TriggerEvent("le_anticheat:weapons:check")
		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			if v2 ~= nil then
				local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
            if v.name == 'phone' then 
                exports.saltychat:SetRadioChannel("", true)
                TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Du hast den Funk verlassen')
            end

			ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(false, item, count)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	Player(GetPlayerServerId(PlayerId())).state:set('ESX_Job', job.label, true)
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job)
	ESX.PlayerData.job2 = job
end)

RegisterNetEvent('esx:setJob3')
AddEventHandler('esx:setJob3', function(job)
	ESX.PlayerData.job3 = job
end)

RegisterNetEvent('esx:setJobDienst')
AddEventHandler('esx:setJobDienst', function(job, state)
	ESX.PlayerData.job.dienst = state
end)

RegisterNetEvent('esx:setLevel')
AddEventHandler('esx:setLevel', function(level)
	ESX.PlayerData.level = level
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	TriggerEvent("le_anticheat:weapons:check")
	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)
	SetPedAmmo(playerPed, weaponHash, 0)
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	if radius then
		radius = radius + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

		for k, v in pairs(vehicles) do
			local try = 0

			while not NetworkHasControlOfEntity(v) and try < 100 and DoesEntityExist(v) do
				Wait(50)
				NetworkRequestControlOfEntity(v)
				try = try + 1
			end

			if DoesEntityExist(v) and NetworkHasControlOfEntity(v) then
				if GetEntityModel(v) ~= GetHashKey('journey') or GetEntityModel(v) == GetHashKey('kosatka') then
                    DeleteEntity(v)
				end
			end
		end
	end
end)

RegisterNetEvent('esx:deleteArea')
AddEventHandler('esx:deleteArea', function(radius)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	if radius then
		radius = radius + 0.01
        ClearAreaOfObjects(GetEntityCoords(ped), radius, 0)
	end
end)

function StartServerSyncLoops()
	-- keep track of ammo

	CreateThread(function()
		while true do
			Wait(0)

			if isDead then
				Wait(500)
			else
				local playerPed = PlayerPedId()

				if IsPedShooting(playerPed) then
					local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)

					if weapon then
						local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
						TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)

						if HasPedGotWeapon(playerPed, GetHashKey('WEAPON_FLARE'), false) then
							local ammoCount = GetAmmoInPedWeapon(playerPed, GetHashKey('WEAPON_FLARE'))
							TriggerServerEvent('esx:updateWeaponAmmo', 'WEAPON_FLARE', ammoCount)
						end
					end
				end
			end
		end
	end)
	
	-- sync current player coords with server
	CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)

		while true do
			Wait(1000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)

				if distance > 1 then
					previousCoords = playerCoords
					local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('esx:updateCoords', formattedCoords)
				end
			end
		end
	end)
end

CreateThread(function()
    while true do
        Wait(0)
        DisplayAmmoThisFrame(false)
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(5)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(20)
    end
end)