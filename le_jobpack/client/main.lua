CurrentActionData, handcuffTimer, dragStatus, currentTask, trackedEntities = {}, {}, {}, {}, nil
HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService, show2 = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false
ESX = nil

local firstSpawn = true
local reviveTimer = 0
local stabil = false

local function isDeadNormal()
	return isDead
end

function isCuffed()
	return isHandcuffed
end

exports('isCuffed', isCuffed)

exports('isDead', isDeadNormal)

CreateThread(function()
	while ESX == nil do
		ESX = exports['es_extended']:getSharedObject()
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	while ESX.GetPlayerData().group == nil do
		Wait(10)
	end

	while ESX.GetPlayerData().revivetimer == nil do
		Wait(500)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	startThreads()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	CurrentAction = nil
	LastEntity = nil
	trackedEntities = nil
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJobDienst')
AddEventHandler('esx:setJobDienst', function(job, state)
	ESX.PlayerData.job.dienst = state
end)


CreateThread(function()
	for k, v in pairs(Config.Jobs) do
		if v.Blip.blip then
			local blip = AddBlipForCoord(v.Blip.Coords)

			SetBlipSprite(blip, v.Blip.Sprite)
			SetBlipDisplay(blip, v.Blip.Display)
			SetBlipScale(blip, v.Blip.Scale)
			SetBlipColour(blip, v.Blip.Colour)
			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(v.Blip.Text)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function startThreads()
	CreateThread(function()
		while true do
			Wait(0)
			local letSleep = true
			local isInMarker, hasExited = false, false
			local currentStation, currentPart, currentPartNum
	
			for k, v in pairs(Config.Jobs) do
				if ESX.PlayerData.job.name == k then
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)
	
					-- for k1, v1 in pairs(v.Cloakrooms) do
					-- 	local distance = #(coords - v1)
												
					-- 	if distance < 100.0 then
					-- 		letSleep = false
					-- 		DrawMarker(20, v1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
							
					-- 		if distance < 1.0 then
					-- 			isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', k1
					-- 		end
					-- 	end
					-- end
	
					for k1, v1 in pairs(v.Armories) do
						local distance = #(coords - v1)
						
						if distance < 25.0 then
							letSleep = false
							DrawMarker(21, v1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
							
							if distance < 1.0 then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', k1
							end
						end
					end
	
					for k1, v1 in pairs(v.Vehicles) do
						local distance = #(coords - v1.Spawner)
						
						if distance < 25.0 then
							letSleep = false
							DrawMarker(36, v1.Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
							
							if distance < 1.0 then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', k1
							end
						end
					end
	
					for k1, v1 in pairs(v.Helicopters) do
						local distance = #(coords - v1.Spawner)
						
						if distance < 25.0 then
							letSleep = false
							DrawMarker(34, v1.Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
							
							if distance < 1.0 then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', k1
							end
						end
					end

					for k1, v1 in pairs(v.Boats) do
						local distance = #(coords - v1.Spawner)
						
						if distance < 25.0 then
							letSleep = false
							DrawMarker(35, v1.Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
							
							if distance < 1.0 then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Boats', k1
							end
						end
					end
	
					if ESX.PlayerData.job.grade_name == 'boss' then
						for k1, v1 in pairs(v.BossActions) do
							local distance = #(coords - v1)
							
							if distance < 25.0 then
								letSleep = false
								DrawMarker(22, v1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 116, 251, 246, 155, false, true, 2, true, false, false, false)
								
								if distance < 1.0 then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', k1
								end
							end
						end
					end
				end
			end
	
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					hasExitedMarker(LastStation, LastPart, LastPartNum)
					hasExited = true
				end
	
				HasAlreadyEnteredMarker = true
				LastStation = currentStation
				LastPart = currentPart
				LastPartNum = currentPartNum
	
				hasEnteredMarker(currentStation, currentPart, currentPartNum)
			end
	
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				hasExitedMarker(LastStation, LastPart, LastPartNum)
			end
	
			if letSleep then
				Wait(1000)
			end
		end
	end)
	
	-- CreateThread(function()
	-- 	while true do
	-- 		local sleep = 500
	-- 		local ped = PlayerPedId()
	-- 		local coords = GetEntityCoords(ped)
	
	-- 		local closestDistance = -1
	-- 		local closestEntity = nil
	
	-- 		for k, v in pairs(Config.Jobs) do
	-- 			if ESX.PlayerData.job and ESX.PlayerData.job.name == k then
	-- 				if trackedEntities == nil then
	-- 					trackedEntities = {}
	
	-- 					for k1, v1 in pairs(v.ActionMenu.object_spawner.models) do
	-- 						table.insert(trackedEntities, {
	-- 							model = v1.model
	-- 						})
	-- 					end
	-- 				end
	
	-- 				for k1, v1 in pairs(trackedEntities) do
	-- 					local object = GetClosestObjectOfType(coords, 5.0, GetHashKey(v1.model), false, false, false)
	
	-- 					if DoesEntityExist(object) then
	-- 						local objectCoords = GetEntityCoords(object)
	-- 						local distance = #(coords - objectCoords)
	
	-- 						if closestDistance == -1 or closestDistance > distance then
	-- 							sleep = 0
	-- 							closestDistance = distance
	-- 							closestEntity = object
	-- 						end
	-- 					end
	-- 				end
	
	-- 				if closestDistance ~= -1 and closestDistance < 10.0 then
	-- 					sleep = 0
	-- 					if LastEntity ~= closestEntity then
	-- 						hasEnteredEntityZone(closestEntity)
	-- 						LastEntity = closestEntity
	-- 					end
	-- 				else
	-- 					if LastEntity then
	-- 						sleep = 0
	-- 						hasExitedEntityZone(LastEntity)
	-- 						LastEntity = nil
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 		Wait(sleep)
	-- 	end
	-- end)

	CreateThread(function()
		while true do
			Wait(0)
			local letSleep = true
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
	
			local closestDistance = -1
			local closestEntity = nil
	
			for k, v in pairs(Config.Jobs) do
				if ESX.PlayerData.job and ESX.PlayerData.job.name == k then
					if trackedEntities == nil then
						trackedEntities = {}
	
						for k1, v1 in pairs(v.ActionMenu.object_spawner.models) do
							table.insert(trackedEntities, {
								model = v1.model
							})
						end
					end
	
					for k1, v1 in pairs(trackedEntities) do
						local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(v1.model), false, false, false)
	
						if DoesEntityExist(object) then
							local objectCoords = GetEntityCoords(object)
							local distance = #(coords - objectCoords)
	
							if closestDistance == -1 or closestDistance > distance then
								closestDistance = distance
								closestEntity = object
							end
						end
					end
	
					if closestDistance ~= -1 and closestDistance < 3.0 then
						if LastEntity ~= closestEntity then
							hasEnteredEntityZone(closestEntity)
							LastEntity = closestEntity
						end
					else
						if LastEntity then
							hasExitedEntityZone(LastEntity)
							LastEntity = nil
						end
					end
				end
			end
	
			if letSleep then
				Wait(500)
			end
		end
	end)
	
	CreateThread(function()
		local show = true
		local sleep = 0
		while true do
			Wait(sleep)
			
			if CurrentAction then
				for k, v in pairs(Config.Jobs) do
					if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == k then

						-- print('E', CurrentAction)

						if CurrentAction == 'menu_cloakroom' then
							OpenCloakroomMenu(CurrentActionData.station)
						elseif CurrentAction == 'menu_armory' then
							OpenArmoryMenu(CurrentActionData.station)
						elseif CurrentAction == 'menu_vehicle_spawner' then
							OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
						elseif CurrentAction == 'menu_helicopter_spawner' then
							OpenVehicleSpawnerMenu('heli', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
						elseif CurrentAction == 'menu_boats_spawner' then
							OpenVehicleSpawnerMenu('boat', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
						elseif CurrentAction == 'remove_entity' then
							DeleteEntity(LastEntity)
						elseif CurrentAction == 'menu_boss_actions' then
							ESX.UI.Menu.CloseAll()
							
							TriggerEvent('le_core:society:openBossMenu', ESX.PlayerData.job.name, false, function(data, menu)
								menu.close()
		
								CurrentAction = 'menu_boss_actions'
								CurrentActionMsg = "Drücke E um das Menü zu öffnen"
								CurrentActionData = {}
							end)
						end
					end
				end
			end
	
			if IsControlJustReleased(0, 167) then
				for k, v in pairs(Config.Jobs) do
					if ESX.PlayerData.job and ESX.PlayerData.job.name == k then
						if ESX.PlayerData.job.name == 'lspd' or ESX.PlayerData.job.name == 'fib' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'lsmd' or ESX.PlayerData.job.name == 'doj' or ESX.PlayerData.job.name == 'taxi' or ESX.PlayerData.job3.name == 'lsmd' then
							-- if ESX.PlayerData.job.dienst then
								OpenActionsMenu()
							-- else
							-- 	TriggerEvent('le_core:hud:notify', 'info', ESX.PlayerData.job.label, 'Du bist derzeit nicht im Dienst!')
							-- end
						else
							OpenActionsMenu()
						end
					end
				end
			end
	
			if IsControlJustReleased(0, 38) and currentTask.busy then
				TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Du hast das Beschlagnahmen gestoppt!')
				currentTask.task = false
				ClearPedTasks(PlayerPedId())
	
				currentTask.busy = false
			end

			if not show and CurrentAction then
				exports['le_core']:showHelpNotification(CurrentActionMsg, 'E')
				show = true
			elseif show and not CurrentAction then
				exports['le_core']:closeHelpNotification()
				show = false
			end
		end
	end)

	RegisterCommand('wheelchair', function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)

		if ESX.PlayerData.job.name == 'lsmd' and ESX.PlayerData.job.grade >= 5 then 
			ESX.Game.SpawnVehicle('iak_wheelchair', coords, heading, function(vehicle)
				veh = vehicle
				TaskWarpPedIntoVehicle(ped, vehicle, -1)
			end)
		else 
			TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du bist kein Mediziner')
		end
	end)
	
	RegisterCommand('removewheelchair', function()
		local vehicle = ESX.Game.GetClosestVehicle()

		if ESX.PlayerData.job.name == 'lsmd' then 
			
			ESX.Game.DeleteVehicle(vehicle)
		else 
			TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du bist kein Mediziner')
		end
	end)

	LoadModel = function(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			
			Wait(1)
		end
	end

	local function DrawText3D(x, y, z, text, scale)
		local onScreen, _x, _y = World3dToScreen2d(x, y, z)
		local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	   
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextEntry("STRING")
		SetTextCentre(1)
		SetTextColour(255, 255, 255, 215)
	   
		AddTextComponentString(text)
		DrawText(_x, _y)
	end

	local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466, -1951375401 }
	local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
	local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 2017895192, -494615257, -1654528753, 1075685676, 1076751822, 771403250, 1045183535, 879347409, 1746263880, 619010992 }
	local LargeBullet = { -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 736523883, 2144741730, 487013001, 100416529, 205991906, 1119849093, -1063057011 }
	local Animal = { -100946242, 148160082 }
	local FallDamage = { -842959696 }
	local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
	local Gas = { -1600701090 }
	local Burn = { 615608432, 883325847, -544306709 }
	local Drown = { -10959621, 1936677264 }
	local Car = { 133987706, -1553120962 }
	  
	local function checkArray(array, value)
		for k, v in ipairs(array) do
			if v == value then
				return true
			end
		end

		return false
	end

	local function loadAnimDict(dict, cb)
		while not HasAnimDictLoaded(dict) do
			RequestAnimDict(dict)
			Wait(50)
		end
	end

	local function Start(ped)
		local checking = true

		while checking do
			Wait(2)
			local playerPed = PlayerPedId()
			local coords2 = GetEntityCoords(ped)
			local distance = #(GetEntityCoords(playerPed) - coords2)

			if distance < 2.0 then
				DrawText3D(coords2.x, coords2.y, coords2.z, 'Drücke E um die Todesursachen zu überprüfen', 0.4)

				if IsControlJustPressed(0, 38) then
					local dead = GetPedCauseOfDeath(ped)
					
					loadAnimDict('amb@medic@standing@kneel@base')
					loadAnimDict('anim@gangops@facility@servers@bodysearch@')

					TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
					TaskPlayAnim(playerPed, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false)
			  
					Wait(5000)

					ClearPedTasksImmediately(playerPed)

					if checkArray(Melee, dead) then
						Notify('Wahrscheinlich von etwas Hartem am Kopf getroffen')
					elseif checkArray(Bullet, dead) then
						Notify('Wahrscheinlich von einer Kugel angeschossen, Einschusslöcher im Körper (Handwaffe)')
					elseif checkArray(LargeBullet, dead) then
						Notify('Wahrscheinlich von einer Kugel angeschossen, Einschusslöcher im Körper (Langwaffe)')
					elseif checkArray(Knife, dead) then
						Notify('Wahrscheinlich von etwas Scharfem erstochen')
					elseif checkArray(Animal, dead) then
						Notify('Wahrscheinlich von einem Tier gebissen')
					elseif checkArray(FallDamage, dead) then
						Notify('Wahrscheinlich gestürzt, beide Beine gebrochen')
					elseif checkArray(Explosion, dead) then
						Notify('Wahrscheinlich durch etwas gestorben, das explodiert ist')
					elseif checkArray(Gas, dead) then
						Notify('Vermutlich an Gasschäden in der Lunge gestorben')
					elseif checkArray(Burn, dead) then
						Notify('Vermutlich durch das Gas in einem Feuerlöscher gestorben')
					elseif checkArray(Drown, dead) then
						Notify('Wahrscheinlich ertrunken')
					elseif checkArray(Car, dead) then
						Notify('Vermutlich bei einem Autounfall ums Leben gekommen')
					else
						Notify('Todesursache unbekannt')
					end
				end
			end

			if distance > 7.5 or not IsPedDeadOrDying(ped) then
				checking = false
			end
		end
	end

	CreateThread(function()
        local status, error = pcall(function()
            while true do
                local sleep = 3000
    
                if ESX.PlayerData.job.name == 'lsmd' then
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then
                        local player, distance = ESX.Game.GetClosestPlayer()
    
                        if player ~= -1 and distance < 10.0 then
                            if player ~= -1 and distance <= 2.0 then
                                if IsPedDeadOrDying(GetPlayerPed(player)) then
                                    Start(GetPlayerPed(player))
                                end
                            end
                        else
                            sleep = sleep / 100 * distance
                        end
                    end
                end
    
                Wait(sleep)
            end
        end)

        if not status then
            -- print(error)
        end
	end)
end
-- NICHT BEWEGEN START --
local nichtbewegen = false

CreateThread(function()
	while true do
		local sleep = 500
		
		if nichtbewegen then
			sleep = 0
			TriggerEvent('le:oger')
			DisableAllControlActions(0)
			EnableControlAction(0, 1, uiHasFocus)
			EnableControlAction(0, 2, uiHasFocus)
		end
		Wait(sleep)
	end
end)
-- NICHT BEWEGEN ENDE --

-- STUNGUN ANIMATION START --
local timeOfStunned = 4000
local isStunned = false

RegisterCommand('stopstungun', function()
	if ESX.GetPlayerData().group == 'pl' then
		SetTimecycleModifier()
		SetTransitionTimecycleModifier()
		StopGameplayCamShaking()	
		ClearPedTasks(PlayerPedId())
		nichtbewegen = false
		isStunned = false
	end
end)

CreateThread(function()
	while true do
		local sleep = 500
		
		if IsPedBeingStunned(PlayerPedId()) then
			sleep = 0
			nichtbewegen = true
			FreezeEntityPosition(PlayerPedId(), true)
			SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
		end
		if IsPedBeingStunned(PlayerPedId()) and not isStunned then
			sleep = 0
			nichtbewegen = true
			isStunned = true
			SetTimecycleModifier('REDMIST_blend')
			ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE', 1.0)
			FreezeEntityPosition(PlayerPedId(), true)
		elseif not IsPedBeingStunned(PlayerPedId()) and isStunned then
			sleep = 0
			isStunned = false
			Wait(5000)
			SetTimecycleModifier('hud_def_desat_Trevor')
			Wait(1000)
			ExecuteCommand('e sit')
			TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Du wurdest getasert. Ruhe dich etwas aus!')
			Wait(45000)
			nichtbewegen = false
			FreezeEntityPosition(PlayerPedId(), false)
			SetTimecycleModifier()
			SetTransitionTimecycleModifier()
			StopGameplayCamShaking()
			TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Achte auf deine Gesundheit und ruhe dich etwas aus.')
			Wait(1000)
			ClearPedTasks(PlayerPedId())
		end
		Wait(sleep)
	end
end)

-- STUNGUN ANIMATION ENDE --

-- WAX Start -- 
RegisterNetEvent('le_core:items:wax')
AddEventHandler('le_core:items:wax', function()
	local coords = GetEntityCoords(PlayerPedId())
	local vehicleNear = IsAnyVehicleNearPoint(coords, 2.0)
	
	if not vehicleNear and not IsPedInAnyVehicle(PlayerPedId()) then
		return
	else
		while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            if not IsPedInAnyVehicle(ped) then
                if IsAnyVehicleNearPoint(coords, 2.0) then 
                    local closestveh = GetClosestVehicle(coords, 2.0, 0, 231807)
                    
                    if closestveh == 0 then 
                        closestveh = GetClosestVehicle(coords, 2.0, 0, 391551)
                    end
                    
                    if closestveh~=0 then
                        local plate = GetVehicleNumberPlateText(closestveh)
                    
                        nichtbewegen = true
                        ExecuteCommand('e clean2')
                        exports['le_core']:startProgressbar(10)
                        Wait(10000)
                        ExecuteCommand('e me')
                        ClearPedTasks(ped)
                        TriggerEvent('finishWachs', closestveh, plate)
                        nichtbewegen = false
                        return
                    end
                end
            end
            Wait(sleep)
        end
	end
end)

RegisterNetEvent('finishWachs')
AddEventHandler('finishWachs', function(closestveh, plate)
	while true do
		local sleep = 20000
		
		if closestveh and plate then
			SetVehicleDirtLevel(closestveh, 0.0)
		end
		Wait(sleep)
	end
end)

-- AMBULANCE

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
	-- print('player spawning')
	isDead = false

	if firstSpawn then
		-- print('first spawning')
		firstSpawn = false

		while not ESX.PlayerLoaded do
			Wait(1000)
			-- print('esx still not loaded')
		end

		-- print('esx loaded')

		Wait(5000)

		ESX.TriggerServerCallback('le_jobpack:getDeathStatus', function(shouldDie)
			if shouldDie then
				Wait(2500)
				SetEntityHealth(PlayerPedId(), 0)
				--OnPlayerDeath()
				--RemoveItemsAfterRPDeath()
			else
				reviveTimer = ESX.PlayerData.revivetimer
			end
		end)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	ESX.TriggerServerCallback('le_jobpack:checkDim', function(dimension)
		if dimension == 0 and not exports['le_gangwar']:isInGangwar() then
			print('death')
			OnPlayerDeath()
		end
	end)
end)

--[[
	{"modVanityPlate":-1,"modRearBumper":-1,"modTyresBurst":1,"modGrille":-1,"modLivery":-1,"color3":[5,5,5],"modXenon":true,"modRoof":-1,"modSpeakers":-1,"modTank":-1,"dirtLevel":2.3,"modTrimA":-1,"modBackWheels":-1,"drift":false,"wheelColor":156,"paintType":[6,6],"modWindows":-1,"model":-1644123084,"modArmor":-1,"modTrunk":-1,"modAirFilter":-1,"ColorType":[-1,-1],"dshcolor":156,"modSeats":-1,"color4":[5,5,5],"modSuspension":-1,"modOrnaments":-1,"modSpoilers":-1,"color1":12,"modStruts":-1,"modTrimB":-1,"modSmokeEnabled":false,"modHood":-1,"modWheelVariat":false,"pearlescentColor":0,"modFrontWheels":-1,"modSteeringWheel":-1,"modEngineBlock":-1,"modBrakes":-1,"modExhaust":-1,"modEngine":-1,"modDoorSpeaker":-1,"modShifterLeavers":-1,"engineHealth":988.5,"modRightFender":-1,"modFrontBumper":-1,"modHydrolic":-1,"neonEnabled":[false,false,false,false],"modDial":-1,"modLivery2":-1,"modHorns":-1,"windowTint":1,"modSideSkirt":-1,"modAerials":-1,"modTransmission":-1,"modDashboard":-1,"fuelLevel":62.3,"modFrame":-1,"modAPlate":-1,"plateIndex":1,"modFender":-1,"xenonColor":8,"modPlateHolder":-1,"bodyHealth":986.3,"extras":{"11":false,"2":true},"modArchCover":-1,"color2":12,"plate":"TH1CC","wheels":7,"intcolor":48,"modTurbo":false,"tyreSmokeColor":[255,255,255],"neonColor":[255,0,255]}
]]

local isDeadLoL = false

-- REVIVE TRIGGER
CreateThread(function()
	while true do
		local random = math.random(60000, 120000)
		Wait(random)
		TriggerServerEvent('le_jobpack:revivePlayer', reviveTimer, isDead, true, false, false, true, 'ooga_cringelord')
	end
end)

CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		Wait(sleep)
		if reviveTimer >= 1 then
			reviveTimer = reviveTimer - 1
			if not show2 then
				show2 = true
				SendNUIMessage({
					action = 'kampf',
					kampf = true
				})
			end

			local m, s = secondsToClock(reviveTimer)

			SendNUIMessage({
				action = 'updateTime',
				time = m .. ':' .. s
			})
		else
			if show2 then
				show2 = false
				SendNUIMessage({
					action = 'kampf',
					kampf = false
				})
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(200)
		local ped = PlayerPedId()
		if reviveTimer >= 1 and not exports['le_ffa']:isInZone() and not exports['le_gangwar']:isInGangwar() then
			if GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED') then
				SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		
		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)		-- Mausbewegung Oben/Unten     
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
			EnableControlAction(0, 244, true) --Y
			EnableControlAction(0, 304, true) --H
			EnableControlAction(0, 253, true) --C
			EnableControlAction(0, 104, true)
			TriggerEvent('le:oger')
		else
			Wait(500)
		end
	end
end)

function StartDistressSignal()
	CreateThread(function()
		local timer = 10 * 60000

		SendNUIMessage({
			action = 'syncshit'
		})

		while timer > 0 and isDead do
			Wait(2)
			timer = timer - 30

			if IsControlPressed(0, 244) then -- M
				SendNUIMessage({
					action = 'pressedsync'
				})

				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
				FreezeEntityPosition(PlayerPedId(), true)
				Wait(200)
				FreezeEntityPosition(PlayerPedId(), false)
				ClearPedTasksImmediately(PlayerPedId())

				CreateThread(function()
					Wait(30000)
					if isDead then
						StartDistressSignal()
					end
				end)
				break
			end
		end
	end)
end

function SendDistressSignal()

	CreateThread(function()
		local timer = 10 * 60000

		SendNUIMessage({
			action = 'medicshit'
		})

		while timer > 0 and isDead do 
			Wait(2)
			timer = timer - 30

			if IsControlPressed(0, 104) then
				SendNUIMessage({
					action = 'pressedmedic'
				})

				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local position = {x = coords.x, y = coords.y, z = coords.z}
			
				TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Dispatch wurde gesendet')
				exports["lb-phone"]:SendCompanyMessage('ambulance', 'Bewustlose Person braucht Hilfe', false)
				exports["lb-phone"]:SendCompanyCoords('ambulance', coords, false)
				break
			end
		end
	end)
end

function OnPlayerDeath()
	TriggerServerEvent('le_jobpack:setDeathStatus', true)
	isDead = true
	ESX.UI.Menu.CloseAll()

	if not exports['le_gangwar']:isInGangwar() then
		exports['saltychat']:SetRadioChannel('', true)
	end

	TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Du hast den Funk verlassen')

	StartDeathTimer()
	StartDistressSignal()
	SendDistressSignal()

	-- StartScreenEffect('DeathFailOut', 0, false)

	Wait(500)

	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
end

function DrawBetterText()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
	SetTextCentre(true)
end

local earlySpawnTimer, bleedoutTimer = 0, 0

RegisterNetEvent('le_jobpack:mehr', function()
	if earlySpawnTimer > 0 then
		earlySpawnTimer = earlySpawnTimer + (60 * 20)
		stabil = true
	-- else
	-- 	bleedoutTimer = bleedoutTimer + (60 * 15)
	end
end)

function StartDeathTimer()
	local canPayFine = false

	earlySpawnTimer = ESX.Math.Round(15 * 60000 / 1000)
	bleedoutTimer = ESX.Math.Round(25 * 60000 / 1000)

	CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		-- while bleedoutTimer > 0 and isDead do
		-- 	Wait(1000)

		-- 	if bleedoutTimer > 0 then
		-- 		bleedoutTimer = bleedoutTimer - 1
		-- 	end
		-- end
	end)

	SendNUIMessage({
		action = 'show'
	})

	CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(0)
			local minutes, seconds = secondsToClock(earlySpawnTimer)
			SendNUIMessage({
				action = 'timer',
				minutes = minutes,
				seconds = seconds
			})

			if stabil then 
				DrawBetterText()
				BeginTextCommandDisplayText('STRING')
				AddTextComponentSubstringPlayerName('Du wurdest ~p~stabilisiert ~s~ und kannst nun wieder reden \n ~r~ Du bist verwundet ~s~')
				EndTextCommandDisplayText(0.5, 0.9)
			end
		end

		-- bleedout timer
		-- while bleedoutTimer > 0 and isDead do
		-- 	Wait(0)
		-- 	local minutes, seconds = secondsToClock(bleedoutTimer)
			
		-- 	SendNUIMessage({
		-- 		action = 'bottomShow',
		-- 	})
			
		-- 	SendNUIMessage({
		-- 		action = 'timer',
		-- 		minutes = minutes,
		-- 		seconds = seconds
		-- 	})

		-- 	SendNUIMessage({
		-- 		action = 'textEa',
		-- 	})
			
		-- 	if IsControlPressed(0, 38) and timeHeld > 60 then
		-- 		RemoveItemsAfterRPDeath()
		-- 		break
		-- 	end

		-- 	if IsControlPressed(0, 38) then
		-- 		timeHeld = timeHeld + 1
		-- 	else
		-- 		timeHeld = 0
		-- 	end
		-- end

		if earlySpawnTimer < 1 and isDead then
			stabil = false
			RemoveItemsAfterRPDeath()
		end
	end)
