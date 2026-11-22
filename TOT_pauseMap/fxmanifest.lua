-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'TOT_pauseMap'
author 'TOT'
description '3D minimap and pause map'
version '1.0.0'

client_scripts {
    'config.lua',
    'blips_config.lua',
    'categories.lua',
    'client.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/map3d.js',
    'html/three.module.min.js',
    'html/map-data.js',
    'html/zones.js',
    'html/img/*.png',
    'html/fonts/*.otf',
    'html/fonts/*.ttf',
    'html/blips/*.webp',
    'html/icons/*.svg',
}

-- All Lua scripts ship readable in this build.