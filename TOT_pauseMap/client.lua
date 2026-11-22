-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
-- TOT bundle: TOT_pauseMap client
-- module: TOT_pauseMap/client.lua
do
local HIDDEN_SPRITES = {
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [161] = true,
    [163] = true,
    [164] = true,
}

local SKIPPED_DISPLAYS = {
    [0] = true,
    [5] = true,
    [9] = true,
}

local ROUTE_VERSION = "2026-11-21d"

local MAX_SPRITE = 1000
local SPRITE_CHUNK = 125
local HUD_BLIP_RANGE = 600.0
local ROUTE_STEP = 30.0
local ROUTE_SAMPLES = 700
local ROUTE_HUD = 1200.0
local ROUTE_MOVE = 35.0
local ROUTE_RETRY = 350

print(("[TOT_pauseMap] client %s loaded"):format(ROUTE_VERSION))

local bigOpen = false
local zoomSound = nil
local blipInfo = {}
local blipNameCache = {}
local zoneLabelCache = {}
local hudColourCache = {}
local lastMenuTime = 0
local lastDataAt = 0
local lastPoseShow = nil
local dataDue = nil
local lastPose = nil

-- Blip scanning is spread over several ticks. Known sprite types refresh every
-- tick; the rest of the 0..1000 range is swept in chunks, so the old 1001-call
-- burst once a second is gone.
local activeSprites = {}
local spriteCursor = 0
local firstBlipScan = true

-- GPS route caching: re-sample only when the waypoint changes, the player has
-- moved far enough that the old polyline is visibly stale, or GTA has not
-- finished calculating the route yet. Every failed sample is retried, so a
-- waypoint set while the GPS is still thinking can never leave the HUD blank.
local routeKey = nil
local cachedRoute = false
local routeDueAt = 0
local routeFails = 0
local routeSent = nil
local routeDirty = false
local routeOriginX = nil
local routeOriginY = nil
local routeDiag = "-"
local routePrintKey = nil
local routePrintOk = nil

-- Skip identical blip payloads instead of re-sending them every second.
local lastDataKey = nil

-- empty or whitespace-only strings count as "no name", so a missing translation can never blank a row
local function NonEmpty(value)
    if type(value) == "string" then
        local trimmed = value:match("^%s*(.-)%s*$")

        if trimmed ~= "" then
            return trimmed
        end
    end

    return nil
end

local function CountKeys(tbl)
    local count = 0

    for _ in pairs(tbl or {}) do
        count = count + 1
    end

    return count
end

CreateThread(function()
    Wait(0)

    local blips = CountKeys(Config.BlipNamesAr)

    if blips == 0 then
        print("^1[TOT_pauseMap] Arabic name tables did not load. Run 'refresh' in the server console, then restart TOT_pauseMap (a plain restart does not rescan the manifest).^7")
    elseif MapLocale() == "ar" then
        print(("[TOT_pauseMap] Arabic names loaded: %d blips, %d zones, %d map areas"):format(
            blips,
            CountKeys(Config.ZoneNamesAr),
            CountKeys(Config.ZoneLabelsAr)
        ))
    end
end)

local function GetBlipName(sprite, locale)
    local key = locale .. ":" .. sprite
    local name = blipNameCache[key]

    if name == nil then
        name = GetLabelText("BLIP_" .. sprite)

        if name == "NULL" or not name then
            name = ""
        end

        blipNameCache[key] = name
    end

    return name
end

local function GetZoneName(coords, locale)
    local code = GetNameOfZone(coords.x, coords.y, coords.z)

    if locale == "ar" then
        local names = Config.ZoneNamesAr or {}
        return NonEmpty(names[code]) or NonEmpty(Config.ZoneFallbackAr) or "منطقة"
    end

    local label = zoneLabelCache[code]

    if label == nil then
        label = GetLabelText(code)
        zoneLabelCache[code] = label
    end

    return label
end