end

RegisterNetEvent('le_jobpack:killPlayer')
AddEventHandler('le_jobpack:killPlayer', function()
	Wait(20000)
	RemoveItemsAfterRPDeath()
end)

function RemoveItemsAfterRPDeath()
	SendNUIMessage({
		action = 'hide'
	})

	if not (ESX.PlayerData.job.name == "lsmd" or ESX.PlayerData.job.name == "lspd" or ESX.PlayerData.job.name == "fib") then
		local test = 60 * 16
		if reviveTimer >= 901 then
			--
		else
			reviveTimer = 900
		end
		TriggerServerEvent('le_jobpack:revivePlayer', reviveTimer, isDead, true, false, false, true, 'ooga_cringelord')
	end

	TriggerServerEvent('essenTrinkenFull')

	CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Wait(10)
		end

		ESX.TriggerServerCallback('le_jobpack:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = 357.82,
				y = -590.72,
				z = 28.79
			}

			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), formattedCoords, 264.5)

			SetEntityCoords(PlayerPedId(), 357.82, -590.72, 28.79, true, false, false, false)

			-- StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)

			TriggerServerEvent('le_jobpack:setDeathStatus', false)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	IsDead = false
	ClearPedBloodDamage(ped)
	DisplayRadar(true)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
	ClearPedTasksImmediately(PlayerPedId())
	ClearPedTasks(PlayerPedId())
	ESX.UI.Menu.CloseAll()

	Wait(500)
	
	SetEntityCoords(ped, coords.x, coords.y, coords.z - 1)
	SetEntityHeading(ped, heading)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
	TriggerEvent('esx:onPlayerReviveshit')

	TriggerEvent('huren:enableControl')
