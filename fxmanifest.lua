fx_version 'cerulean'
game 'gta5'

author 'herayoo'
description 'Find the model name, plate and class of the vehicle you are in.'
version '2.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

ui_page 'html/dist/index.html'

files {
    'html/dist/**/*'
}