local function HudColourToHex(colour)
    local hex = hudColourCache[colour]

    if hex then
        return hex
    end

    local r, g, b = GetHudColour(colour)
    hex = ("#%02x%02x%02x"):format(r or 255, g or 255, b or 255)
    hudColourCache[colour] = hex

    return hex
end

local function ScanSprite(sprite, blips, locale, names, fallbackAr, withZones, px, py)
    local found = false
    local blip = GetFirstBlipInfoId(sprite)
    local limit = HUD_BLIP_RANGE * HUD_BLIP_RANGE

    while DoesBlipExist(blip) do
        found = true

        local display = GetBlipInfoIdDisplay(blip)

        if not SKIPPED_DISPLAYS[display] then
            if GetBlipAlpha(blip) > 0 then
                local coords = GetBlipInfoIdCoord(blip)

                if coords.x == coords.x and coords.y == coords.y then
                    -- The corner minimap only sees a few hundred metres, so
                    -- skip far blips before doing the colour/name work. The
                    -- pause map still receives every blip and its full info.
                    local dx, dy = coords.x - px, coords.y - py

                    if withZones or dx * dx + dy * dy <= limit then
                        local info = blipInfo[blip]
                        local entry = {
                            id = blip,
                            x = coords.x,
                            y = coords.y,
                            sprite = sprite,
                            colour = HudColourToHex(GetBlipHudColour(blip)),
                        }

                        local name

                        if locale == "ar" then
                            name = NonEmpty(info and info.titleAr) or NonEmpty(names[sprite]) or fallbackAr
                        else
                            name = NonEmpty(info and info.title) or NonEmpty(names[sprite]) or GetBlipName(sprite, locale)
                        end

                        entry.name = name

                        if withZones then
                            entry.info = info
                            entry.zone = GetZoneName(coords, locale)
                        end

                        entry.flash = IsBlipFlashing(blip) or nil

                        blips[#blips + 1] = entry
                    end
                end
            end
        end

        blip = GetNextBlipInfoId(sprite)
    end

    return found
end

local function GetMapBlips()
    local blips = {}
    local locale = MapLocale()
    local names = Config.BlipNames or {}
    local fallbackAr = NonEmpty(Config.BlipFallbackAr) or "علامة"
    local withZones = bigOpen
    local px, py = 0.0, 0.0

    if locale == "ar" then
        names = Config.BlipNamesAr or {}
    end

    if not withZones then
        local coords = GetEntityCoords(PlayerPedId())
        px, py = coords.x, coords.y
    end

    local function scan(sprite)
        if HIDDEN_SPRITES[sprite] then
            activeSprites[sprite] = nil
            return
        end

        activeSprites[sprite] = ScanSprite(sprite, blips, locale, names, fallbackAr, withZones, px, py) or nil
    end

    if firstBlipScan then
        -- One full scan on startup, then only the cheap incremental path.
        firstBlipScan = false

        for sprite = 0, MAX_SPRITE do
            scan(sprite)
        end
    else
        -- Sprite types already in use are cheap and refresh every tick.
        for sprite in pairs(activeSprites) do
            scan(sprite)
        end

        -- Sweep the remaining sprites in chunks to find new sprite types
        -- without the once-a-second 1001-native burst.
        local first = spriteCursor
        local last = math.min(MAX_SPRITE, first + SPRITE_CHUNK - 1)

        for sprite = first, last do
            if not activeSprites[sprite] then
                scan(sprite)
            end
        end

        spriteCursor = last + 1
        if spriteCursor > MAX_SPRITE then
            spriteCursor = 0
        end
    end

    return blips
end

local function GetWaypoint()
    local blip = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blip) then
        return false
    end

    local coords = GetBlipInfoIdCoord(blip)
    return { x = coords.x, y = coords.y }
end