end

RegisterNetEvent('le_jobpack:resettimer')
AddEventHandler('le_jobpack:resettimer', function()
	if reviveTimer >= 901 then
	else
		reviveTimer = 0
	end
end)

RegisterNetEvent('le_jobpack:revive')
AddEventHandler('le_jobpack:revive', function(admin, pdw)
	stabil = false
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('le_jobpack:setDeathStatus', false)

	if not admin and not exports['le_gangwar']:isInGangwar() then -- ffa waffe ziehen + kein timer
		local test = 60 * 16
		if reviveTimer >= 901 then
			--
		elseif pdw then
			reviveTimer = 120
		else
			reviveTimer = 900
		end
		TriggerServerEvent('le_jobpack:revivePlayer', reviveTimer, isDead, true, false, false, true, 'ooga_cringelord')
	end

	SendNUIMessage({
		action = 'hide'
	})

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	-- ESX.SetPlayerData('lastPosition', formattedCoords)
		
	TriggerServerEvent('esx:updateLastPosition', formattedCoords)

	RespawnPed(playerPed, formattedCoords, 0.0, 200)

	-- StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)

	TriggerEvent('huren:enableControl')
	-- TriggerEvent('esx:onPlayerReviveshit')
end)

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

-- Todesursache Anfang

local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 171789620, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }

function checkArray (array, val)
  for name, value in ipairs(array) do
    if value == val then
      return true
    end
  end

  return false
end

RegisterNetEvent("esx:setJob", function(job)
  ESX.PlayerData.job = job
end)

CreateThread(function()
  while ESX == nil do
    Wait(100)
  end

  ESX.PlayerData = ESX.GetPlayerData()

  Wait(1000)

  while true do
    local sleep = 3000
    if ESX.PlayerData.job and (ESX.PlayerData.job.name == "lsmd") then
      if vehicle == 0 then

        local player, distance = ESX.Game.GetClosestPlayer()

        if distance ~= -1 and distance < 10.0 then
          if distance ~= -1 and distance <= 2.0 then	
            if IsPedDeadOrDying(GetPlayerPed(player)) then
              Start(GetPlayerPed(player))
            end
          end

        else
          sleep = sleep / 100 * distance 
        end

      
      end
    elseif checking then
      checking = false
    end

    Wait(sleep)

  end
end)

-- function Start(ped)
--   checking = true

--   while checking do
-- 		Wait(2)
-- 		local coords2 = GetEntityCoords(ped)
-- 		local distance = #(coords - coords2)

-- 		local x,y,z = table.unpack(coords2)

-- 		if distance < 2.0 then
-- 		DrawText3D(x,y,z, 'Drücke E um die Todesursachen zu überprüfen', 0.4)
		
