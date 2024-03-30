function OpenActionsMenu()
	ESX.UI.Menu.CloseAll()
	
	local options = Config.Jobs[ESX.PlayerData.job.name].ActionMenu

	local elements = {}

	if options.zivi.enable then
		table.insert(elements, { label = 'Zivilistenaktionen', value = 'citizen_interaction' })
	end

	if ESX.PlayerData.job.dienst and options.ems_menu.enable or ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.name == 'doj' and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, { label = 'Rettungsdienst-Menü', value = 'citizen_ems_interaction' })
	end

	if ESX.PlayerData.job.dienst and options.object_spawner.enable then
		table.insert(elements, { label = 'Objekt Spawner', value = 'object_spawner' })
	end

	if ESX.PlayerData.job.dienst and options.vehicle_interaction.enable then
		table.insert(elements, { label = 'Fahrzeuginteraktionen', value = 'vehicle_interaction' })
	end

	if ESX.PlayerData.job.dienst and options.license_interaction.enable then
		table.insert(elements, { label = 'Lizenzaktionen', value = 'lizenz_interaction' })
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title = ESX.PlayerData.job.label,
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {}

			-- if options.zivi.show_id then
			-- 	table.insert(elements, { label = 'Dienstausweis zeigen [SOON]', value = 'show_id' })
			-- end

			if options.zivi.identity_card then
				table.insert(elements, { label = 'Ausweis', value = 'identity_card' })
			end

			if options.zivi.check_id then
				table.insert(elements, { label = 'ID Check', value = 'checkid' })
			end
			
			if options.zivi.handcuff then
				table.insert(elements, { label = 'Festnehmen / Freilassen', value = 'handcuff' })
			end

			if options.zivi.search then
				table.insert(elements, { label = 'Durchsuchen', value = 'search' })
			end

			if options.zivi.search then 
				table.insert(elements, { label = 'Maske abnehmen', value = 'maskoff' })
			end

			if options.zivi.search then 
				table.insert(elements, { label = 'Helm abnehmen', value = 'hatoff' })
			end

			if options.zivi.search then 
				table.insert(elements, { label = 'Handschuhe abnehmen', value = 'glovesoff' })
			end

			if options.zivi.drag then
				table.insert(elements, { label = 'Tragen', value = 'drag' })
			end

			if options.zivi.putInVehicle then
				table.insert(elements, { label = 'In Fahrzeug setzen', value = 'put_in_vehicle' })
			end

			if options.zivi.putOutVehicle then
				table.insert(elements, { label = 'Aus dem Fahrzeug ziehen', value = 'out_the_vehicle' })
			end

			if options.zivi.bills then
				table.insert(elements, { label = 'Rechnungen', value = 'bills' })
			end

			-- if options.zivi.jail then
			-- 	table.insert(elements, { label = 'Jemanden einknasten', value = 'jail' })
			-- end

			-- table.insert(elements, {
			-- 	label = 'Blitzermenü', 
			-- 	value = 'speedcams'
			-- })

			table.insert(elements, {
				label = 'Stabilisieren',
				value = 'stabilbre'
			})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title = "Zivilistenaktionen",
				alig = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					-- elseif action == 'show_id' then						
						-- if ESX.PlayerData.job.name == 'sheriff' then
						-- 	TriggerServerEvent('grv_dienstausweislssd:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- elseif ESX.PlayerData.job.name == 'police' then
						-- 	TriggerServerEvent('grv_dienstausweislspd:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- elseif ESX.PlayerData.job.name == 'mechanic' then
						-- 	TriggerServerEvent('grv_dienstausweismechanic:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- elseif ESX.PlayerData.job.name == 'fib' then
						-- 	TriggerServerEvent('grv_dienstausweisfib:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- elseif ESX.PlayerData.job.name == 'army' then
						-- 	TriggerServerEvent('grv_dienstausweisarmy:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- elseif ESX.PlayerData.job.name == 'gov' then
						-- 	TriggerServerEvent('grv_dienstausweisgov:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
						-- end
					if action == 'identity_card' then
						TriggerServerEvent('le:searchNotify', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'Ausweis', 'Dein Ausweis wurde von ID ' .. GetPlayerServerId(PlayerId()) .. ' genommen.')
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), GetPlayerServerId(PlayerId()))
					elseif action == 'search' then
						if IsEntityDead(GetPlayerPed(closestPlayer)) then
							-- TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du kannst keinen Bewusstlosen durchsuchen!')
							--start animation
							RequestAnimDict("mini@repair")
							while not HasAnimDictLoaded("mini@repair") do
								Wait(100)
							end
							TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, 500, 0, 0)
							--end animation
							local notifytext = 'Du wirst von der ID: [' .. GetPlayerServerId(PlayerId()) .. '] durchsucht.'
							TriggerServerEvent('le:searchNotify', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'Durchsuchen', notifytext)
							OpenBodySearchMenuDead(closestPlayer)
						else
							--start animation
							RequestAnimDict("mini@repair")
							while not HasAnimDictLoaded("mini@repair") do
								Wait(100)
							end
							TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, 500, 0, 0)
							--end animation
							local notifytext = 'Du wirst von der ID: [' .. GetPlayerServerId(PlayerId()) .. '] durchsucht.'
							TriggerServerEvent('le:searchNotify', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'Durchsuchen', notifytext)
							OpenBodySearchMenu(closestPlayer)
						end
					elseif action == 'maskoff' then 
						local searchPlayerPed = GetPlayerPed(closestPlayer)
						if IsEntityPlayingAnim(searchPlayerPed, "anim@move_m@prisoner_cuffed", "idle", 49) or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or IsEntityPlayingAnim(searchPlayerPed, 'combat@damage@rb_writhe', 'rb_writhe_loop', 3) then
							TriggerServerEvent('le_jobpack:maskoff', GetPlayerServerId(closestPlayer))
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Diese Person ist nicht bewusstlos oder gefesselt!')
						end
					elseif action == 'hatoff' then
						local searchPlayerPed = GetPlayerPed(closestPlayer)
						if IsEntityPlayingAnim(searchPlayerPed, "anim@move_m@prisoner_cuffed", "idle", 49) or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or IsEntityPlayingAnim(searchPlayerPed, 'combat@damage@rb_writhe', 'rb_writhe_loop', 3) then
							TriggerServerEvent('le_jobpack:hatoff', GetPlayerServerId(closestPlayer))
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Diese Person ist nicht bewusstlos oder gefesselt!')
						end
					elseif action == 'glovesoff' then
						local searchPlayerPed = GetPlayerPed(closestPlayer)
						if IsEntityPlayingAnim(searchPlayerPed, "anim@move_m@prisoner_cuffed", "idle", 49) or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or IsEntityPlayingAnim(searchPlayerPed, 'combat@damage@rb_writhe', 'rb_writhe_loop', 3) then
							TriggerServerEvent('le_jobpack:glovesoff', GetPlayerServerId(closestPlayer))
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Diese Person ist nicht bewusstlos oder gefesselt!')
						end
					elseif action == 'handcuff' then
						if IsEntityDead(GetPlayerPed(closestPlayer)) then
							TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Diese Person ist bewusstlos!')
						else
							TriggerServerEvent('le_jobpack:handcuff', GetPlayerServerId(closestPlayer))
						end
					elseif action == 'stabilbre' then						
						local playerPed = PlayerPedId()
						local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
		
						for i=1, 15 do
							Wait(900)
		
							ESX.Streaming.RequestAnimDict(lib, function()
								TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
							end)
						end
						
						TriggerServerEvent("le_fraktion:stabil", GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('le_jobpack:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('le_jobpack:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('le_jobpack:putOutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'bills' then
						OpenBill(closestPlayer)
					end
				else
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Keine Spieler in der Nähe')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'citizen_ems_interaction' then
			local elements = {}

			if options.ems_menu.revive or ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.name == 'doj' and ESX.PlayerData.job.grade_name == 'boss' then
				table.insert(elements, { label = 'Spieler reanimieren', value = 'revive' })
			end

			if options.ems_menu.small then
				table.insert(elements, { label = 'Kleine Wunden behandeln', value = 'small' })
			end

			if options.ems_menu.big then
				table.insert(elements, { label = 'Ernsthafte Verletzungen behandeln', value = 'big' })
			end

			if options.ems_menu.putInVehicle then
				table.insert(elements, { label = 'In Fahrzeug stecken', value = 'put_in_vehicle' })
			end

			if ESX.PlayerData.job.grade >= 5 and ESX.PlayerData.job.name == 'lsmd' then
				table.insert(elements, { label = "Für Tot erklären", value = "declare_dead" })
			end

			-- if options.ems_menu.declareDead then
			-- 	table.insert(elements, { label = 'Für Tot erklären', value = 'declare_dead' })
			-- end

			if ESX.PlayerData.job.grade >= 11 and ESX.PlayerData.job.name == 'lsmd' then
				table.insert(elements, { label = "Medicschein ausstellen", value = "medicscheingeben" })
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_ems_interaction', {
				title = 'Rettungsdienst',
				align = 'top-left',
				elements = elements
			}, function(data2, menu2)
				if isBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'revive' then
						isBusy = true

						ESX.TriggerServerCallback('le_jobpack:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
					
								if IsPedDeadOrDying(closestPlayerPed, 1) then
									local playerPed = PlayerPedId()
									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
									TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Eine Wiederbelebung findet statt')
					
									for i=1, 15 do
										Wait(900)
					
										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
										end)
									end
					
									TriggerServerEvent('le_jobpack:removeItem', 'medikit')
									TriggerServerEvent('le_jobpack:revive', GetPlayerServerId(closestPlayer))
								else
									TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Dieser Spieler ist nicht bewusstlos')
								end
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du hast keine Medikits')
							end
							isBusy = false
						end, 'medikit')
					elseif action == "medicscheingeben" then
						TriggerServerEvent("ambulance:giveMedicSchein", GetPlayerServerId(closestPlayer))
					elseif action == 'small' then
						ESX.TriggerServerCallback('le_jobpack:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local ped = PlayerPedId()

									isBusy = true
									TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du heilst')
									TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Wait(3500)
									ClearPedTasks(ped)

									TriggerServerEvent('le_jobpack:removeItem', 'bandage')
									TriggerServerEvent('le_jobpack:heal', GetPlayerServerId(closestPlayer), 'small')
									TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. GetPlayerName(closestPlayer) .. ' geheilt')
									isBusy = false
								else
									TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Dieser Spieler ist nicht bei Bewusstsein')
								end
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du hast keine Bandagen')
							end
						end, 'bandage')
					elseif action == 'big' then
						ESX.TriggerServerCallback('le_jobpack:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local ped = PlayerPedId()

									isBusy = true
									TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du heilst')
									TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Wait(10000)
									ClearPedTasks(ped)

									TriggerServerEvent('le_jobpack:removeItem', 'medikit')
									TriggerServerEvent('le_jobpack:heal', GetPlayerServerId(closestPlayer), 'big')
									TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. GetPlayerName(closestPlayer) .. ' geheilt')
									isBusy = false
								else
									TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Dieser Spieler ist nicht bei Bewusstsein')
								end
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du hast keine Medikits')
							end
						end, 'medikit')
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('le_jobpack:ambulance:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'declare_dead' then
						if IsEntityDead(GetPlayerPed(closestPlayer)) then
							local ped = PlayerPedId()

							isBusy = true
							TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							Wait(10000)
							TriggerServerEvent('le_jobpack:declareDead', GetPlayerServerId(closestPlayer))
							ClearPedTasks(ped)
							isBusy = false
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Dieser Spieler ist nicht Tod')
						end
					end
				else
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Keine Spieler in der Nähe')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'lizenz_interaction' then
			local elements = {}

			if options.license_interaction.add_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_driver_license.ranks then
				table.insert(elements, { label = 'Autoführerschein ausgeben', value = 'add_driver_license' })
			end

			if options.license_interaction.add_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_driver_license.ranks then
				table.insert(elements, { label = 'Motorradführerschein ausgeben', value = 'add_bike_license' })
			end

			if options.license_interaction.add_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_driver_license.ranks then
				table.insert(elements, { label = 'Bootsführerschein ausgeben', value = 'add_boat_license' })
			end

			if options.license_interaction.add_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_driver_license.ranks then
				table.insert(elements, { label = 'Flugzeugführerschein ausgeben', value = 'add_plane_license' })
			end

			if options.license_interaction.add_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_driver_license.ranks then
				table.insert(elements, { label = 'Heliführerschein ausgeben', value = 'add_heli_license' })
			end

			if options.license_interaction.remove_driver_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.remove_driver_license.ranks then
				table.insert(elements, { label = 'Führerschein entziehen', value = 'remove_driver_license' })
			end

			if options.license_interaction.add_weapon_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_weapon_license.ranks then
				table.insert(elements, { label = 'Waffenschein ausgeben', value = 'add_weapon_license' })
			end

			if options.license_interaction.remove_weapon_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.remove_weapon_license.ranks then
				table.insert(elements, { label = 'Waffenschein entziehen', value = 'remove_weapon_license' })
			end

			if options.license_interaction.add_anwalt_license and options.license_interaction.add_anwalt_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.add_anwalt_license.ranks then
				table.insert(elements, { label = 'Anwaltslizenz ausgeben', value = 'add_anwalt_license' })
			end

			if options.license_interaction.remove_anwalt_license and options.license_interaction.remove_anwalt_license.enable and ESX.PlayerData.job.grade >= options.license_interaction.remove_anwalt_license.ranks then
				table.insert(elements, { label = 'Anwaltslizenz entziehen', value = 'remove_anwalt_license' })
			end

			local playerPed = PlayerPedId()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lizenz_interaction', {
				title = 'Lizenz Aktionen',
				align = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					if data2.current.value == 'add_driver_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein ausgestellt')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive')
					elseif data2.current.value == 'add_bike_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein ausgestellt')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive_bike')
					elseif data2.current.value == 'add_boat_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein ausgestellt')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive_boat')
					elseif data2.current.value == 'add_plane_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein ausgestellt')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive_plane')
					elseif data2.current.value == 'add_heli_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein ausgestellt')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive_heli')
					elseif data2.current.value == 'remove_driver_license' then
						ESX.TriggerServerCallback('le_jobpack:removeLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Führerschein entzogen')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat keinen Führerschein')
							end
						end, GetPlayerServerId(closestPlayer), 'drive')
					elseif data2.current.value == 'add_weapon_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Waffenschein ausgestellt!')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits einen Waffenschein!')
							end
						end, GetPlayerServerId(closestPlayer), 'weapon')
					elseif data2.current.value == 'remove_weapon_license' then
						ESX.TriggerServerCallback('le_jobpack:removeLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich denn Waffenschein entzogen!')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat keinen Waffenschein!')
							end
						end, GetPlayerServerId(closestPlayer), 'weapon')
					elseif data2.current.value == 'add_anwalt_license' then
						ESX.TriggerServerCallback('le_jobpack:addLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich die Anwaltslizenz ausgestellt!')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat bereits eine Anwaltslizenz!')
							end
						end, GetPlayerServerId(closestPlayer), 'anwalt')
					elseif data2.current.value == 'remove_anwalt_license' then
						ESX.TriggerServerCallback('le_jobpack:removeLicense', function(rpname, bool)
							if bool then
								TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ' .. rpname .. ' erfolgreich die Anwaltslizenz entzogen!')
							else
								TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Der Spieler hat keine Anwaltslizenz!')
							end
						end, GetPlayerServerId(closestPlayer), 'anwalt')
					end
				else
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Keine Spieler in der Nähe')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements = {}
			local ped = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local isVehicleTow = IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(), true), GetHashKey('flatbed'))

			if DoesEntityExist(vehicle) then
				if options.vehicle_interaction.vehicle_infos then
					table.insert(elements, {label = "Fahrzeug Info", value = 'vehicle_infos'})
				end

				if options.vehicle_interaction.hijack_vehicle then
					table.insert(elements, {label = "Fahrzeug öffnen", value = 'hijack_vehicle'})
				end

				if options.vehicle_interaction.repair then
					table.insert(elements, {label = "Auto Reparieren", value = 'repair'})
				end

				if options.vehicle_interaction.wash then
					table.insert(elements, {label = "Auto Waschen", value = 'wash'})
				end

				if options.vehicle_interaction.impound then
					table.insert(elements, {label = "Auto Abschleppen", value = 'impound'})
				end

				if isVehicleTow then
					if options.vehicle_interaction.low_loader then
						table.insert(elements, {label = "Tieflader", value = 'low_loader'})
					end
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title = "Fahrzeuginteraktionen",
				align = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords = GetEntityCoords(ped)
				vehicle = ESX.Game.GetVehicleInDirection()
				action = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
							Wait(20000)
							ClearPedTasksImmediately(ped)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							TriggerEvent('le_core:hud:notify', 'success', 'Fahrzeugmenu', 'Das Fahrzeug ist nun Offen')
						end
					elseif action == 'repair' then
						local vehicle = ESX.Game.GetVehicleInDirection()
						local coords = GetEntityCoords(ped)

						if IsPedSittingInAnyVehicle(ped) then
							TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Das kannst du nicht in einem Fahrzeug machen!')
							return
						end

						if DoesEntityExist(vehicle) then
							TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
							menu.close()

							CreateThread(function()
								Wait(20000)
			
								SetVehicleFixed(vehicle)
								SetVehicleDeformationFixed(vehicle)
								SetVehicleUndriveable(vehicle, false)
								SetVehicleEngineOn(vehicle, true, true)
								exports['le_core']:setFuel(vehicle, 100)
								ClearPedTasksImmediately(ped)
			
								TriggerEvent('le_core:hud:notify', 'success', 'Fahrzeugmenu', 'Das fahrzeug wurde repariert.')
							end)
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Es ist kein Fahrzeug in der Nähe!')
						end
					elseif action == 'wash' then
						local vehicle = ESX.Game.GetVehicleInDirection()
						local coords = GetEntityCoords(ped)
			
						if IsPedSittingInAnyVehicle(ped) then
							TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Das kannst du nicht in einem Fahrzeug machen!')
							return
						end
			
						if DoesEntityExist(vehicle) then
							menu.close()
							TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							CreateThread(function()
								Wait(10000)
			
								SetVehicleDirtLevel(vehicle, 0)
								ClearPedTasksImmediately(ped)
			
								TriggerEvent('le_core:hud:notify', 'success', 'Fahrzeugmenu', 'Das Fahrzeug wurde geputzt.')
							end)
						else
							TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Es ist kein Fahrzeug in der Nähe!')
						end
					elseif action == 'impound' then
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification("~INPUT_CONTEXT~ um beschlagnahmen zu stoppen")
						TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						ClearPedTasks(ped)

						currentTask.task = true

						CreateThread(function()
							Wait(10000)
							if currentTask.task then
								ClearPedTasks(ped)
								ImpoundVehicle(vehicle)
								Wait(100)
							end
						end)

						CreateThread(function()
							while currentTask.busy do
								Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Das Beschlagnahmen wurde abgebrochen da sich das Fahrzeug bewegt hat')
									currentTask.task = false
									ClearPedTasks(ped)
									currentTask.busy = false
									break
								end
							end
						end)
					elseif action == 'low_loader' then
						local ped = PlayerPedId()
						local vehicle = GetVehiclePedIsIn(ped, true)
						
						local isVehicleTow = IsVehicleModel(vehicle, GetHashKey('flatbed'))

						if isVehicleTow then
							local targetVehicle = ESX.Game.GetVehicleInDirection()

							if currentlyTowedVehicle == nil then
								if targetVehicle ~= 0 then
									if not IsPedInAnyVehicle(ped, true) then
										if vehicle ~= targetVehicle then
											AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
											currentlyTowedVehicle = targetVehicle
											Notify('Information', 'Fahrzeug wurde erfolgreich befestigt', 'info')
										end
									end
								else
									Notify('Information', 'Es ist kein fahrzeug zum Befestigen in der Nähe', 'info')
								end
							else
								AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								DetachEntity(currentlyTowedVehicle, true, true)

								currentlyTowedVehicle = nil
								Notify('Information', 'Fahrzeug erfolgreich gelöst', 'info')
							end
						else
							Notify('Information', 'Aktion nicht möglich! ' .. 'Du benötigst einen Tieflader um das Fahrzeug aufzuladen', 'info')
						end
					end
				else
					TriggerEvent('le_core:hud:notify', 'error', 'Fahrzeugmenu', 'Keine Fahrzeuge in der Nähe')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		

		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title = "Straßeninteraktionen",
				align = 'top-left',
				elements = options.object_spawner.models
			}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)
				
				if data2.current.model == 'p_ld_stinger_s' then
					-- ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					-- 	PlaceObjectOnGroundProperly(obj)
					-- 	SetEntityHeading(obj, GetEntityHeading(playerPed))
					-- end)
					
					local model = GetHashKey('p_ld_stinger_s')
					RequestModel(model)
					while (not HasModelLoaded(model)) do
						Wait(1)
					end
					obj = CreateObject(model, x, y, z, true, false, true)
					PlaceObjectOnGroundProperly(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))	
					SetModelAsNoLongerNeeded(model)
					SetEntityAsMissionEntity(obj)
				else
					RequestAnimDict("amb@world_human_bum_wash@male@low@idle_a")
					while not HasAnimDictLoaded("amb@world_human_bum_wash@male@low@idle_a") do
						Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_wash@male@low@idle_a", "idle_a", 8.0, -8.0, 1000, 0, 0)				
					
					Wait(1000)
					
					-- ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					-- 	PlaceObjectOnGroundProperly(obj)
					-- 	SetEntityHeading(obj, GetEntityHeading(playerPed))	
					-- end)
					local model = GetHashKey(data2.current.model)
					RequestModel(model)
					while (not HasModelLoaded(model)) do
						Wait(1)
					end
					obj = CreateObject(model, x, y, z, true, false, true)
					PlaceObjectOnGroundProperly(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))	
					SetModelAsNoLongerNeeded(model)
					SetEntityAsMissionEntity(obj)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end