-- The game knows the route length, so stop sampling there instead of always
-- asking for ROUTE_SAMPLES points. The HUD only needs the part around the
-- player; the pause map asks for the whole route (still capped at ~21 km).
local function GetRoute(maxDistance)
    local route = {}
    local lastX = nil
    local lastY = nil
    local limit = maxDistance or (ROUTE_STEP * ROUTE_SAMPLES)

    local okLength, length = pcall(GetGpsBlipRouteLength)
    if not okLength or type(length) ~= "number" then
        length = 0
    end

    if length > 0 then
        limit = math.min(limit, length + ROUTE_STEP)
    end

    local okGps, gpsFound = pcall(GetGpsBlipRouteFound)
    if not okGps then
        gpsFound = nil
    end

    local okRadar, radarHidden = pcall(IsRadarHidden)
    if not okRadar then
        radarHidden = nil
    end

    local okWp, wpActive = pcall(IsWaypointActive)
    if not okWp then
        wpActive = nil
    end

    local first = nil
    local firstFound = nil
    local stopped = "end"

    for i = 0, ROUTE_SAMPLES do
        local distance = i * ROUTE_STEP

        if distance > limit then
            stopped = "limit"
            break
        end

        local ok, found, coords = pcall(GetPosAlongGpsTypeRoute, true, distance, 0)

        if not ok then
            stopped = "native error: " .. tostring(found)
            break
        end

        if i == 0 then
            firstFound = found
            if found and coords then
                first = ("%.1f,%.1f,%.1f"):format(coords.x, coords.y, coords.z)
            end
        end

        if not found then
            stopped = "not found@" .. i
            break
        end
        if coords.x ~= coords.x then
            stopped = "nan@" .. i
            break
        end
        if coords.x == 0.0 and coords.y == 0.0 then
            stopped = "zero@" .. i
            break
        end
        if lastX then
            if math.abs(coords.x - lastX) < 0.5 and math.abs(coords.y - lastY) < 0.5 then
                stopped = "repeat@" .. i
                break
            end
        end

        route[#route + 1] = { coords.x, coords.y, coords.z }
        lastY = coords.y
        lastX = coords.x
    end

    routeDiag = ("len=%.0f limit=%.0f gps=%s radarHidden=%s wp=%s first=%s stop=%s"):format(
        length, limit, tostring(gpsFound), tostring(radarHidden), tostring(wpActive),
        tostring(first or firstFound), stopped
    )

    if #route > 1 then
        return route
    end

    return false
end

local function HudEnabled()
    return not Config.Hud or Config.Hud.enabled ~= false
end

local function ShouldShowPose()
    if not HudEnabled() then
        return false
    end

    local visible = NetworkIsPlayerActive(PlayerId())

    if visible then
        visible = not bigOpen
            and not IsPauseMenuActive()
            and not IsNuiFocused()
            and not IsScreenFadedOut()
            and not IsPlayerSwitchInProgress()
            and not LocalPlayer.state.pauseMenu
    end

    return visible
end

-- Sent only while the minimap is visible, plus one fresh pose when the big map
-- opens/closes. The big map itself is static, so it needs no pose stream.
local function SendPoseNow(showing, poseData)
    local p = poseData

    if not p then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)

        p = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = GetEntityHeading(ped),
            camYaw = GetGameplayCamRot(2).z,
            speed = GetEntitySpeed(ped),
            inVehicle = vehicle ~= 0,
            hour = GetClockHours() + GetClockMinutes() / 60,
        }
    end

    lastPoseShow = showing and true or false

    SendNUIMessage({
        action = "pose",
        show = lastPoseShow,
        x = p.x,
        y = p.y,
        z = p.z,
        heading = p.heading,
        camYaw = p.camYaw,
        speed = p.speed,
        inVehicle = p.inVehicle,
        hour = p.hour,
    })

    if lastPoseShow then
        lastPose = p
    end
end

