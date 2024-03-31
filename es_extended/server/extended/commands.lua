RegisterCommand('tp', function(source, args, rawCommand)
    if ESX.GetPlayerGroup(source) == 'pl' or ESX.GetPlayerGroup(source) == 'dev' then
        ESX.SetPlayerCoords(source, {x = args[1], y = args[2], z = args[3]}) 
    end
end)

RegisterCommand('setmarry', function(source, args, rawCommand)
    if ESX.GetPlayerGroup(source) == 'pl' then
        ESX.SetPlayerMarried(tonumber(args[1]), 'can') 
    end
end)

RegisterCommand('setgroup', function(source, args, rawCommand)    
    if source > 0 then
        if ESX.GetPlayerGroup(source) == 'pl' or ESX.GetPlayerGroup(source) == 'manage' or ESX.GetPlayerGroup(source) == 'admin' or ESX.GetPlayerGroup(source) == 'dev' or ESX.GetPlayerGroup(source) == 'mod' then
            if args[2] == 'pl' or args[2] == 'manage' or args[2] == 'admin' or args[2] == 'dev' or args[2] == 'cardev' then
                TriggerClientEvent('le_core:hud:notify', source, 'error', 'SetGroup', 'Du kannst diese Gruppe nicht setzen')
                return
            end

            local targetId = tonumber(args[1])
            
            if GetPlayerName(targetId) ~= nil then
                ESX.SetPlayerGroup(targetId, args[2])
                exports['le_core']:doubleLog(source, targetId, 'Gruppe - Logs', 'Der Spieler ' .. GetPlayerName(source) .. ' ' .. GetPlayerName(targetId) .. ' die Gruppe ' .. args[2] .. ' gesetzt!', 'https://discord.com/api/webhooks/1173565313036587068/vjdfYjgCJZxwoRyvoYov80QcnbQtllc-9mRxcAzBI93Lk92S2Y-_7mH-pwVjjWYboEkB')
            end
        end
    else
        local targetId = tonumber(args[1])
        if GetPlayerName(targetId) ~= nil then
            ESX.SetPlayerGroup(targetId, args[2])
        end
    end
end)

local admins = {
    'steam:XXX'
}

local function isAllowedToChange(playerId)
    local allowed = false

    for k, v in pairs(admins) do
        for k1, v1 in pairs(GetPlayerIdentifiers(playerId)) do
            if string.lower(v1) == string.lower(v) then
                allowed = true
                break
            end
        end
    end

    return allowed
end

