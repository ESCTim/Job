Config = {}
Config.Locale = 'de'

Config.Accounts = {
	bank = 'Bank',
	money = 'Bargeld',
	black_money = 'Schwarzgeld',
	halloween = 'Halloween Punkte',
	coins = 'Coin'
}

Config.StartingAccountMoney = {money = 35000, bank = 35000, black_money = 0, coins = 0}

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            = 150   -- the max inventory weight without backpack
Config.PaycheckInterval     = 15 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug          = false