-- A stationary player does not need a pose message 30 times a second. Position,
-- camera yaw and clock are checked first; heading, speed and vehicle are only
-- read when one of them actually changed.
local function PoseNeedsSend(coords, camYaw, hour, inVehicle)
    local p = lastPose

    if lastPoseShow ~= true or not p then
        return true
    end

    if math.abs(coords.x - p.x) > 0.01 or math.abs(coords.y - p.y) > 0.01 or math.abs(coords.z - p.z) > 0.05 then
        return true
    end
    if inVehicle ~= p.inVehicle then
        return true
    end
    if math.abs(hour - p.hour) > 0.001 then
        return true
    end

    return math.abs((camYaw - p.camYaw + 540.0) % 360.0 - 180.0) > 0.15
end

local function WaypointKey(waypoint)
    if not waypoint then
        return nil
    end

    return ("%.2f,%.2f"):format(waypoint.x, waypoint.y)
end

-- Route messages are separate from blip messages: while driving, only the
-- short route array has to cross the NUI bridge, not the whole blip list.
local function SendRoute(route)
    if route == routeSent then
        return
    end

    routeSent = route
    routeDirty = true
    SendNUIMessage({ action = "route", route = route })
end

-- A failed sample is never final. While a waypoint exists but no polyline was
-- produced, GTA is probably still calculating it; retry with a small backoff
-- instead of waiting for the waypoint or the player to move.
local function UpdateRoute(force)
    local waypoint = GetWaypoint()
    local now = GetGameTimer()
    local key = WaypointKey(waypoint)

    if not waypoint then
        routeKey = nil
        cachedRoute = false
        routeDueAt = 0
        routeFails = 0
        routeOriginX = nil
        routeOriginY = nil

        if routePrintKey ~= nil then
            print("[TOT_pauseMap] route cleared (no waypoint)")
            routePrintKey = nil
            routePrintOk = nil
        end

        SendRoute(false)
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local changed = key ~= routeKey
    local missing = not cachedRoute
    local moved = routeOriginX ~= nil
        and (math.abs(coords.x - routeOriginX) + math.abs(coords.y - routeOriginY) >= ROUTE_MOVE)
    local retryReady = routeDueAt == 0 or now >= routeDueAt

    if not (force or changed or moved or (missing and retryReady)) then
        return
    end

    routeKey = key

    -- The corner minimap only shows a few hundred metres, so sampling 1.2 km
    -- is plenty there. The pause map gets the full route while it is open.
    local limit = bigOpen and (ROUTE_STEP * ROUTE_SAMPLES) or ROUTE_HUD

    -- Some HUD resources leave the radar disabled; if GTA has quietly marked
    -- the GPS inactive, force it back on while we still have no route so the
    -- route native has something to read.
    if missing and SetGpsActive then
        pcall(SetGpsActive, true)
    end

    local ok, sampled = pcall(GetRoute, limit)

    local route

    if ok then
        route = sampled or false
    else
        route = false
        routeDiag = "GetRoute error: " .. tostring(sampled)
    end

    cachedRoute = route
    routeOriginX = coords.x
    routeOriginY = coords.y

    if route then
        routeDueAt = 0
        routeFails = 0
    else
        routeFails = math.min(routeFails + 1, 4)
        routeDueAt = now + ROUTE_RETRY * routeFails
    end

    local success = route ~= false

    if key ~= routePrintKey or success ~= routePrintOk then
        routePrintKey = key
        routePrintOk = success

        if success then
            print(("[TOT_pauseMap] route ok: %d points (%s)"):format(#route, routeDiag))
        else
            print(("[TOT_pauseMap] route empty: %s"):format(routeDiag))
        end
    end

    SendRoute(route)
end

local function DataFingerprint(blips, waypoint, withZones)
    local parts = {}

    for index = 1, #blips do
        local b = blips[index]
        local info = b.info
        local title = info and tostring(info.title or "") or ""
        local titleAr = info and tostring(info.titleAr or "") or ""

        parts[index] = ("%s,%.2f,%.2f,%s,%s,%s,%s|%s"):format(
            tostring(b.id), b.x, b.y, tostring(b.sprite), tostring(b.colour),
            b.flash and "1" or "0", title, titleAr
        )
    end

    return table.concat(parts, ";") .. "#" .. (waypoint and WaypointKey(waypoint) or "-") .. "#" .. tostring(withZones)
end

-- Blip payloads are only re-sent when something in them actually changed.
-- The route is included as well, so an older NUI page that only knows the
-- data message still receives it; the route-only message remains the fast path.
local function SendMapData(force)
    local waypoint = GetWaypoint()
    local withZones = bigOpen
    local blips = GetMapBlips()
    local fingerprint = DataFingerprint(blips, waypoint, withZones)

    lastDataAt = GetGameTimer()

    if not force and not routeDirty and fingerprint == lastDataKey then
        return
    end

    lastDataKey = fingerprint
    routeDirty = false

    SendNUIMessage({
        action = "data",
        blips = blips,
        waypoint = waypoint,
        route = cachedRoute,
    })
end

-- Route sampling is independent from the minimap pose stream: a waypoint is
-- tracked even while the HUD is hidden, so the line is ready the moment the
-- minimap appears. Sampling itself only happens on waypoint change, movement
-- or a retry, so this loop is just a few cheap checks per second.
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while true do
        local ok, err = pcall(UpdateRoute, false)

        if ok then
            Wait(500)
        else
            print(("[TOT_pauseMap] route thread error: %s"):format(tostring(err)))
            Wait(2000)
        end
    end
end)

local SOUNDSET = "HUD_FRONTEND_DEFAULT_SOUNDSET"

local sounds = {
    nav = "NAV_UP_DOWN",
    side = "NAV_LEFT_RIGHT",
    select = "SELECT",
    back = "BACK",
    waypoint = "WAYPOINT_SET",
}

local function MapSound(name)
    if sounds[name] then
        PlaySoundFrontend(-1, sounds[name], SOUNDSET, true)
    end
end

local function PauseHoldMap(value)
    if GetResourceState("TOT_pauseMenu") == "started" then
        exports.TOT_pauseMenu:PauseHold("map", value)
    end
end

local function MapPayload()
    local payload = {}

    for key, value in pairs(Config) do
        payload[key] = value
    end

    payload.Locale = MapLocale()
    payload.Strings = Config.Strings or {}
    payload.Theme = MapTheme()

    return payload
end

local function OpenBig()
    if bigOpen then
        return
    end

    MapSound("select")
    bigOpen = true
    lastMenuTime = GetGameTimer()
    DisplayRadar(false)
    PauseHoldMap(true)
    SetNuiFocus(true, true)

    local payload = MapPayload()

    -- Fresh pose before the mode switch, so the map opens centered on the player.
    -- The streamer sends the blip payload on its next tick.
    SendPoseNow(false)
    dataDue = GetGameTimer()
    SendNUIMessage({
        action = "big",
        open = true,
        locale = payload.Locale,
        rtl = payload.Locale == "ar",
        strings = payload.Strings,
        theme = payload.Theme,
        hud = payload.Hud,
    })

    -- Full route for the pause map; while the map is open the retry loop below
    -- finishes it if GTA has not calculated it yet.
    UpdateRoute(true)
end

local function CloseBig()
    if bigOpen then
        MapSound("back")
        PauseHoldMap(false)
    end

    if zoomSound then
        StopSound(zoomSound)
        ReleaseSoundId(zoomSound)
        zoomSound = nil
    end

    bigOpen = false
    lastMenuTime = GetGameTimer()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "big", open = false })
    SendPoseNow(ShouldShowPose())

    -- Back to the short HUD route, starting at the player again.
    UpdateRoute(true)
