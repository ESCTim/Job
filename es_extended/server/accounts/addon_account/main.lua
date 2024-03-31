local AccountsIndex, Accounts, SharedAccounts = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account')

	for k, v in pairs(result) do
		local name = v.name
		local label = v.label
		local shared = v.shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = name
		})

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			for k1, v1 in pairs(result2) do
				local addonAccount = CreateAddonAccount(name, v1.owner, v1.money)
				table.insert(Accounts[name], addonAccount)
			end
		else
			local money = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
					['@account_name'] = name,
					['@money'] = 0
				})

				money = 0
			else
				money = result2[1].money
			end

			local addonAccount = CreateAddonAccount(name, nil, money)
			SharedAccounts[name] = addonAccount
		end
	end
end)

local function GetAccount(name, owner)
	for k, v in pairs(Accounts[name]) do
		if v.owner == owner then
			return v
		end
	end
end

local function GetSharedAccount(name)
	return SharedAccounts[name]
end

AddEventHandler('esx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler('esx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}

	for k, v in pairs(AccountsIndex) do
		local name = v
		local account = GetAccount(name, xPlayer.identifier)

		if account == nil then
			MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
				['@account_name'] = name,
				['@money']        = 0,
				['@owner']        = xPlayer.identifier
			})

			account = CreateAddonAccount(name, xPlayer.identifier, 0)
			table.insert(Accounts[name], account)
		end

		table.insert(addonAccounts, account)
	end

	xPlayer.set('addonAccounts', addonAccounts)
end)