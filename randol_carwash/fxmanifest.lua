fx_version 'cerulean'
game 'gta5'

author 'Randolio'
description 'Car Wash Zones'

shared_scripts {
	'config.lua'
}

server_scripts {
    'sv_carwash.lua'
}

client_scripts {
	'cl_carwash.lua',
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
}

lua54 'yes'