end

RegisterNUICallback("ready", function(data, cb)
    -- A (re)loaded NUI page starts with no blips/route. Force the next payload
    -- to be sent in full, including the route.
    lastDataKey = nil
    routeKey = nil
    cachedRoute = false
    routeDueAt = 0
    routeFails = 0
    routeSent = nil
    routeDirty = false
    lastDataAt = 0
    print(("[TOT_pauseMap] NUI ready (%s)"):format(tostring(data and data.version or "no version")))
    cb(MapPayload())

    UpdateRoute(true)
end)

RegisterNUICallback("close", function(_, cb)
    cb(1)
    CloseBig()
end)

RegisterNUICallback("sound", function(data, cb)
    cb(1)
    MapSound(data.name)
end)

RegisterNUICallback("loop", function(data, cb)
    cb(1)

    if data.on then
        if not zoomSound then
            zoomSound = GetSoundId()
            PlaySoundFrontend(zoomSound, "MAP_ZOOM", SOUNDSET, true)
        end
    elseif zoomSound then
        StopSound(zoomSound)
        ReleaseSoundId(zoomSound)
        zoomSound = nil
    end
end)

RegisterNUICallback("waypoint", function(data, cb)
    cb(1)
    MapSound("waypoint")

    if data.clear then
        SetWaypointOff()
    else
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
    end

    -- Show the waypoint at once and try the route immediately. If GTA is still
    -- calculating it, UpdateRoute schedules its own retries.
    SendMapData(true)
    UpdateRoute(true)
end)