RegisterCommand('car', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group == 'pl' or group == 'admin' or group == 'manage' or group == 'cardev' or group == 'dev' or group == 'developer' or group == 'cm'or group == 'fm' or isAllowedToChange(source) then
        local carName = args[1] or adder
        if carName then
            local carPlate = table.concat(args, ' ', 2)

            local ped = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local vehicle = CreateVehicle(GetHashKey(carName), coords.x, coords.y, coords.z, heading, true, false)
            SetPedIntoVehicle(ped, vehicle, -1)

            if carPlate ~= '' then
                exports['le_core']:log(source, 'Spawn Car - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' spawnt sich ein ' .. carName .. ' mit dem Kennzeichen ' .. carPlate, 'https://discord.com/api/webhooks/1089539464390524958/V5axTzAchEOTGytRSyge-AiLsNgy3G3UUepSd4koGS37UyqSb3gy5KLMOskT3tcJX8LK')
            else
                exports['le_core']:log(source, 'Spawn Car - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' spawnt sich ein ' .. carName, 'https://discord.com/api/webhooks/1089539464390524958/V5axTzAchEOTGytRSyge-AiLsNgy3G3UUepSd4koGS37UyqSb3gy5KLMOskT3tcJX8LK')
            end

            if carPlate ~= '' then
                SetVehicleNumberPlateText(vehicle, carPlate)
            end

            TriggerClientEvent('esx:setVehicleRadioOff', source, vehicle)
        end
    end
end)

RegisterCommand('tebexcar', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group == 'pl' or group == 'admin' or group == 'manage' then
        local carName = args[1] or 'adder'
        if carName then

            local ped = GetPlayerPed(source)
            local vehicle = CreateVehicle(GetHashKey(carName), 137.98, -739.54, 32.48, 304.81, true, false)
            SetPedIntoVehicle(ped, vehicle, -1)

            SetVehicleNumberPlateText(vehicle, 'Server Name')
            SetVehicleColours(vehicle, 111, 111)

            TriggerClientEvent('esx:setVehicleRadioOff', source, vehicle)
        end
    end
end)

local active = false

RegisterCommand('tebexcam', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group == 'pl' or group == 'admin' or group == 'manage' then
        if not active then 
            active = true
            TriggerClientEvent('esx:setTebexCam', source, active)
        else 
            active = false
            TriggerClientEvent('esx:setTebexCam', source, active)
        end

    end
end)

RegisterCommand('dv', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group ~= 'user' and group ~= 'analyst' then
        local radius = tonumber(args[1])

        if radius then
            TriggerClientEvent('esx:deleteVehicle', source, radius)
        else
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
            if vehicle ~= 0 then
                DeleteEntity(vehicle)
            end
        end
    end
end)

RegisterCommand('cleararea', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group ~= 'user' and group ~= 'analyst' then
        local radius = tonumber(args[1])

        if radius then
            TriggerClientEvent('esx:deleteArea', source, radius)
        end
    end
end)

RegisterCommand('ban', function(source, args)
    if source == 0 then
        TriggerEvent('EasyAdmin:banPlayer', tonumber(args[1]), tostring(args[2]), false)
    else
        if ESX.GetPlayerGroup(source) == 'pl' and args[1] ~= nil then
            TriggerEvent('EasyAdmin:banPlayer', tonumber(args[1]), tostring(args[2]), false)
        end
    end
end)

RegisterCommand('giveaccountmoney', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group == 'pl' or group == 'manage' or group == 'dev' then
       
        local targetId = tonumber(args[1])

        if GetPlayerName(targetId) ~= nil then
            if ESX.GetPlayerAccount(targetId, args[2]) then
                ESX.AddPlayerAccountMoney(targetId, args[2], tonumber(args[3]), GetCurrentResourceName())
                TriggerClientEvent('admin:notify', source, 'Success', 'success', 4000)
                exports['le_core']:doubleLog(source, targetId, 'Geld Geben - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' gibt dem Spieler ' .. GetPlayerName(targetId) .. ' ' .. args[3] .. '$ ' .. Config.Accounts[args[2]], 'https://discord.com/api/webhooks/1089539464390524958/V5axTzAchEOTGytRSyge-AiLsNgy3G3UUepSd4koGS37UyqSb3gy5KLMOskT3tcJX8LK')
            else
                TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Account Existiert nicht')
            end
        end
    end
end)

RegisterCommand('giveitem', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group == 'pl' or group == 'manage' or group == 'admin' or group == 'cm' or group == 'fm' or group == 'dev' or group == 'developer' then
        local targetId = tonumber(args[1])

        if GetPlayerName(targetId) ~= nil then
            local label = ESX.GetItemLabel(args[2])
            if label then
                ESX.AddPlayerInventoryItem(targetId, args[2], tonumber(args[3]), GetCurrentResourceName())
                exports['le_core']:doubleLog(source, targetId, 'Item Geben - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' gibt dem Spieler ' .. GetPlayerName(targetId) .. ' ' .. args[3] .. 'x ' .. label, 'https://discord.com/api/webhooks/1089539464390524958/V5axTzAchEOTGytRSyge-AiLsNgy3G3UUepSd4koGS37UyqSb3gy5KLMOskT3tcJX8LK')
            else
                TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Dieses Item Existiert nicht')
            end
        end
    end
end)

RegisterCommand('giveweapon', function(source, args, rawCommand)
    if source == 0 then
        local targetId = tonumber(args[1])
        if GetPlayerName(targetId) ~= nil then
            if ESX.HasPlayerWeapon(targetId, args[2]) then
                print('Der Spieler hat die Waffe Bereits!')
                return
            else
                ESX.AddPlayerWeapon(targetId, args[2], tonumber(args[3]))
                print('Console Added Weapon: '..args[2]..' To Player: '..targetId)
                return
            end
        end
    else
        local group = ESX.GetPlayerGroup(source)
        if group == 'pl' or group == 'manage' or group == 'admin' or group == 'cm' or group == 'dev' or group == 'developer' or group == 'fm' or isAllowedToChange(source) then
            local targetId = tonumber(args[1])
            if GetPlayerName(targetId) ~= nil then
                if ESX.HasPlayerWeapon(targetId, args[2]) then
                    TriggerClientEvent('le_core:hud:notify', source, 'info', 'Information', 'Der Spieler hat bereits diesee Waffe')
                else
                    ESX.AddPlayerWeapon(targetId, args[2], tonumber(args[3]))
                    exports['le_core']:doubleLog(source, targetId, 'Item Geben - Log', 'Der Spieler ' .. GetPlayerName(source) .. ' gibt dem Spieler ' .. GetPlayerName(targetId) .. ' 1x ' .. ESX.GetWeaponLabel(args[2]), 'https://discord.com/api/webhooks/1089539464390524958/V5axTzAchEOTGytRSyge-AiLsNgy3G3UUepSd4koGS37UyqSb3gy5KLMOskT3tcJX8LK')
                end
            end
        end
    end
end)

--comp

RegisterCommand('clearinventory', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group ~= 'user' and group ~= 'analyst' then
        local targetId = tonumber(args[1])

        if GetPlayerName(targetId) ~= nil then
            for k, v in ipairs(ESX.GetPlayerInventory(targetId)) do
                if v.count > 0 then
                    ESX.SetPlayerInventoryItem(targetId, v.name, 0, GetCurrentResourceName())
                end
            end
        end
    end
end)

RegisterCommand('clearloadout', function(source, args, rawCommand)
    local group = ESX.GetPlayerGroup(source)

    if group ~= 'user' and group ~= 'analyst' then
        local targetId = tonumber(args[1])

        if GetPlayerName(targetId) ~= nil then
            for k, v in ipairs(ESX.GetPlayerLoadout(targetId)) do
                ESX.RemovePlayerWeapon(targetId, v.name)
            end 
        end
    end
end)

RegisterCommand('save', function(source, args, rawCommand)
    local targetId = tonumber(args[1])

    if source > 0 then
        if targetId ~= nil then
            ESX.SavePlayer(targetId, function()
                print('saved ' .. GetPlayerName(targetId))
            end)
        end
    else
        if ESX.GetPlayerGroup(source) == 'pl' or ESX.GetPlayerGroup(source) == 'dev' then
            if targetId ~= nil then
                ESX.SavePlayer(targetId, function()
                    print('saved ' .. GetPlayerName(targetId))
                end)
            end
        end 
    end
end)

RegisterCommand('saveall', function(source, args, rawCommand)
    if source > 0 then
        if ESX.GetPlayerGroup(source) == 'pl' or ESX.GetPlayerGroup(source) == 'dev' then
            ESX.SavePlayers()
        end
    else
        ESX.SavePlayers() 
    end
end)