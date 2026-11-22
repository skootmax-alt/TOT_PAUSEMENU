-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'TOT_pauseMenu'
author 'TOT'
description 'Pause menu, settings and free camera'
version '1.0.0'

shared_script 'config.lua'

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/vue.global.prod.js',
    'html/fonts/*.otf',
    'html/fonts/*.ttf',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/icons/*.svg',
}

-- All Lua scripts and NUI/stream assets ship readable in this build.