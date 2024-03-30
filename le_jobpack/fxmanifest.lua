

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_scripts {
    'client/main.lua',
    'client/action.lua',
    'client/vehicle.lua'
}
shared_scripts {
    'config.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}
ui_page {
	'html/index.html'
}
files {
    'html/**/'
}
dependencies {
	'es_extended',
	'le_core'
}
