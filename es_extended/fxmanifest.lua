

fx_version 'cerulean'
description 'ESX'
game 'gta5'
version '1.0.0'
lua54 'yes'
client_scripts {
	'client/skinchanger/main.lua',
	'client/extended/common.lua',
	'client/extended/entityiter.lua',
	'client/extended/functions.lua',
	'client/extended/main.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'client/extended/modules/death.lua',
	'client/extended/modules/streaming.lua',
	'client/menus/list/main.lua',
	'client/menus/default/main.lua',
	'client/menus/dialog/main.lua'
}
shared_scripts {
	'config.lua',
	'config.weapons.lua',
}
server_scripts {
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/extended/common.lua',
	'server/extended/classes/player.lua',
	'server/extended/functions.lua',
	'server/extended/main.lua',
	'server/extended/commands.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'server/accounts/license/main.lua',
	'server/accounts/addon_account/classes/addonaccount.lua',
	'server/accounts/addon_black_account/classes/addonaccountb.lua',
	'server/accounts/addon_inventory/classes/addoninventory.lua',
	'server/accounts/datastore/classes/datastore.lua',
	'server/accounts/addon_account/main.lua',
	'server/accounts/addon_black_account/main.lua',
	'server/accounts/addon_inventory/main.lua',
	'server/accounts/datastore/main.lua'
}
ui_page 'html/ui.html'
files {
    'html/**/'
}
exports {
	'getSharedObject'
}
server_exports {
	'getSharedObject'
}
dependencies {
	'oxmysql'
}