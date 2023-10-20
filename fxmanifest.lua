fx_version 'cerulean'
game 'gta5'

author 'Traid'
description 'Discord: alwaystraid#0'
version '1.0.0'

client_scripts {
    'client/client.lua',
    '@ox_lib/init.lua', -- This can be hashed out if you are not using ox_lib
}

server_scripts {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    'shared/config.lua'
}

lua54 'yes'