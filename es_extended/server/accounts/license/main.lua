local function AddLicense(target, type, cb)
	local identifier = ESX.GetPlayerIdentifier(target)

	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type'] = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

local function RemoveLicense(target, type, cb)
	local identifier = ESX.GetPlayerIdentifier(target)

	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

local function GetLicense(type, cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type  = type,
			label = result[1].label
		}

		cb(data)
	end)
end

local function GetLicenses(target, cb)
	local identifier = ESX.GetPlayerIdentifier(target)

	MySQL.Async.fetchAll('SELECT user_licenses.type, licenses.label FROM user_licenses LEFT JOIN licenses ON user_licenses.type = licenses.type WHERE owner = @owner', {
		['@owner'] = identifier
	}, function(result)
		cb(result)
	end)
end

local function CheckLicense(target, type, cb)
	local identifier = ESX.GetPlayerIdentifier(target)

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

function GetLicensesList(cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i=1, #result, 1 do
			table.insert(licenses, {
				type  = result[i].type,
				label = result[i].label
			})
		end

		cb(licenses)
	end)
end

local count = {}
local count88 = {}
local count666 = {}

AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	local playerId = source

	if playerId then
		if count666[playerId] == nil then
			count666[playerId] = 0
		end
	
		if count666[playerId] > 20 then
			return
		else
			count666[playerId] = count666[playerId] + 1
			GetLicense(type, cb)
		end
	else
		GetLicense(type, cb)
	end
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	local _source = source
	if count[_source] == nil then
        count[_source] = 0
    end
	if count[_source] > 100 then
		return
	else
		count[_source] = count[_source] + 1
		CheckLicense(target, type, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	local _source = source
	if count[_source] == nil then
        count[_source] = 0
    end
	if count[_source] > 100 then
		return
	else
		count[_source] = count[_source] + 1
		GetLicensesList(cb)
	end
end)