-- Only two natives per frame: keep P from opening GTA's pause menu and open the map on release.
CreateThread(function()
    DisplayRadar(false)

    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    local radarTick = 60

    while true do
        DisableControlAction(0, 199, true)

        -- Radar stays off without a per-frame native call.
        if radarTick >= 60 then
            DisplayRadar(false)
            radarTick = 0
        end
        radarTick = radarTick + 1

        if IsDisabledControlJustReleased(0, 199) then
            if IsPauseMenuActive() or IsNuiFocused() or LocalPlayer.state.pauseMenu then
                lastMenuTime = GetGameTimer()
            elseif not bigOpen
                and NetworkIsPlayerActive(PlayerId())
                and GetGameTimer() - lastMenuTime > 500
            then
                OpenBig()
            end
        end

        Wait(0)
    end
end)

-- One streamer instead of two permanent loops. The minimap wakes it at 30 Hz;
-- the big map has no pose stream at all (the game is paused while it is open)
-- and only asks for a payload on open or after a waypoint change.
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    while true do
        local showing = not bigOpen and ShouldShowPose()

        if showing then
            local now = GetGameTimer()
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local camYaw = GetGameplayCamRot(2).z
            local hour = GetClockHours() + GetClockMinutes() / 60
            local vehicle = GetVehiclePedIsIn(ped, false)

            -- Only touch the remaining natives and the NUI bridge when the
            -- player, camera or clock actually changed.
            if PoseNeedsSend(coords, camYaw, hour, vehicle ~= 0) then
                SendPoseNow(true, {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    heading = GetEntityHeading(ped),
                    camYaw = camYaw,
                    speed = GetEntitySpeed(ped),
                    inVehicle = vehicle ~= 0,
                    hour = hour,
                })
            end

            if now - lastDataAt >= 1000 then
                SendMapData(false)
            end

            Wait(33)
        elseif bigOpen then
            if lastPoseShow ~= false then
                SendNUIMessage({ action = "pose", show = false })
                lastPoseShow = false
            end

            local now = GetGameTimer()

            if dataDue and now >= dataDue then
                dataDue = nil
                SendMapData(true)
            end

            Wait(50)
        else
            if lastPoseShow ~= false then
                SendNUIMessage({ action = "pose", show = false })
                lastPoseShow = false
            end

            -- While hidden, react quickly to a UI closing without polling at
            -- full rate: 10 checks per second is cheap and imperceptible.
            Wait(100)
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    if bigOpen then
        SetNuiFocus(false, false)
        PauseHoldMap(false)
    end

    DisplayRadar(true)
end)

exports("OpenBig", OpenBig)
exports("CloseBig", CloseBig)

exports("BigZoom", function(zoom, x, y, hs, flat)
    SendNUIMessage({
        action = "bigZoom",
        zoom = zoom,
        x = x,
        y = y,
        hs = hs,
        flat = flat,
    })
end)

exports("SetBlipInfo", function(id, info)
    blipInfo[id] = info
end)

end
