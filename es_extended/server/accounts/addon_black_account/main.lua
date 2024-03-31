local AccountsIndexB, AccountsB, SharedAccountsB = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account_black')

	for k, v in pairs(result) do
		local name = v.name
		local label = v.label
		local shared = v.shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_black_data WHERE account_name = @account_name', {
			['@account_name'] = name
		})

		if shared == 0 then
			table.insert(AccountsIndexB, name)
			AccountsB[name] = {}

			for k1, v1 in pairs(result2) do
				local addonBAccount = CreateAddonAccountBlackMoney(name, v1.owner, v1.money)
				table.insert(AccountsB[name], addonBAccount)
			end
		else
			local money = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO addon_account_black_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
					['@account_name'] = name,
					['@money'] = 0
				})

				money = 0
			else
				money = result2[1].money
			end

			local addonBAccount = CreateAddonAccountBlackMoney(name, nil, money)
			SharedAccountsB[name] = addonBAccount
		end
	end
end)

local function GetAccountB(name, owner)
	for k, v in pairs(AccountsB[name]) do
		if v.owner == owner then
			return v
		end
	end
end

local function GetSharedAccountB(name)
	return SharedAccountsB[name]
end

AddEventHandler('esx_addonaccountb:getAccount', function(name, owner, cb)
	cb(GetAccountB(name, owner))
end)

AddEventHandler('esx_addonaccountb:getSharedAccount', function(name, cb)
	cb(GetSharedAccountB(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}

	for k, v in pairs(AccountsIndexB) do
		local name = v
		local account = GetAccountB(name, xPlayer.identifier)

		if account == nil then
			MySQL.Async.execute('INSERT INTO addon_account_black_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
				['@account_name'] = name,
				['@money'] = 0,
				['@owner'] = xPlayer.identifier
			})

			account = CreateAddonAccountBlackMoney(name, xPlayer.identifier, 0)
			table.insert(AccountsB[name], account)
		end

		table.insert(addonAccounts, account)
	end

	xPlayer.set('addonAccountsB', addonAccounts)
end)