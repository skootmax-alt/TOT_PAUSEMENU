-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
-- TOT bundle: TOT_pauseMenu server
-- module: TOT_pauseMenu/server/main.lua
do
-- TOT_pauseMenu: server-side drop path for the pause-menu Disconnect button.
RegisterNetEvent("TOT_pauseMenu:requestDrop", function(kind)
    local src = source

    if kind == "disconnect" then
        DropPlayer(src, "Disconnected via the TOT pause menu")
    end
end)

end
