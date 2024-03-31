local DataStores, DataStoresIndex, SharedDataStores = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore')

	for k, v in pairs(result) do
		local name = v.name
		local label = v.label
		local shared = v.shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
			['@name'] = name
		})

		if shared == 0 then
			table.insert(DataStoresIndex, name)
			DataStores[name] = {}

			for k1, v1 in pairs(result2) do
				local storeName = v1.name
				local storeOwner = v1.owner
				local storeData = (v1.data == nil and {} or json.decode(v1.data))
				local dataStore = CreateDataStore(storeName, storeOwner, storeData)

				table.insert(DataStores[name], dataStore)
			end
		else
			local data = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
					['@name'] = name
				})

				data = {}
			else
				data = json.decode(result2[1].data)
			end

			local dataStore = CreateDataStore(name, nil, data)
			SharedDataStores[name] = dataStore
		end
	end
end)

local function GetDataStore(name, owner)
	for i=1, #DataStores[name], 1 do
		if DataStores[name][i].owner == owner then
			return DataStores[name][i]
		end
	end
end

local function GetDataStoreOwners(name)
	local identifiers = {}

	for i=1, #DataStores[name], 1 do
		table.insert(identifiers, DataStores[name][i].owner)
	end

	return identifiers
end

local function GetSharedDataStore(name)
	return SharedDataStores[name]
end

AddEventHandler('esx_datastore:getDataStore', function(name, owner, cb)
	cb(GetDataStore(name, owner))
end)

AddEventHandler('esx_datastore:getDataStoreOwners', function(name, cb)
	cb(GetDataStoreOwners(name))
end)

AddEventHandler('esx_datastore:getSharedDataStore', function(name, cb)
	cb(GetSharedDataStore(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local dataStores = {}

	for k, v in pairs(DataStoresIndex) do
		local name = v
		local dataStore = GetDataStore(name, xPlayer.identifier)

		if dataStore == nil then
			MySQL.Async.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, @owner, @data)', {
				['@name'] = name,
				['@owner'] = xPlayer.identifier,
				['@data'] = '{}'
			})

			dataStore = CreateDataStore(name, xPlayer.identifier, {})
			table.insert(DataStores[name], dataStore)
		end

		table.insert(dataStores, dataStore)
	end

	xPlayer.set('dataStores', dataStores)
end)