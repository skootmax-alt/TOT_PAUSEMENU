-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
Config = {}

-- UI language: 'en' = English, 'ar' = Arabic ('english' / 'arabic' also work).
-- Category names are in categories.lua (label / labelAr), blip and zone names in
-- blips_config.lua, and the remaining map text is in Config.Strings at the bottom of this file.
Config.Locale = 'ar'

-- When true, the map uses the language and the shared colours (accent, panel, panel2,
-- text, title) from TOT_pauseMenu/config.lua automatically. Set to false to control the
-- map independently with Config.Locale and Config.Theme below.
Config.FollowPauseMenu = true

-- map page colours: any CSS colour works ('#rrggbb', 'rgba(r, g, b, a)', ...)
-- When Config.FollowPauseMenu = true, accent / panel / panel2 / text / title come from the pause menu.
Config.Theme = {
    panel = '#1f1f2b',      -- category panel and blip info card
    panel2 = '#1f1f2b',     -- panel far side
    accent = '#ee7bb2',     -- info card line and category highlight
    text = '#e5e9ec',       -- side panel rows
    title = '#e4e6ea',      -- panel title
    hint = '#ffffff',       -- key hints at the bottom (always from this table)
    map = '#08101a',        -- pause map background (always from this table)
}

-- the GPS line to the waypoint
Config.Route = {
    colour = '#5fe3c8',
    width = 9,          -- pause map, px
    miniWidth = 6,      -- minimap, px
}

-- the waypoint pin (sizes in rem, 1rem = 10px at 1080p)
Config.Waypoint = {
    colour = '#5fe3c8',
    border = '#0b0f14',  -- outline and the dot in the middle
    size = 3.8,
    miniSize = 2.8,
}

-- every blip shows; while a category is open on the pause map only its blips do, plus these sprite ids,
-- flashing blips and the blip the waypoint is on
Config.AlwaysShow = {}