-- 		if IsControlPressed(0, 38) then
-- 			OpenDeathMenu(ped)
-- 		end
-- 		end

-- 		if distance > 7.5 or not IsPedDeadOrDying(ped) then
-- 		checking = false
-- 		end
-- 	end
-- end

function Notification(x,y,z)
  local timestamp = GetGameTimer()

  while (timestamp + 4500) > GetGameTimer() do
    Wait(0)
    DrawText3D(x, y, z, 'Der Schaden scheint hier zu passieren.', 0.4)
    checking = false
  end
end

function OpenDeathMenu(player)

  loadAnimDict('amb@medic@standing@kneel@base')
  loadAnimDict('anim@gangops@facility@servers@bodysearch@')

  local elements   = {}

  table.insert(elements, {label = 'Verletzungsmuster feststellen', value = 'deathcause'})


  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'dead_citizen',
    {
      title    = 'Wähle eine Option',
      align    = 'right',
      elements = elements,
    },
  function(data, menu)
    local ac = data.current.value

    if ac == 'damage' then

      local bone
      local success = GetPedLastDamageBone(player,bone)

      local success,bone = GetPedLastDamageBone(player)
      if success then
        local x,y,z = table.unpack(GetPedBoneCoords(player, bone))
        Notification(x,y,z)
      
      else
        Notify('Der entstandene Schaden konnte nicht identifiziert werden')
      end
    end

    if ac == 'deathcause' then
      --gets deathcause
      local d = GetPedCauseOfDeath(player)		
      local playerPed = ped

      --starts animation

      TaskPlayAnim(ped, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
      TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

      Wait(5000)

      --exits animation			

      ClearPedTasksImmediately(playerPed)

      if checkArray(Melee, d) then
        Notify(('Scheinbar von etwas am Kopf getroffen'))
      elseif checkArray(Bullet, d) then
        Notify(('Ballistische Schusswunden im Torso'))
      elseif checkArray(Knife, d) then
        Notify(('Tiefe Schnittwunde'))
      elseif checkArray(Animal, d) then
        Notify(('Wahrscheinlich von einem Tier gebissen'))
      elseif checkArray(FallDamage, d) then
        Notify(('Prellungen und Schürfwunden am Unterkörper, durch Sturz oder Fall'))
      elseif checkArray(Explosion, d) then
        Notify(('Explosion im nahen Umkreis, vermehrte Verbrennungen'))
      elseif checkArray(Gas, d) then
        Notify(('Gasschäden im Bereich der Lunge'))
      elseif checkArray(Burn, d) then
        Notify(('Übermäßig starke Verbrennungen am ganzen Körper'))
      elseif checkArray(Drown, d) then
        Notify(('Wasser im Bereich der Lunge'))
      elseif checkArray(Car, d) then
        Notify(('Von einem Fahrzeug angefahren'))
      else
        Notify(('Verletzungsmuster unbekannt'))
      end
    end


  end,
  function(data, menu)
  menu.close()
  end
)
end