RegisterNetEvent('le_jobpack:killPlayer')
AddEventHandler('le_jobpack:killPlayer', function()
	print('Es klappt')
	-- RemoveItemsAfterRPDeath()
end)

local forbiddenItems = {
	['levelup'] = true,
	['headlights'] = true,
	['licenseplate'] = true,
	['simcard'] = true,
	['patroncard'] = true
}

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('le_jobpack:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = ESX.Math.Round(data.accounts[i].money) ..'$ Schwarzgeld',
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {
			label = '--- Waffen ---'
		})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label = ESX.GetWeaponLabel(data.weapons[i].name), --.. ' mit ' .. data.weapons[i].ammo .. ' Schuss',
				value = data.weapons[i].name,
				itemType = 'item_weapon',
				amount = data.weapons[i].ammo
			})
		end

		table.insert(elements, {
			label = '--- Inventar ---'
		})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 and not forbiddenItems[data.inventory[i].name] then
				table.insert(elements, {
					label = 'Konfisziere ' .. data.inventory[i].count .. 'x ' .. data.inventory[i].label,
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title = 'Suche',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('le_jobpack:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player), false)
end

function OpenBodySearchMenuDead(player)
	ESX.TriggerServerCallback('le_jobpack:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = ESX.Math.Round(data.accounts[i].money) ..'$ Schwarzgeld',
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {
			label = '--- Waffen ---'
		})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label = ESX.GetWeaponLabel(data.weapons[i].name), --.. ' mit ' .. data.weapons[i].ammo .. ' Schuss',
				value = data.weapons[i].name,
				itemType = 'item_weapon',
				amount = data.weapons[i].ammo
			})
		end

		table.insert(elements, {
			label = '--- Inventar ---'
		})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 and not forbiddenItems[data.inventory[i].name] then
				table.insert(elements, {
					label = 'Konfisziere ' .. data.inventory[i].count .. 'x ' .. data.inventory[i].label,
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title = 'Suche',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				-- TriggerServerEvent('le_jobpack:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenuDead(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player), false)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('le_jobpack:getOtherPlayerData', function(playerData)
		if playerData.licenses then
			for i=1, #playerData.licenses, 1 do
				if playerData.licenses[i].label and playerData.licenses[i].type then
					table.insert(elements, {
						label = playerData.licenses[i].label,
						type = playerData.licenses[i].type
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = 'Lizenz widerrufen',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerEvent('le_core:hud:notify', 'success', 'Lizenzen', 'Du hast ' .. data.current.label .. ' widerrufen der ' .. playerData.name .. ' gehört')

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player), true)
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('le_core:bill:getTargetBills', function(bills)
		for k, bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, ESX.Math.GroupDigits(bill.amount) .. '$'),
				billId = bill.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title = 'Unbezahlte Rechnung ansehen',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenSpeedcam(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = 'Speedcams',
		align    = 'top-left',
		elements = {
			{label = 'Blitzer installieren', action = 'place'},
			{label = 'Blitzerstatistik', action = 'stats'},
	}}, function(data2, menu2)
		if data2.current.action == 'place' then
			TriggerEvent('myRadarcontrol:createRadar')
			menu2.close()
			ESX.UI.Menu.CloseAll()

		else
			TriggerEvent('myRadarcontrol:openBossmenu')
			menu2.close()
			ESX.UI.Menu.CloseAll()

		end
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
	end)
end


function OpenBill(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'custom_bill_menu', {
		title    = 'Rechnungen',
		align    = 'top-left',
		elements = {
			{label = 'Unbezahlte Rechnung ansehen', action = 'unpaid_bills'},
			{label = 'Rechnung ausstellen', action = 'send_bill'},
	}}, function(data6, menu6)
		if data6.current.action == 'unpaid_bills' then
			OpenUnpaidBillsMenu(player)
			menu6.close()
			-- ESX.UI.Menu.CloseAll()

		elseif data6.current.action == 'send_bill' then
			OpenFineMenu(player)
			menu6.close()
			-- ESX.UI.Menu.CloseAll()

		end
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
	end)
end


function OpenFineMenu(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'custom_rechnungGeld', {
		title = "Geld"
	}, function(data3, menu3)
		local customBillMoney = tonumber(data3.value)
		if customBillMoney == nil then
			TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Ungültiger Betrag')
		else
			menu3.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'custombill_grund',{
				title = "Rechnungs Grund"
			}, function(data4, menu4)
				local reason = data4.value
				if reason == nil then
					TriggerEvent('le_core:hud:notify', 'error', 'Information', 'Du musst dein Grund angeben')
				else
					menu4.close()
					local playerPed        = GetPlayerPed(-1)
					ExecuteCommand("e notepad")
					Wait(5000)
					ClearPedTasks(playerPed)
					-- print('society_' .. ESX.PlayerData.job.name)
					TriggerServerEvent('le_core:bill:sendBill', GetPlayerServerId(player), 'society_' .. ESX.PlayerData.job.name, reason, customBillMoney)
					ExecuteCommand("e damn2")
				end
			end, function(data4, menu4)
				menu4.close()
			end)
		end
	end, function(data3, menu3)
		menu3.close()
	end)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('le_jobpack:getVehicleInfos', function(retrivedInfo)
		local elements = {
			{ label = 'Plate: ' .. retrivedInfo.plate } 
		}

		local vehicleOwner = 'Besitzer: Unbekannt'
		if retrivedInfo and retrivedInfo.owner then

			vehicleOwner = 'Besitzer: ' .. retrivedInfo.owner
		end

		table.insert(elements, {
			label = vehicleOwner
		})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title = 'Fahrzeug Info',
			align = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function ImpoundVehicle(vehicle, action)
	DeleteEntity(vehicle)
	TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast das Fahrzeug beschlagnahmt')
	currentTask.busy = false
end

-- job actions

RegisterNetEvent('le_jobpack:heal')
AddEventHandler('le_jobpack:heal', function(healType, quiet)
	local ped = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(ped)

	if healType == 'small' then
		local health = GetEntityHealth(ped)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(ped, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(ped, maxHealth)
	end

	if not quiet then
		TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du wurdest behandelt.')
	end
end)

RegisterNetEvent('le_jobpack:useItem')
AddEventHandler('le_jobpack:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 7500, 0, 0, false, false, false)


			exports['le_core']:startProgressbar(7.5)
			Wait(7500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
				EnableControlAction(0, 1)		-- Mausbewegung Links/Rechts
				EnableControlAction(0, 2)		-- Mausbewegung Oben/Unten
			end

			TriggerEvent('le_jobpack:heal', 'big', true)
			TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast ein Medikit verwendet!')
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 3500, 0, 0, false, false, false)

			exports['le_core']:startProgressbar(3.5)
			Wait(3500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
				EnableControlAction(0, 1)		-- Mausbewegung Links/Rechts
				EnableControlAction(0, 2)		-- Mausbewegung Oben/Unten
			end

			TriggerEvent('le_jobpack:heal', 'small', true)
			TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Du hast einen Verband verwendet')
		end)
	end
end)

RegisterNetEvent('le_jobpack:ambulance:putInVehicle')
AddEventHandler('le_jobpack:ambulance:putInVehicle', function()
	local ped = PlayerPedId()
	local vehicle, distance = ESX.Game.GetClosestVehicle()

	if vehicle and distance < 5 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i = maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	end
end)

RegisterNetEvent('le_jobpack:handcuff')
AddEventHandler('le_jobpack:handcuff', function()
	isHandcuffed = not isHandcuffed
	local ped = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(100)
		end

		TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

		SetEnableHandcuffs(ped, true)
		DisablePlayerFiring(ped, true)
		SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
		SetPedCanPlayGestureAnims(ped, false)
		DisplayRadar(false)

		if handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end

		StartHandcuffTimer()
	else
		if handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end

		ClearPedSecondaryTask(ped)
		SetEnableHandcuffs(ped, false)
		DisablePlayerFiring(ped, false)
		SetPedCanPlayGestureAnims(ped, true)
		DisplayRadar(true)
	end
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Wait(1)
		end
	end
end

RegisterNetEvent('le_jobpack:unrestrain')
AddEventHandler('le_jobpack:unrestrain', function()
	if isHandcuffed then
		local ped = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(ped)
		SetEnableHandcuffs(ped, false)
		DisablePlayerFiring(ped, false)
		SetPedCanPlayGestureAnims(ped, true)
		FreezeEntityPosition(ped, false)
		DisplayRadar(true)

		-- end timer
		if handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)



RegisterNetEvent('le_jobpack:drag')
AddEventHandler('le_jobpack:drag', function(copId)
	if isHandcuffed then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

CreateThread(function()
	local wasDragged

	while true do
		Wait(0)
		local ped = PlayerPedId()

		if isHandcuffed and dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(ped, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(ped, true, false)
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('le_jobpack:putInVehicle')
AddEventHandler('le_jobpack:putInVehicle', function()
	if isHandcuffed then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = getVehicleInDirection()

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
				
				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)

function getVehicleInDirection()
	local playerPed = GetPlayerPed(-1)
	local coordFrom = GetEntityCoords(playerPed, 1)
	local coordTo = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, playerPed, 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

RegisterNetEvent('le_jobpack:putOutVehicle')
AddEventHandler('le_jobpack:putOutVehicle', function()
	local ped = PlayerPedId()

	if IsPedSittingInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped, false)
		TaskLeaveVehicle(ped, vehicle, 16)
	end
end)

-- Handcuff
CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()

		if isHandcuffed then
			TriggerEvent('le:oger')
			--DisableControlAction(0, 1, true) -- Disable pan
			--DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			-- DisableControlAction(0, 209, true) -- Sprint
			-- DisableControlAction(0, 155, true) -- Sprint
			-- DisableControlAction(0, 131, true) -- Sprint
			-- DisableControlAction(0, 61, true) -- Sprint
			-- DisableControlAction(0, 21, true) -- Sprint
		--	DisableControlAction(0, 32, true) -- W
		--	DisableControlAction(0, 34, true) -- A
		--	DisableControlAction(0, 31, true) -- S
		--	DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 38, true) -- E
			DisableControlAction(0, 51, true) -- E
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			--DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			--DisableControlAction(0, 0, true) -- Disable changing view
			--DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('le_jobpack:unrestrain')

		if handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	TriggerEvent('le_jobpack:unrestrain')

	if handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end
end)

function StartHandcuffTimer()
	if handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(20 * 60000, function()
		TriggerEvent('le_core:hud:notify', 'info', 'Information', 'Sie spüren, wie Ihre Handschellen langsam ihren Halt verlieren und sich auflösen.')
		TriggerEvent('le_jobpack:unrestrain')
		handcuffTimer.active = false
	end)
end

RegisterNetEvent('le_jobpack:onrepairkit')
AddEventHandler('le_jobpack:onrepairkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			CreateThread(function()
				Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(ped)
				TriggerEvent('le_core:hud:notify', 'success', 'Information', 'Fahrzeug wurde repariert')
			end)
		end 
	end
end)