-- map blips (html/blips/<GTA blip id>.webp)
--   style 'plain' = the icon as it is
--   style 'box'   = black icon in a rounded box with a small tail
--   style 'round' = black icon in a circle with a small tail
Config.Blips = {
    style = 'round',
    background = '#ee7bb2',   -- box / round background when GTA gives no colour (normally the blip's own colour)
    border = '#1a1a1a',       -- box / round border
    icon = '#000000',         -- box / round icon colour (black)
    size = 3.0,               -- pause map, rem
    miniSize = 2.2,           -- minimap, rem
}

-- the player: grey circle, darker border, white arrow; grows when the pause map zooms out, up to maxSize
Config.Player = {
    fill = '#4b4f58',
    border = '#15171c',
    arrow = '#ffffff',
    size = 2.6,         -- pause map, close
    maxSize = 3.8,      -- pause map, far out
    grow = 0.3,         -- extra size per zoom step out
    miniSize = 2.2,
}

-- how close the maps look (lower = wider view)
Config.Zoom = {
    open = 7.8,         -- pause map zoom when it opens (= max: fully zoomed in)
    max = 7.8,          -- pause map closest
    min = 5.0,          -- pause map farthest
    mini = 2.0,         -- minimap zoom (higher = closer)
    ease = 320,         -- zoom smoothness, ms (higher = slower, softer)
}

-- pause map: zooming out, buildings sink and fade away, the small ones first, the biggest last; zooming in brings them back
Config.Buildings = {
    fadeStart = 7.6,    -- zoom where the smallest start to fade (fully in = every building)
    fadeEnd = 5.0,      -- zoom where every building up to maxSize is gone (= Zoom.min)
    maxSize = 38,       -- m (square root of the footprint): the size gone at fadeEnd; bigger ones stay
    band = 25,          -- m: how soft the fade is between sizes
    ease = 400,         -- ms: how slowly buildings sink / come back (higher = slower)
}

-- area names: fully zoomed out the counties, one step in the districts (names that would sit on each other are
-- left out), closer in nothing. Only the area in the middle gets the white border, the others show a dimmed name
Config.Zones = {
    countyZoom = 5.4,       -- counties below this zoom
    districtZoom = 6.6,     -- districts between countyZoom and this
    ease = 200,             -- ms: fade in / out
    border = '#ffffff',
    name = '#ffffff',
    dim = 0.5,              -- names of regions not in the middle
    countySize = 4.2,       -- rem
    districtSize = 2.5,     -- rem
    focus = 1.25,           -- the name in the middle is this much bigger
    borderWidth = 4,        -- px
    -- bigger districts get bigger names; a name's colour comes from a word in it
    kinds = {
        { colour = '#8fdcb4', words = { 'Park', 'Forest', 'Wilderness', 'Golf', 'Valley', 'Vinewood Hills', 'Tongva', 'Farm', 'Grapeseed' } },
        { colour = '#e2b98a', words = { 'Mount', 'Canyon', 'Desert', 'Pass', 'Range', 'Quartz' } },
        { colour = '#b9dcef', words = { 'Sea', 'Reservoir', 'Lago', 'River', 'Creek', 'Beach', 'Cove' } },
    },
}

-- pause map centre ring: the blip nearest the middle (within snap rem) is focused: the ring snaps on it, it grows,
-- its name, distance and info card show; a click or ENTER sets the waypoint there
Config.Focus = {
    snap = 2.4,             -- rem: how close to the ring a blip must be (same at every zoom, like GTA)
    sticky = 0.45,          -- dragging slows to this while a blip is in the ring
    pull = 160,             -- ms: after a drag the map slides the blip into the ring
    grow = 1.4,             -- focused blip size
    ringGrow = 1.2,         -- the ring is this much bigger (eased) while it sits on a blip
    units = 'mi',           -- 'mi' or 'km'
    accent = '#ee7bb2',     -- card top line and icon box
    defaultText = '',       -- text under the title for blips without SetBlipInfo text ('' = none)
}

-- day / night look of both maps, by the game clock (hours): the day look from dawn to dusk, eased over fade hours
Config.Day = {
    dawn = 6,
    dusk = 20,
    fade = 1,
}

-- HUD: the corner minimap and the key hints on the pause map.
-- Set enabled = false to disable the corner minimap completely: it is not
-- drawn, no pose updates are sent, and it uses no frames. The pause map still
-- works normally.
Config.Hud = {
    enabled = true,         -- false hides the corner minimap
    hints = true,           -- false hides the pause-map key hints
}

-- minimap
Config.Minimap = {
    fps = 30,               -- draws at most this often (less lag)
    pitch = 36,             -- tilt on foot and in a vehicle (lower = more 3D, 90 = straight down)
    height = 0.6,           -- building heights (1 = real)
    speedZoom = 0.8,        -- driving fast it zooms out to this share of the normal zoom
    buildingSize = 22,      -- m: smaller buildings are not drawn on the minimap
    turn = 70,              -- ms: how softly it turns with the camera
}

-- pause map mouse: a drag and a right-drag turn ease to where the mouse put them (ms, higher = softer)
Config.Drag = {
    move = 70,
    turn = 90,
}

-- pause map camera tilt: near tilted (3D), lying down slowly as you zoom out, straight down (90) far out
Config.Tilt = {
    near = 48,          -- degrees when zoomed in
    far = 90,           -- degrees when zoomed out
    nearZoom = 7.4,     -- tilt is 'near' from this zoom in
    farZoom = 5.0,      -- tilt is 'far' from this zoom out
}

-- text used by the map page; labelAr, blips_config.lua and these strings are used when Config.Locale = 'ar'
Config.Strings = {
    en = {
        nothing = 'Nothing on the map',
        nearest = 'Nearest',
        blip = 'Blip',
        recenter = 'RECENTER',
        flat = '2D VIEW',
        destination = 'SET DESTINATION',
        close = 'CLOSE MENU',
        mi = 'mi',
        km = 'km',
        m = 'm',
    },
    ar = {
        nothing = 'لا يوجد شيء على الخريطة',
        nearest = 'الأقرب',
        blip = 'علامة',
        recenter = 'إعادة التمركز',
        flat = 'عرض ثنائي الأبعاد',
        destination = 'تحديد الوجهة',
        close = 'إغلاق القائمة',
        mi = 'ميل',
        km = 'كم',
        m = 'م',
    },
}

local function PauseRunning()
    return Config.FollowPauseMenu ~= false and GetResourceState('TOT_pauseMenu') == 'started'
end

-- active language key ('en' or 'ar'); follows TOT_pauseMenu when Config.FollowPauseMenu is true
function MapLocale()
    local locale = Config.Locale

    if PauseRunning() then
        local ok, shared = pcall(function()
            return exports.TOT_pauseMenu:GetLocale()
        end)

        if ok and type(shared) == 'string' then
            locale = shared
        end
    end

    locale = tostring(locale or 'en'):lower()

    if locale == 'arabic' then
        locale = 'ar'
    elseif locale == 'english' then
        locale = 'en'
    end

    if locale == 'ar' then
        return 'ar'
    end

    return 'en'
end

-- map colours; the shared pause-menu keys win while following the pause menu
function MapTheme()
    local theme = {}

    for key, value in pairs(Config.Theme or {}) do
        theme[key] = value
    end

    if PauseRunning() then
        local ok, shared = pcall(function()
            return exports.TOT_pauseMenu:GetTheme()
        end)

        if ok and type(shared) == 'table' then
            for _, key in ipairs({ 'accent', 'panel', 'panel2', 'text', 'title' }) do
                if shared[key] ~= nil then
                    theme[key] = shared[key]
                end
            end
        end
    end

    return theme
end