function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
    RequestAnimDict(dict)
    
    Wait(1)
  end
end

function Notify(message)
	TriggerEvent('le_core:hud:notify', 'success', 'Jobs', message)
end

function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 215)
 
  AddTextComponentString(text)
  DrawText(_x, _y)
 
end

-- Todesursache Ende

--

function OpenCloakroomMenu(station)
	local elements = {
		{ label = 'Gespeicherte Kleidung', value = 'saved_cloth' }
	}

	local uniforms = Config.Jobs[ESX.PlayerData.job.name].Uniforms

	if uniforms then
		table.insert(elements, {
			label = 'Job Kleidung',
			value = 'job_cloth'
		})
	end

	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = 'Waffenkammer',
        align = 'top-left',
        elements = elements
    }, function(data, menu)

        if data.current.value == 'job_cloth' then
			local elements = {
				{ label = 'Zivi Kleidung', value = 1 }
			}

			for k, v in pairs(uniforms) do
				table.insert(elements, {
					label = v.name,
					value = k
				})
			end

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "uniform_dressing", {
                title = 'Kleiderschrank',
                align = "top-left",
                elements = elements
            }, function(data2, menu2)
				if data2.current.value == 1 then
					ESX.TriggerServerCallback('le_core:skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				else
					local uniform = Config.Jobs[ESX.PlayerData.job.name].Uniforms[data2.current.value].skin

					ESX.TriggerServerCallback('le_core:skin:getPlayerSkin', function(skin, jobSkin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, uniform['male'])
						elseif skin.sex == 1 then
						end
					end)
				end
            end, function(data2, menu2)
                menu2.close()
            end)
		end

    end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = "Drücke E um dich umzuziehen"
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local options = Config.Jobs[ESX.PlayerData.job.name]

    local elements = {}

	if options.AuthorizedWeapons.enable then
		table.insert(elements, {
            label = 'Waffen kaufen',
            value = 'buy_weapons'
        })
	end

	if options.AuthorizedItems.enable then
		table.insert(elements, {
            label = 'Items Kaufen',
            value = 'buy_items'
        })
	end

	if ESX.PlayerData.job.name ~= 'lsmd' and ESX.PlayerData.job.name ~= 'mechanic' then
		if ESX.PlayerData.job.grade >= options.permissions.get_weapon then
			table.insert(elements, {
				label = 'Waffen holen',
				value = 'get_weapon'
			})
		end
	end

	if ESX.PlayerData.job.name ~= 'lsmd' and ESX.PlayerData.job.name ~= 'mechanic' then
		table.insert(elements, {
			label = 'Waffen Bringen',
			value = 'put_weapon'
		})
	end

    if ESX.PlayerData.job.grade >= options.permissions.get_object then
        table.insert(elements, {
            label = 'Objekt nehmen',
            value = 'get_stock'
        })
    end

    table.insert(elements, {
        label = 'Objekt hinterlegen',
        value = 'put_stock'
    })

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = 'Waffenkammer',
        align = 'top-left',
        elements = elements
    }, function(data, menu)

        if data.current.value == 'buy_weapons' then
            OpenBuyWeaponsMenu()
        elseif data.current.value == 'buy_items' then
            OpenBuyItemsMenu()
        elseif data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

    end, function(data, menu)
		menu.close()

		CurrentAction = 'menu_armory'
		CurrentActionMsg = "Drücke E um die Waffenkammer zu öffnen"
		CurrentActionData = {station = station}
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
        title = 'Weapon Components',
        align = 'top-left',
        elements = components
    }, function(data, menu)
        if data.current.hasComponent then
			TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du hast schon diesen Aufsatz')
        else
			TriggerServerEvent('le_jobpack:buyWeapon', weaponName, 2, data.current.componentNum)

			SetTimeout(150, function()
				menu.close()
				parentShop.close()
				OpenBuyWeaponsMenu()
			end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()

	for k, v in ipairs(Config.Jobs[ESX.PlayerData.job.name].AuthorizedWeapons[ESX.PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, "im Besitz")
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, ESX.Math.GroupDigits(v.components[i]) .. "$")
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, "Gratis")
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, "im Besitz")
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, ESX.Math.GroupDigits(v.price) .. "$")
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, "Gratis")
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title = "Waffe kaufen",
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			TriggerServerEvent('le_jobpack:buyWeapon', data.current.name, 1)
			SetTimeout(150, function()
				OpenBuyWeaponsMenu()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyItemsMenu()
	local elements = {}
	local playerPed = PlayerPedId()

	for k,v in ipairs(Config.Jobs[ESX.PlayerData.job.name].AuthorizedItems[ESX.PlayerData.job.grade_name]) do
		table.insert(elements, {
			item = v.item,
			label = v.label .. ': <span style="color: green;">' .. v.price .. '$</span>',
			type = 'slider',
			value = 1,
			min = 1,
			max = 100
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_items', {
		title = "Gegenstand kaufen",
		align = 'top-left',
		elements = elements
	}, function(data, menu)
	    print('le_jobpack:buyItem', data.current.item, data.current.value)
		TriggerServerEvent('le_jobpack:buyItem', data.current.item, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetWeaponMenu()
    ESX.TriggerServerCallback('le_jobpack:getArmoryWeapons', function(weapons)
        local elements = {}

        for i=1, #weapons, 1 do
            if weapons[i] ~= nil then
                if weapons[i].ammo ~= nil and weapons[i].name ~= nil then
                    if weapons[i].ammo > 0 then
                        table.insert(elements, {
                            label = ESX.GetWeaponLabel(weapons[i].name) .. ' mit ' .. weapons[i].ammo .. 'x Schuss',
                            value = weapons[i].name,
                            ammo = weapons[i].ammo
                        })
                    end
                end
            end
        end

        table.sort(elements, function(a, b)
            return a.label < b.label
        end)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title = "Waffe nehmen",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			RequestAnimDict("anim@mp_snowball")
			while not HasAnimDictLoaded("anim@mp_snowball") do
				Wait(100)
			end
			TaskPlayAnim(PlayerPedId(), "anim@mp_snowball", "pickup_snowball", 8.0, -8.0, 5000, 0, 0)

            TriggerServerEvent('le_jobpack:removeArmoryWeapon', data.current.value, data.current.ammo)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {
				label = weaponList[i].label .. ' mit ' .. ammoCount .. ' Schuss',
				value = weaponList[i].name,
				ammo = ammoCount
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = "Waffe einlagern",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		RequestAnimDict("anim@mp_snowball")
		while not HasAnimDictLoaded("anim@mp_snowball") do
			Wait(100)
		end
		TaskPlayAnim(PlayerPedId(), "anim@mp_snowball", "pickup_snowball", 8.0, -8.0, 5000, 0, 0)

        TriggerServerEvent('le_jobpack:addArmoryWeapon', data.current.value, data.current.ammo)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('le_jobpack:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = "Lager",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = "Menge"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Ungültige Menge')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('le_jobpack:getStockItem', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('le_jobpack:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = "Inventar",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = "Menge"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Ungültige Menge')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('le_jobpack:putStockItems', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function hasEnteredMarker(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = "Drücke E um dich umzuziehen"
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction = 'menu_armory'
		CurrentActionMsg = "Drücke E um die Waffenkammer zu öffnen"
		CurrentActionData = { station = station }
	elseif part == 'Vehicles' then
		CurrentAction = 'menu_vehicle_spawner'
		CurrentActionMsg = "Drücke E um das Menü zu öffnen"
		CurrentActionData = { station = station, part = part, partNum = partNum }
	elseif part == 'Helicopters' then
		CurrentAction = 'menu_helicopter_spawner'
		CurrentActionMsg = "Drücke E um das Menü zu öffnen"
		CurrentActionData = { station = station, part = part, partNum = partNum }
	elseif part == 'Boats' then
		CurrentAction = 'menu_boats_spawner'
		CurrentActionMsg  = "Drücke E um das Menü zu öffnen"
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg = "Drücke E um das Menü zu öffnen"
		CurrentActionData = {}
	end
end

function hasExitedMarker(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
		exports['le_core']:closeHelpNotification()
	end

	CurrentAction = nil
end

function hasEnteredEntityZone(entity)
	local ped = PlayerPedId()

	if IsPedOnFoot(ped) then
		CurrentAction = 'remove_entity'
		CurrentActionMsg = "Drücke E um das Objekt zu entfernen"
		CurrentActionData = { entity = entity }
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		
		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped)

			for i= 0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end

function hasExitedEntityZone(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end