-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
-- TOT bundle: TOT_pauseMenu client
-- module: TOT_pauseMenu/client/keys.lua
do
local CONTROL_NAMES = {
    "NEXT_CAMERA",
    "LOOK_LR",
    "LOOK_UD",
    "LOOK_UP_ONLY",
    "LOOK_DOWN_ONLY",
    "LOOK_LEFT_ONLY",
    "LOOK_RIGHT_ONLY",
    "CINEMATIC_SLOWMO",
    "SCRIPTED_FLY_UD",
    "SCRIPTED_FLY_LR",
    "SCRIPTED_FLY_ZUP",
    "SCRIPTED_FLY_ZDOWN",
    "WEAPON_WHEEL_UD",
    "WEAPON_WHEEL_LR",
    "WEAPON_WHEEL_NEXT",
    "WEAPON_WHEEL_PREV",
    "SELECT_NEXT_WEAPON",
    "SELECT_PREV_WEAPON",
    "SKIP_CUTSCENE",
    "CHARACTER_WHEEL",
    "MULTIPLAYER_INFO",
    "SPRINT",
    "JUMP",
    "ENTER",
    "ATTACK",
    "AIM",
    "LOOK_BEHIND",
    "PHONE",
    "SPECIAL_ABILITY",
    "SPECIAL_ABILITY_SECONDARY",
    "MOVE_LR",
    "MOVE_UD",
    "MOVE_UP_ONLY",
    "MOVE_DOWN_ONLY",
    "MOVE_LEFT_ONLY",
    "MOVE_RIGHT_ONLY",
    "DUCK",
    "SELECT_WEAPON",
    "PICKUP",
    "SNIPER_ZOOM",
    "SNIPER_ZOOM_IN_ONLY",
    "SNIPER_ZOOM_OUT_ONLY",
    "SNIPER_ZOOM_IN_SECONDARY",
    "SNIPER_ZOOM_OUT_SECONDARY",
    "COVER",
    "RELOAD",
    "TALK",
    "DETONATE",
    "HUD_SPECIAL",
    "ARREST",
    "ACCURATE_AIM",
    "CONTEXT",
    "CONTEXT_SECONDARY",
    "WEAPON_SPECIAL",
    "WEAPON_SPECIAL_TWO",
    "DIVE",
    "DROP_WEAPON",
    "DROP_AMMO",
    "THROW_GRENADE",
    "VEH_MOVE_LR",
    "VEH_MOVE_UD",
    "VEH_MOVE_UP_ONLY",
    "VEH_MOVE_DOWN_ONLY",
    "VEH_MOVE_LEFT_ONLY",
    "VEH_MOVE_RIGHT_ONLY",
    "VEH_SPECIAL",
    "VEH_GUN_LR",
    "VEH_GUN_UD",
    "VEH_AIM",
    "VEH_ATTACK",
    "VEH_ATTACK2",
    "VEH_ACCELERATE",
    "VEH_BRAKE",
    "VEH_DUCK",
    "VEH_HEADLIGHT",
    "VEH_EXIT",
    "VEH_HANDBRAKE",
    "VEH_HOTWIRE_LEFT",
    "VEH_HOTWIRE_RIGHT",
    "VEH_LOOK_BEHIND",
    "VEH_CIN_CAM",
    "VEH_NEXT_RADIO",
    "VEH_PREV_RADIO",
    "VEH_NEXT_RADIO_TRACK",
    "VEH_PREV_RADIO_TRACK",
    "VEH_RADIO_WHEEL",
    "VEH_HORN",
    "VEH_FLY_THROTTLE_UP",
    "VEH_FLY_THROTTLE_DOWN",
    "VEH_FLY_YAW_LEFT",
    "VEH_FLY_YAW_RIGHT",
    "VEH_PASSENGER_AIM",
    "VEH_PASSENGER_ATTACK",
    "VEH_SPECIAL_ABILITY_FRANKLIN",
    "VEH_STUNT_UD",
    "VEH_CINEMATIC_UD",
    "VEH_CINEMATIC_UP_ONLY",
    "VEH_CINEMATIC_DOWN_ONLY",
    "VEH_CINEMATIC_LR",
    "VEH_SELECT_NEXT_WEAPON",
    "VEH_SELECT_PREV_WEAPON",
    "VEH_ROOF",
    "VEH_JUMP",
    "VEH_GRAPPLING_HOOK",
    "VEH_SHUFFLE",
    "VEH_DROP_PROJECTILE",
    "VEH_MOUSE_CONTROL_OVERRIDE",
    "VEH_FLY_ROLL_LR",
    "VEH_FLY_ROLL_LEFT_ONLY",
    "VEH_FLY_ROLL_RIGHT_ONLY",
    "VEH_FLY_PITCH_UD",
    "VEH_FLY_PITCH_UP_ONLY",
    "VEH_FLY_PITCH_DOWN_ONLY",
    "VEH_FLY_UNDERCARRIAGE",
    "VEH_FLY_ATTACK",
    "VEH_FLY_SELECT_NEXT_WEAPON",
    "VEH_FLY_SELECT_PREV_WEAPON",
    "VEH_FLY_SELECT_TARGET_LEFT",
    "VEH_FLY_SELECT_TARGET_RIGHT",
    "VEH_FLY_VERTICAL_FLIGHT_MODE",
    "VEH_FLY_DUCK",
    "VEH_FLY_ATTACK_CAMERA",
    "VEH_FLY_MOUSE_CONTROL_OVERRIDE",
    "VEH_SUB_TURN_LR",
    "VEH_SUB_TURN_LEFT_ONLY",
    "VEH_SUB_TURN_RIGHT_ONLY",
    "VEH_SUB_PITCH_UD",
    "VEH_SUB_PITCH_UP_ONLY",
    "VEH_SUB_PITCH_DOWN_ONLY",
    "VEH_SUB_THROTTLE_UP",
    "VEH_SUB_THROTTLE_DOWN",
    "VEH_SUB_ASCEND",
    "VEH_SUB_DESCEND",
    "VEH_SUB_TURN_HARD_LEFT",
    "VEH_SUB_TURN_HARD_RIGHT",
    "VEH_SUB_MOUSE_CONTROL_OVERRIDE",
    "VEH_PUSHBIKE_PEDAL",
    "VEH_PUSHBIKE_SPRINT",
    "VEH_PUSHBIKE_FRONT_BRAKE",
    "VEH_PUSHBIKE_REAR_BRAKE",
    "MELEE_ATTACK_LIGHT",
    "MELEE_ATTACK_HEAVY",
    "MELEE_ATTACK_ALTERNATE",
    "MELEE_BLOCK",
    "PARACHUTE_DEPLOY",
    "PARACHUTE_DETACH",
    "PARACHUTE_TURN_LR",
    "PARACHUTE_TURN_LEFT_ONLY",
    "PARACHUTE_TURN_RIGHT_ONLY",
    "PARACHUTE_PITCH_UD",
    "PARACHUTE_PITCH_UP_ONLY",
    "PARACHUTE_PITCH_DOWN_ONLY",
    "PARACHUTE_BRAKE_LEFT",
    "PARACHUTE_BRAKE_RIGHT",
    "PARACHUTE_SMOKE",
    "PARACHUTE_PRECISION_LANDING",
    "MAP",
    "SELECT_WEAPON_UNARMED",
    "SELECT_WEAPON_MELEE",
    "SELECT_WEAPON_HANDGUN",
    "SELECT_WEAPON_SHOTGUN",
    "SELECT_WEAPON_SMG",
    "SELECT_WEAPON_AUTO_RIFLE",
    "SELECT_WEAPON_SNIPER",
    "SELECT_WEAPON_HEAVY",
    "SELECT_WEAPON_SPECIAL",
    "SELECT_CHARACTER_MICHAEL",
    "SELECT_CHARACTER_FRANKLIN",
    "SELECT_CHARACTER_TREVOR",
    "SELECT_CHARACTER_MULTIPLAYER",
    "SAVE_REPLAY_CLIP",
    "SPECIAL_ABILITY_PC",
    "CELLPHONE_UP",
    "CELLPHONE_DOWN",
    "CELLPHONE_LEFT",
    "CELLPHONE_RIGHT",
    "CELLPHONE_SELECT",
    "CELLPHONE_CANCEL",
    "CELLPHONE_OPTION",
    "CELLPHONE_EXTRA_OPTION",
    "CELLPHONE_SCROLL_FORWARD",
    "CELLPHONE_SCROLL_BACKWARD",
    "CELLPHONE_CAMERA_FOCUS_LOCK",
    "CELLPHONE_CAMERA_GRID",
    "CELLPHONE_CAMERA_SELFIE",
    "CELLPHONE_CAMERA_DOF",
    "CELLPHONE_CAMERA_EXPRESSION",
    "FRONTEND_DOWN",
    "FRONTEND_UP",
    "FRONTEND_LEFT",
    "FRONTEND_RIGHT",
    "FRONTEND_RDOWN",
    "FRONTEND_RUP",
    "FRONTEND_RLEFT",
    "FRONTEND_RRIGHT",
    "FRONTEND_AXIS_X",
    "FRONTEND_AXIS_Y",
    "FRONTEND_RIGHT_AXIS_X",
    "FRONTEND_RIGHT_AXIS_Y",
    "FRONTEND_PAUSE",
    "FRONTEND_PAUSE_ALTERNATE",
    "FRONTEND_ACCEPT",
    "FRONTEND_CANCEL",
    "FRONTEND_X",
    "FRONTEND_Y",
    "FRONTEND_LB",
    "FRONTEND_RB",
    "FRONTEND_LT",
    "FRONTEND_RT",
    "FRONTEND_LS",
    "FRONTEND_RS",
    "FRONTEND_LEADERBOARD",
    "FRONTEND_SOCIAL_CLUB",
    "FRONTEND_SOCIAL_CLUB_SECONDARY",
    "FRONTEND_DELETE",
    "FRONTEND_ENDSCREEN_ACCEPT",
    "FRONTEND_ENDSCREEN_EXPAND",
    "FRONTEND_SELECT",
    "SCRIPT_LEFT_AXIS_X",
    "SCRIPT_LEFT_AXIS_Y",
    "SCRIPT_RIGHT_AXIS_X",
    "SCRIPT_RIGHT_AXIS_Y",
    "SCRIPT_RUP",
    "SCRIPT_RDOWN",
    "SCRIPT_RLEFT",
    "SCRIPT_RRIGHT",
    "SCRIPT_LB",
    "SCRIPT_RB",
    "SCRIPT_LT",
    "SCRIPT_RT",
    "SCRIPT_LS",
    "SCRIPT_RS",
    "SCRIPT_PAD_UP",
    "SCRIPT_PAD_DOWN",
    "SCRIPT_PAD_LEFT",
    "SCRIPT_PAD_RIGHT",
    "SCRIPT_SELECT",
    "CURSOR_ACCEPT",
    "CURSOR_CANCEL",
    "CURSOR_X",
    "CURSOR_Y",
    "CURSOR_SCROLL_UP",
    "CURSOR_SCROLL_DOWN",
    "ENTER_CHEAT_CODE",
    "INTERACTION_MENU",
    "MP_TEXT_CHAT_ALL",
    "MP_TEXT_CHAT_TEAM",
    "MP_TEXT_CHAT_FRIENDS",
    "MP_TEXT_CHAT_CREW",
    "PUSH_TO_TALK",
    "CREATOR_LS",
    "CREATOR_RS",
    "CREATOR_LT",
    "CREATOR_RT",
    "CREATOR_MENU_TOGGLE",
    "CREATOR_ACCEPT",
    "CREATOR_DELETE",
    "ATTACK2",
    "RAPPEL_JUMP",
    "RAPPEL_LONG_JUMP",
    "RAPPEL_SMASH_WINDOW",
    "PREV_WEAPON",
    "NEXT_WEAPON",
    "MELEE_ATTACK1",
    "MELEE_ATTACK2",
    "WHISTLE",
    "MOVE_LEFT",
    "MOVE_RIGHT",
    "MOVE_UP",
    "MOVE_DOWN",
    "LOOK_LEFT",
    "LOOK_RIGHT",
    "LOOK_UP",
    "LOOK_DOWN",
    "SNIPER_ZOOM_IN",
    "SNIPER_ZOOM_OUT",
    "SNIPER_ZOOM_IN_ALTERNATE",
    "SNIPER_ZOOM_OUT_ALTERNATE",
    "VEH_MOVE_LEFT",
    "VEH_MOVE_RIGHT",
    "VEH_MOVE_UP",
    "VEH_MOVE_DOWN",
    "VEH_GUN_LEFT",
    "VEH_GUN_RIGHT",
    "VEH_GUN_UP",
    "VEH_GUN_DOWN",
    "VEH_LOOK_LEFT",
    "VEH_LOOK_RIGHT",
    "REPLAY_START_STOP_RECORDING",
    "REPLAY_START_STOP_RECORDING_SECONDARY",
    "SCALED_LOOK_LR",
    "SCALED_LOOK_UD",
    "SCALED_LOOK_UP_ONLY",
    "SCALED_LOOK_DOWN_ONLY",
    "SCALED_LOOK_LEFT_ONLY",
    "SCALED_LOOK_RIGHT_ONLY",
    "REPLAY_MARKER_DELETE",
    "REPLAY_CLIP_DELETE",
    "REPLAY_PAUSE",
    "REPLAY_REWIND",
    "REPLAY_FFWD",
    "REPLAY_NEWMARKER",
    "REPLAY_RECORD",
    "REPLAY_SCREENSHOT",
    "REPLAY_HIDEHUD",
    "REPLAY_STARTPOINT",
    "REPLAY_ENDPOINT",
    "REPLAY_ADVANCE",
    "REPLAY_BACK",
    "REPLAY_TOOLS",
    "REPLAY_RESTART",
    "REPLAY_SHOWHOTKEY",
    "REPLAY_CYCLEMARKERLEFT",
    "REPLAY_CYCLEMARKERRIGHT",
    "REPLAY_FOVINCREASE",
    "REPLAY_FOVDECREASE",
    "REPLAY_CAMERAUP",
    "REPLAY_CAMERADOWN",
    "REPLAY_SAVE",
    "REPLAY_TOGGLETIME",
    "REPLAY_TOGGLETIPS",
    "REPLAY_PREVIEW",
    "REPLAY_TOGGLE_TIMELINE",
    "REPLAY_TIMELINE_PICKUP_CLIP",
    "REPLAY_TIMELINE_DUPLICATE_CLIP",
    "REPLAY_TIMELINE_PLACE_CLIP",
    "REPLAY_CTRL",
    "REPLAY_TIMELINE_SAVE",
    "REPLAY_PREVIEW_AUDIO",
    "VEH_DRIVE_LOOK",
    "VEH_DRIVE_LOOK2",
    "VEH_FLY_ATTACK2",
    "RADIO_WHEEL_UD",
    "RADIO_WHEEL_LR",
    "VEH_SLOWMO_UD",
    "VEH_SLOWMO_UP_ONLY",
    "VEH_SLOWMO_DOWN_ONLY",
    "VEH_HYDRAULICS_CONTROL_TOGGLE",
    "VEH_HYDRAULICS_CONTROL_LEFT",
    "VEH_HYDRAULICS_CONTROL_RIGHT",
    "VEH_HYDRAULICS_CONTROL_UP",
    "VEH_HYDRAULICS_CONTROL_DOWN",
    "VEH_HYDRAULICS_CONTROL_LR",
    "VEH_HYDRAULICS_CONTROL_UD",
    "SWITCH_VISOR",
    "VEH_MELEE_HOLD",
    "VEH_MELEE_LEFT",
    "VEH_MELEE_RIGHT",
    "MAP_POI",
    "REPLAY_SNAPMATIC_PHOTO",
    "VEH_CAR_JUMP",
    "VEH_ROCKET_BOOST",
    "VEH_FLY_BOOST",
    "VEH_PARACHUTE",
    "VEH_BIKE_WINGS",
    "VEH_FLY_BOMB_BAY",
    "VEH_FLY_COUNTER",
    "VEH_TRANSFORM",
    "QUAD_LOCO_REVERSE",
    "RESPAWN_FASTER",
    "HUDMARKER_SELECT",
    "EAT_SNACK",
    "USE_ARMOR",
}

local CONTROL_INDEX = {}
for index, name in ipairs(CONTROL_NAMES) do
    CONTROL_INDEX[name] = index - 1
end

local KEY_LABELS = {
    [100] = "LMB",
    [101] = "RMB",
    [102] = "MMB",
    [103] = "MOUSE 4",
    [104] = "MOUSE 5",
    [105] = "MOUSE 6",
    [106] = "MOUSE 7",
    [107] = "MOUSE 8",
    [108] = "MOUSE",
    [109] = "MOUSE",
    [110] = "MOUSE",
    [111] = "MOUSE",
    [112] = "MOUSE",
    [113] = "MOUSE",
    [114] = "MOUSE",
    [115] = "WHEEL \226\134\145",
    [116] = "WHEEL \226\134\147",
    [117] = "WHEEL",
    [130] = "NUM -",
    [131] = "NUM +",
    [132] = "NUM .",
    [133] = "NUM /",
    [134] = "NUM *",
    [135] = "NUM ENTER",
    [136] = "NUM 0",
    [137] = "NUM 1",
    [138] = "NUM 2",
    [139] = "NUM 3",
    [140] = "NUM 4",
    [141] = "NUM 5",
    [142] = "NUM 6",
    [143] = "NUM 7",
    [144] = "NUM 8",
    [145] = "NUM 9",
    [146] = "NUM =",
    [147] = "NUM .",
    [148] = "NUM /",
    [149] = "NUM *",
    [170] = "F1",
    [171] = "F2",
    [172] = "F3",
    [173] = "F4",
    [174] = "F5",
    [175] = "F6",
    [176] = "F7",
    [177] = "F8",
    [178] = "F9",
    [179] = "F10",
    [180] = "F11",
    [181] = "F12",
    [182] = "F13",
    [183] = "F14",
    [184] = "F15",
    [185] = "F16",
    [186] = "F17",
    [187] = "F18",
    [188] = "F19",
    [189] = "F20",
    [190] = "F21",
    [191] = "F22",
    [192] = "F23",
    [193] = "F24",
    [194] = "\226\134\145",
    [195] = "\226\134\147",
    [196] = "\226\134\144",
    [197] = "\226\134\146",
    [198] = "DEL",
    [199] = "ESC",
    [200] = "INSERT",
    [201] = "END",
    [202] = "DEL",
    [203] = "ESC",
    [204] = "END",
    [205] = "DEL",
    [206] = "INSERT",
    [207] = "END",
    [208] = "DEL",
    [209] = "END",
    [210] = "DEL",
    [211] = "INSERT",
    [212] = "END",
    [213] = "DEL",
    [214] = "INSERT",
    [215] = "END",
    [217] = "`",
    [1000] = "SHIFT",
    [1001] = "R SHIFT",
    [1002] = "TAB",
    [1004] = "BACKSPACE",
    [1005] = "PRINT SCREEN",
    [1006] = "SCROLL LOCK",
    [1007] = "PAUSE",
    [1008] = "HOME",
    [1009] = "PAGE UP",
    [1010] = "PAGE DOWN",
    [1011] = "NUM LOCK",
    [1012] = "CAPS LOCK",
    [1013] = "CTRL",
    [1014] = "R CTRL",
    [1015] = "ALT",
    [1016] = "ALT GR",
    [1017] = "MENU",
    [1018] = "WIN",
    [1019] = "R WIN",
    [1020] = "PRINT SCREEN",
    [1021] = "SCROLL LOCK",
    [1022] = "HOME",
    [1023] = "PAGE UP",
    [1024] = "PAGE DOWN",
    [1025] = "NUM LOCK",
    [1026] = "CAPS LOCK",
    [1027] = "CTRL",
    [1028] = "R CTRL",
    [1029] = "PRINT SCREEN",
    [1030] = "SCROLL LOCK",
    [1031] = "HOME",
    [1032] = "PAGE UP",
    [1033] = "PAGE DOWN",
    [1034] = "NUM LOCK",
    [1035] = "CAPS LOCK",
    [1036] = "CTRL",
    [1037] = "R CTRL",
    [1038] = "SHIFT",
    [1039] = "R SHIFT",
    [1041] = "PRINT SCREEN",
    [1042] = "SCROLL LOCK",
    [1043] = "PAUSE",
    [1044] = "HOME",
    [1045] = "PAGE UP",
    [1046] = "PAGE DOWN",
    [1047] = "NUM LOCK",
    [1048] = "CAPS LOCK",
    [1049] = "CTRL",
    [1050] = "R CTRL",
    [1051] = "ALT GR",
    [1052] = "PRINT SCREEN",
    [1053] = "SCROLL LOCK",
    [1054] = "PAUSE",
    [1055] = "HOME",
    [1056] = "PAGE UP",
    [1057] = "PAGE DOWN",
    [1058] = "NUM LOCK",
    [1059] = "CAPS LOCK",
    [1060] = "CTRL",
    [1061] = "R CTRL",
    [1062] = "MENU",
    [1063] = "PRINT SCREEN",
    [1064] = "SCROLL LOCK",
    [1065] = "PAUSE",
    [1066] = "HOME",
    [1067] = "PAGE UP",
    [1068] = "PAGE DOWN",
    [1069] = "NUM LOCK",
    [1070] = "CAPS LOCK",
    [1071] = "MENU",
    [1072] = "SHIFT",
    [1073] = "R SHIFT",
    [1074] = "ALT",
    [1075] = "ALT GR",
    [1076] = "SHIFT",
    [1077] = "R SHIFT",
    [2000] = "SPACE",
}

local HTML_ENTITIES = {
    amp = "&",
    lt = "<",
    gt = ">",
    quot = "\"",
    apos = "'",
    nbsp = " ",
}

-- The high bit of a 32-bit input hash.
local SIGNED_32BIT = 2147483648

local function DecodeEntities(text)
    return (text:gsub("&(#?[xX]?%w+);", function(entity)
        if entity:sub(1, 1) == "#" then
            local code
            if entity:sub(2, 2):lower() == "x" then
                code = tonumber(entity:sub(3), 16)
            end
            if not code then
                code = tonumber(entity:sub(2))
            end
            if code then
                return utf8.char(code)
            end
            return "&" .. entity .. ";"
        end

        local named = HTML_ENTITIES[entity:lower()]
        if not named then
            named = "&" .. entity .. ";"
        end
        return named
    end))
end

function StripMarkup(text)
    text = text:gsub("<[^>]*>", "")
    text = text:gsub("~[%w_]+~", "")
    text = DecodeEntities(text)
    text = text:gsub("^%s+", "")
    text = text:gsub("%s+$", "")
    return text
end

local function ParseButtonLabel(label)
    local prefix = label:sub(1, 2)
    local body = label:sub(3):gsub("^%s+", ""):gsub("%s+$", "")

    if body == "" then
        return nil
    end

    if prefix == "t_" or prefix == "T_" then
        return DecodeEntities(body):upper()
    end

    if prefix == "b_" then
        if body:match("^%d+$") then
            return KEY_LABELS[tonumber(body)]
        end
    end

    return nil
end

local function ResolveInputControl(input)
    local name = input:match("^~INPUT_([%w_]+)~$")
    if not name then
        return nil
    end

    if CONTROL_INDEX[name] then
        return CONTROL_INDEX[name]
    end

    if name:match("^%x%x%x%x%x%x%x%x$") then
        local hash = tonumber(name, 16) | SIGNED_32BIT
        if hash >= SIGNED_32BIT then
            hash = hash - 4294967296
        end
        return hash
    end

    return nil
end

function ResolveBoundKey(boundKey, controlName, slot)
    if not boundKey or boundKey == "|" or controlName == "" then
        return ""
    end

    if boundKey:sub(1, 2) == "t|" then
        return StripMarkup(boundKey:sub(3))
    end

    local control = nil
    if slot == 0 then
        control = ResolveInputControl(controlName)
    end

    if control then
        local button = GetControlInstructionalButton(0, control, true)
        local parsed = ParseButtonLabel(button or "")
        if parsed then
            return parsed
        end
    end

    return "?"
end

end

-- module: TOT_pauseMenu/client/gta.lua
do
GtaDriving = false

local LANDING_MENU = "FE_MENU_VERSION_LANDING_MENU"
local SETTINGS_MENU_ID = 6
local PM_READY = 15
local PM_SHUTTING_DOWN = 30
local FRONTEND_CONTROL = 2
local FRONTEND_LEFT = 189
local FRONTEND_RIGHT = 190
local FRONTEND_ACCEPT = 201
local FRONTEND_CANCEL = 202
local FRONTEND_X = 203
local FRONTEND_DELETE = 214
local TEXT_CHUNK_SIZE = 57
local AUDIO_SCENE = "MUTES_FRONTEND_SCENE"
local MAX_RETURNS = 20
local REBIND_TIMEOUT_MS = 30000

-- Settings tab menu ids used by ENTER_TAB.
GtaTabs = {
    display = 1023,
    graphics = 1137,
    advgfx = 1138,
    audio = 1022,
    voice = 1139,
    controls = 1024,
    keyboard = 1140,
    camera = 1136,
    editor = 1146,
}

-- Tabs that show the video memory row.
local VIDEO_MEMORY_TABS = {
    graphics = true,
    advgfx = true,
}

-- Maps GTA warning title hashes to the warnings used by the UI.
local WARNING_TEXT_KEYS = {
    [GetHashKey("GFX_WARNING_BODY")] = "keepSettings",
    [GetHashKey("GFX_RESTART_BODY")] = "restartRequired",
    [GetHashKey("GFX_WARNING_MP")] = "onlineWarning",
    [GetHashKey("MAPPING_CONFLICT_BODY")] = "keymapConflict",
    [GetHashKey("MAPPING_MULTI_CONFLICT_BODY")] = "keymapConflict",
    [GetHashKey("UNMAPPABLE_CONFLICT_BODY")] = "keymapUnmappable",
    [GetHashKey("MAPPING_AUTOSAVE_LOADED")] = "keymapAutosave",
    [GetHashKey("MAPPING_RESTORE_DEFAULTS")] = "keymapRestore",
    [GetHashKey("UNMAPPED_WARNING_NO_ESCAPE")] = "keymapCantLeave",
    [GetHashKey("CONFLICT_WARNING")] = "keymapLeaveConflict",
    [GetHashKey("UNMAPPED_WARNING")] = "keymapLeaveUnmapped",
}

local menuOpen = false
local keymapOpen = false
local currentTab = nil
local concealUntil = 0
local textCache = {}
local graphicsInfo = {}
local actionRowByTab = {}

local function BeginFrontendMethod(name, args)
    if not BeginScaleformMovieMethodOnFrontend(name) then
        return false
    end

    for _, value in ipairs(args or {}) do
        local valueType = type(value)
        if valueType == "boolean" then
            ScaleformMovieMethodAddParamBool(value)
        elseif valueType == "string" then
            ScaleformMovieMethodAddParamTextureNameString(value)
        elseif math.floor(value) == value then
            ScaleformMovieMethodAddParamInt(value)
        else
            ScaleformMovieMethodAddParamFloat(value)
        end
    end

    return true
end

local function CallBatch(calls, readInt)
    local results = {}

    for first = 0, #calls - 1, MAX_RETURNS do
        local returnValues = {}
        local last = math.min(first + MAX_RETURNS, #calls)

        for index = first + 1, last do
            local call = calls[index]
            local returnValue = false
            if BeginFrontendMethod(call[1], call[2]) then
                returnValue = EndScaleformMovieMethodReturnValue()
            end
            returnValues[index] = returnValue
        end

        local deadline = GetGameTimer() + 1000
        local allReady = false
        while not allReady do
            if not (deadline > GetGameTimer()) then
                break
            end

            allReady = true
            for _, returnValue in pairs(returnValues) do
                if returnValue and not IsScaleformMovieMethodReturnValueReady(returnValue) then
                    allReady = false
                end
            end

            if not allReady then
                Wait(0)
            end
        end

        for index, returnValue in pairs(returnValues) do
            if returnValue and IsScaleformMovieMethodReturnValueReady(returnValue) then
                local value
                if readInt then
                    value = GetScaleformMovieMethodReturnValueInt(returnValue)
                end
                if not value then
                    value = GetScaleformMovieMethodReturnValueString(returnValue)
                end
                results[index] = value
            end
        end
    end

    return results
end

local function CallFrontend(name, args, readInt)
    return CallBatch({ { name, args } }, readInt)[1]
end

local lastFrame = -1

local function CallFrontendOnNewFrame(name, args)
    while GetFrameCount() == lastFrame do
        Wait(0)
    end
    lastFrame = GetFrameCount()
    return CallFrontend(name, args)
end

local function IsNil(value)
    return value == nil
end

local function SplitPipe(text)
    local parts = {}
    for part in (text .. "|"):gmatch("([^|]*)|") do
        parts[#parts + 1] = part
    end
    return parts
end

-- Reads every text chunk for a list of { row, part } requests.
local function FetchSettingTexts(requests)
    local calls = {}
    for index, request in ipairs(requests) do
        calls[index] = {
            "GET_SETTINGS_TEXT",
            { request[1], request[2], 0 },
        }
    end

    local responses = CallBatch(calls)
    local texts = {}

    for index, request in ipairs(requests) do
        local text = responses[index]
        if text == nil then
            text = ""
        end

        local chunk = text
        while #chunk >= TEXT_CHUNK_SIZE do
            chunk = CallFrontend("GET_SETTINGS_TEXT", { request[1], request[2], #text })
            if chunk == nil then
                break
            end
            text = text .. chunk
        end

        texts[index] = text
    end

    return texts
end

local function WaitFor(condition, timeoutMs)
    local deadline = GetGameTimer() + timeoutMs
    while not condition() do
        if deadline < GetGameTimer() then
            return false
        end
        Wait(0)
    end
    return true
end

local function WaitFrames(count)
    local untilFrame = GetFrameCount() + count
    while untilFrame > GetFrameCount() do
        Wait(0)
    end
end

local function StartConcealThread()
    CreateThread(function()
        -- Cursor state persists, so it does not need a native call per frame
        -- during the (up to 5 s) conceal window. Only the frontend suppression
        -- has to run every frame.
        SetMouseCursorVisible(false)
        SetMouseCursorVisibleInMenus(false)

        while menuOpen do
            if GetGameTimer() < concealUntil then
                SuppressFrontendRenderingThisFrame()
                Wait(0)
            else
                SetMouseCursorVisible(false)
                SetMouseCursorVisibleInMenus(false)
                Wait(500)
            end
        end
    end)
end

local function WithFrontendControl(action)
    ReleaseControlOfFrontend()
    WaitFrames(1)
    local result = action()
    WaitFrames(3)
    if menuOpen and IsPauseMenuActive() then
        TakeControlOfFrontend()
    end
    return result
end

local function PressControl(control)
    WithFrontendControl(function()
        for _ = 1, 3 do
            EnableControlAction(FRONTEND_CONTROL, control, true)
            SetControlNormal(FRONTEND_CONTROL, control, 1.0)
            Wait(0)
        end

        -- Release the key explicitly: a control normal left at 1.0 between
        -- attempts makes the game treat it as held instead of pressed.
        EnableControlAction(FRONTEND_CONTROL, control, true)
        SetControlNormal(FRONTEND_CONTROL, control, 0.0)
        Wait(0)
    end)
end

-- Prompt buttons are handled by the game's warning screen, not by the menu
-- list, so the frontend control lock must stay untouched while answering.
local function PressPrompt(control)
    EnableControlAction(FRONTEND_CONTROL, control, true)
    for _ = 1, 3 do
        SetControlNormal(FRONTEND_CONTROL, control, 1.0)
        Wait(0)
    end

    EnableControlAction(FRONTEND_CONTROL, control, true)
    SetControlNormal(FRONTEND_CONTROL, control, 0.0)
    Wait(0)
end

local muteCount = 0

function GtaMute(hold)
    muteCount = math.max(0, muteCount + (hold and 1 or -1))
    if muteCount > 0 then
        StartAudioScene(AUDIO_SCENE)
    else
        StopAudioScene(AUDIO_SCENE)
    end
end

local OpenGtaMenu

local function EnsureGtaMenu()
    if menuOpen and IsPauseMenuActive() then
        return true
    end

    GtaMute(true)
    local opened = OpenGtaMenu()
    GtaMute(false)
    return opened
end

function OpenGtaMenu()
    GtaDriving = true

    if IsPauseMenuActive() or GetPauseMenuState() ~= 0 then
        SetFrontendActive(false)
        WaitFor(function()
            return GetPauseMenuState() == 0
        end, 3000)
    end

    ActivateFrontendMenu(GetHashKey(LANDING_MENU), false, SETTINGS_MENU_ID)
    menuOpen = true
    graphicsInfo = {}
    currentTab = nil
    concealUntil = GetGameTimer() + 5000
    StartConcealThread()
    SetMouseCursorVisibleInMenus(false)

    local stealthReady = WaitFor(function()
        return CallFrontendOnNewFrame("SET_STEALTH", { true }) == "OK"
    end, 5000)

    concealUntil = math.min(concealUntil, GetGameTimer() + 1500)

    local readyForControl = false
    if stealthReady then
        readyForControl = WaitFor(function()
            return GetPauseMenuState() == PM_READY and IsFrontendReadyForControl()
        end, 5000)
    end

    local menuReady = false
    if readyForControl then
        menuReady = WaitFor(function()
            local level = tonumber(SplitPipe(CallFrontendOnNewFrame("GET_MENU_STATE") or "")[2])
            return (level or 0) >= 1
        end, 2000)
    end

    concealUntil = 0

    if not menuReady then
        print("[TOT_pauseMenu] the hidden GTA menu did not load (reconnect after a stream/ change)")
        GtaClose()
        return false
    end

    TakeControlOfFrontend()
    return true
end

-- GTA shows the graphics prompts ("Keep these settings?" and "Restart
-- required") inside the pause menu itself. IsWarningMessageActive only covers
-- the native warning popup, so the content scaleform is read too.
local function ReadPauseWarningActive()
    local raw = CallFrontend("GET_ERROR_MESSAGE")
    return raw ~= nil and SplitPipe(raw)[1] == "1"
end

-- GET_ERROR_TEXT takes a character offset, not a byte offset.
local function Utf8Length(text)
    local _, count = text:gsub("[^\128-\191]", "")
    return count
end

local function ReadPauseWarningPart(part)
    local text = ""
    local offset = 0

    for _ = 1, 20 do
        local chunk = CallFrontend("GET_ERROR_TEXT", { part, offset })
        if chunk == nil or chunk == "" then
            break
        end

        text = text .. chunk
        offset = offset + Utf8Length(chunk)

        if #chunk < 60 then
            break
        end
    end

    return StripMarkup(text)
end

local function NormalizePromptText(text)
    if not text or text == "" then
        return ""
    end

    text = StripMarkup(text)
    text = text:gsub("%s+", " ")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    return text:lower()
end

local function MatchesLabel(label, text)
    local value = GetLabelText(label)
    if not value or value == "" or value == "NULL" then
        return false
    end

    local normalized = NormalizePromptText(value)
    return normalized ~= "" and NormalizePromptText(text) == normalized
end

local function ClassifyPauseWarning(warning)
    local texts = { warning.title, warning.body, warning.footer }

    for _, text in ipairs(texts) do
        if MatchesLabel("GFX_RESTART_BODY", text) then
            return "restartRequired"
        end
    end

    for _, text in ipairs(texts) do
        if MatchesLabel("GFX_WARNING_BODY", text) then
            return "keepSettings"
        elseif MatchesLabel("GFX_WARNING_MP", text) then
            return "onlineWarning"
        end
    end

    -- Fallback for builds that render different text for the same prompts.
    local combined = ((warning.title or "") .. " " .. (warning.body or "") .. " " .. (warning.footer or "")):lower()
    if combined:find("restart", 1, true) then
        return "restartRequired"
    end
    if combined:find("keep", 1, true) then
        return "keepSettings"
    end

    return "unknown"
end

local function ShortText(text, limit)
    text = text or ""
    limit = limit or 70
    if #text > limit then
        return text:sub(1, limit) .. "..."
    end
    return text
end

-- Answers one warning, whichever system owns it. Returns the warning kind, or
-- nil when nothing was answered.
local function AnswerActiveWarning(warnings)
    local kind

    if IsWarningMessageActive() then
        local hash = GetWarningMessageTitleHash()
        kind = WARNING_TEXT_KEYS[hash] or "unknown"
        if kind == "unknown" then
            print("[TOT_pauseMenu] GTA prompt hash " .. hash)
        end

        warnings[kind] = true
        -- Native warnings take frontend input, so release our frontend lock
        -- while answering; holding it swallows the key on some builds.
        PressControl(FRONTEND_ACCEPT)
        WaitFor(function()
            return not IsWarningMessageActive()
        end, 1000)
        WaitFrames(2)
        return kind
    end

    if not ReadPauseWarningActive() then
        return nil
    end

    local warning = {
        title = ReadPauseWarningPart(0),
        body = ReadPauseWarningPart(1),
        footer = ReadPauseWarningPart(2),
    }
    kind = ClassifyPauseWarning(warning)
    warnings[kind] = true
    print(("[TOT_pauseMenu] prompt: kind=%s title=\"%s\" body=\"%s\""):format(
        kind,
        ShortText(warning.title),
        ShortText(warning.body)
    ))

    PressPrompt(FRONTEND_ACCEPT)
    WaitFor(function()
        return not ReadPauseWarningActive()
    end, 700)
    WaitFrames(1)
    return kind
end

-- Answers warnings until none is left. waitMs is how long to wait for the
-- first one to appear.
local function DrainWarnings(warnings, waitMs)
    local answered = false
    local guard = 0
    local deadline = GetGameTimer() + (waitMs or 0)

    while guard < 12 do
        if AnswerActiveWarning(warnings) then
            answered = true
            guard = guard + 1
            deadline = GetGameTimer() + 800
        elseif answered or GetGameTimer() >= deadline then
            break
        else
            Wait(50)
        end
    end

    return answered
end

local function CollectWarnings(warnings, timeout)
    local deadline = GetGameTimer() + (timeout or 0)
    while not IsWarningMessageActive() and not ReadPauseWarningActive() and GetGameTimer() < deadline do
        Wait(50)
    end

    DrainWarnings(warnings, 0)
end

-- Applies pending graphics changes on the current tab, if GTA still reports them as dirty.
local function RefreshGraphicsContext()
    if not VIDEO_MEMORY_TABS[currentTab] then
        return
    end

    for _ = 1, 3 do
        if not PauseMenuIsContextActive(GetHashKey("GFX_Dirty")) then
            return
        end
        Wait(300)
        PressControl(FRONTEND_X)
        CollectWarnings(graphicsInfo)
    end
end

local function EnterTab(tab)
    if currentTab == tab then
        return true
    end

    if keymapOpen then
        GtaClose()
        if not EnsureGtaMenu() then
            return false
        end
    end

    RefreshGraphicsContext()

    local deadline = GetGameTimer() + 3000
    while deadline > GetGameTimer() do
        if IsWarningMessageActive() then
            CollectWarnings(graphicsInfo, 0)
        end

        local result = CallFrontendOnNewFrame("ENTER_TAB", { GtaTabs[tab] })
        if result == "ALREADY" or result == "ENTERED" then
            if result == "ENTERED" then
                CallFrontend("SET_STEALTH", { true })
            end
            currentTab = tab
            return WaitFor(function()
                return (CallFrontend("GET_SETTINGS_COUNT", nil, true) or 0) > 0
            end, 1500)
        end

        if result ~= "ERR|list_not_ready" and result == nil then
            return false
        end
    end

    return false
end

local function GetControlType(typeId)
    if typeId == 1 or (typeId >= 10 and typeId < 20) then
        return "list"
    end
    if typeId == 2 or (typeId >= 20 and typeId < 30) then
        return "slider"
    end
    return "none"
end

local function ReadSettingsRows(tab)
    local count = CallFrontend("GET_SETTINGS_COUNT", nil, true) or 0

    local rowCalls = {}
    for row = 0, count - 1 do
        rowCalls[#rowCalls + 1] = { "GET_SETTINGS_ROW", { row } }
    end
    local rowResponses = CallBatch(rowCalls)

    local rows = {}
    local textRequests = {}
    local textTargets = {}

    for row = 0, count - 1 do
        local raw = rowResponses[row + 1]
        local fields
        if raw == nil then
            fields = {}
        else
            fields = SplitPipe(raw)
        end

        local kind = fields[9]
        if kind == "action" then
            actionRowByTab[tab] = row
        end

        if kind == "pref" or kind == "action" or kind == "display" then
            local entry = {
                tab = tab,
                row = row,
                kind = kind,
                prefId = tonumber(fields[1]),
            }

            local control = "none"
            if kind == "pref" then
                control = GetControlType(tonumber(fields[2])) or "none"
            end
            entry.control = control
            entry.value = tonumber(fields[3])
            entry.max = tonumber(fields[4])
            entry.active = tonumber(fields[5])
            entry.optionCount = tonumber(fields[7])
            entry.codeBuilt = fields[8] == "1"

            local cacheKey = tab .. "|" .. row .. "|" .. entry.prefId .. "|" .. fields[2] .. "|" .. entry.optionCount
            local cache = textCache[cacheKey]

            if not cache or kind == "display" then
                cache = { label = "", options = {} }
                textCache[cacheKey] = cache

                textRequests[#textRequests + 1] = { row, -1 }
                textTargets[#textTargets + 1] = { cache, "label" }

                if entry.control == "list" and not entry.codeBuilt then
                    for option = 0, entry.optionCount - 1 do
                        textRequests[#textRequests + 1] = { row, option }
                        textTargets[#textTargets + 1] = { cache.options, option + 1 }
                    end
                end
            end

            entry.cache = cache

            if entry.codeBuilt and entry.control == "list" then
                textRequests[#textRequests + 1] = { row, 0 }
                textTargets[#textTargets + 1] = { entry, "text" }
            end

            rows[#rows + 1] = entry
        end
    end

    local texts = FetchSettingTexts(textRequests)
    for index, target in ipairs(textTargets) do
        target[1][target[2]] = texts[index]
    end

    for _, entry in ipairs(rows) do
        entry.label = entry.cache.label
        if entry.codeBuilt then
            entry.options = { entry.text }
        else
            entry.options = entry.cache.options
        end
        entry.text = nil
        entry.cache = nil
    end

    if VIDEO_MEMORY_TABS[tab] then
        local memory = SplitPipe(CallFrontend("GET_VIDEO_MEMORY") or "")
        local used = tonumber(memory[1])
        local total = tonumber(memory[2])
        if used and total and total > 0 then
            table.insert(rows, 1, {
                tab = tab,
                row = -1,
                kind = "display",
                prefId = -1,
                control = "none",
                value = used,
                max = total,
                active = 1,
                label = ("Video Memory: %d MB / %d MB"):format(used, total),
                options = {},
            })
        end
    end

    return rows
end

local function ApplySetting(change)
    local revision = CallFrontend("GET_SETTINGS_REVISION", nil, true)
    local result = change()

    -- Refusals come back as "ERR|..." (for example code-built rows); only a
    -- nil return used to be treated as a failure, which hid those.
    if result == nil or (type(result) == "string" and result:sub(1, 4) == "ERR|") then
        print("[TOT_pauseMenu] GTA refused the change: " .. tostring(result))
        return false
    end

    WaitFor(function()
        return CallFrontend("GET_SETTINGS_REVISION", nil, true) ~= revision
    end, 1000)
    WaitFrames(1)
    return true
end

function GtaReadAll()
    local all = {}

    if not EnsureGtaMenu() then
        return nil
    end

    for tab in pairs(GtaTabs) do
        if EnterTab(tab) then
            all[tab] = ReadSettingsRows(tab)
        end
    end

    return all
end

function GtaSet(tab, prefId, value)
    if not EnsureGtaMenu() or not EnterTab(tab) then
        return nil
    end

    ApplySetting(function()
        return CallFrontend("SET_PREF", { prefId, value })
    end)
    CollectWarnings(graphicsInfo, 200)
    return ReadSettingsRows(tab)
end

function GtaStep(tab, prefId, direction)
    if not EnsureGtaMenu() or not EnterTab(tab) then
        return nil
    end

    local step = direction < 0 and -1 or 1
    if IsNil(CallFrontendOnNewFrame("STEP_PREF", { prefId, step })) then
        return ReadSettingsRows(tab)
    end

    WaitFrames(2)
    PressControl(direction < 0 and FRONTEND_LEFT or FRONTEND_RIGHT)
    CollectWarnings(graphicsInfo, 200)
    return ReadSettingsRows(tab)
end

function GtaTrigger(tab, row)
    if not EnsureGtaMenu() or not EnterTab(tab) then
        return nil
    end

    ApplySetting(function()
        return CallFrontendOnNewFrame("TRIGGER_ROW", { row })
    end)
    CollectWarnings(graphicsInfo)
    return ReadSettingsRows(tab)
end

function GtaRestoreDefaults()
    local all = {}

    if not EnsureGtaMenu() then
        return all
    end

    for tab in pairs(GtaTabs) do
        if EnterTab(tab) then
            ReadSettingsRows(tab)

            if actionRowByTab[tab] then
                ApplySetting(function()
                    return CallFrontendOnNewFrame("TRIGGER_ROW", { actionRowByTab[tab] })
                end)
                CollectWarnings(graphicsInfo)
            end

            all[tab] = ReadSettingsRows(tab)
        end
    end

    return all
end

local function IsGraphicsDirty()
    -- Accept both boolean and 0/1 returns so the check is stable across
    -- game builds and native wrappers.
    return PauseMenuIsContextActive(GetHashKey("GFX_Dirty")) and true or false
end

-- GTA clears GFX_Dirty once the Apply key is accepted, but it may first show
-- a prompt that has to be confirmed. Watch both prompt systems while waiting.
local APPLY_POLL_MS = 75
local APPLY_WAIT_MS = 3000
local APPLY_RETRY_MS = 4000
local APPLY_PROMPT_WAIT_MS = 1300

local function WarningNames(warnings)
    local names = {}

    for _, key in ipairs({ "restartRequired", "keepSettings", "onlineWarning", "unknown" }) do
        if warnings[key] then
            names[#names + 1] = key
        end
    end

    return #names > 0 and table.concat(names, ",") or "-"
end

local function ReadApplyFailure()
    if IsWarningMessageActive() then
        return "native"
    end

    if ReadPauseWarningActive() then
        return "pause"
    end

    return nil
end

-- Watches the dirty context after Apply and answers any prompts it produces.
-- Returns true when the dirty context is gone, plus whether a prompt was seen.
local function WaitApply(warnings, startedAt, waitMs, promptWaitMs)
    local deadline = GetGameTimer() + waitMs
    local answered = false
    local lastDirty = nil
    local lastPrompt = nil
    local first = true

    while true do
        local dirty = IsGraphicsDirty()
        local prompt = ReadApplyFailure()

        if not dirty then
            -- The "restart required" prompt can appear just after the apply.
            DrainWarnings(warnings, promptWaitMs)
            return true, answered
        end

        if prompt then
            if AnswerActiveWarning(warnings) then
                answered = true
                deadline = GetGameTimer() + APPLY_RETRY_MS
            end
        end

        if dirty ~= lastDirty or prompt ~= lastPrompt then
            print(("[TOT_pauseMenu] apply-poll: +%dms dirty=%s prompt=%s"):format(
                GetGameTimer() - startedAt,
                tostring(dirty),
                tostring(prompt or "none")
            ))
            lastDirty = dirty
            lastPrompt = prompt
        end

        if GetGameTimer() >= deadline then
            return false, answered
        end

        Wait(first and 0 or APPLY_POLL_MS)
        first = false
    end
end

-- Some builds ignore simulated frontend input. If the page exposes its own
-- "Apply" action row, trigger that row directly instead.
local function TriggerApplyActionRow()
    if not currentTab then
        return false
    end

    local rows = ReadSettingsRows(currentTab)
    for _, row in ipairs(rows or {}) do
        if row.kind == "action" then
            local label = row.label or ""
            local lower = label:lower()

            if lower:find("apply", 1, true) or lower:find("تطبيق", 1, true) then
                local value = CallFrontendOnNewFrame("TRIGGER_ROW", { row.row })
                if value and not tostring(value):find("ERR", 1, true) then
                    return true
                end
            else
                print("[TOT_pauseMenu] apply: action row ignored: " .. label)
            end
        end
    end

    return false
end

-- Applies the pending graphics changes on GTA's graphics page. The caller
-- must release NUI focus first, otherwise the simulated Apply key is swallowed.
function GtaApplyGraphics()
    local applyStartedAt = GetGameTimer()
    local result = {
        ok = false,
        dirty = false,
        wasDirty = false,
        noChanges = false,
        restartRequired = false,
        keepSettings = false,
        onlineWarning = false,
        attempts = 0,
    }

    if not EnsureGtaMenu() then
        result.error = "menu"
        return result
    end

    if not EnterTab("graphics") then
        result.error = "tab"
        return result
    end

    -- A prompt that is already open would swallow the simulated Apply key.
    DrainWarnings(graphicsInfo, 0)

    -- Simulated frontend input is ignored while the game is still loading the
    -- menu, so wait until the frontend reports that it takes input.
    WaitFor(function()
        return IsFrontendReadyForControl()
    end, 1500)

    print(("[TOT_pauseMenu] apply: start tab=%s dirty=%s ready=%s state=%s"):format(
        tostring(currentTab),
        tostring(IsGraphicsDirty()),
        tostring(IsFrontendReadyForControl()),
        tostring(GetPauseMenuState())
    ))

    WaitFrames(2)
    result.wasDirty = IsGraphicsDirty()

    if not result.wasDirty then
        WaitFrames(2)
        result.wasDirty = IsGraphicsDirty()
    end

    -- Even when GTA does not report a dirty context, press Apply once: some
    -- settings are stored without raising the context, and an idle press is
    -- harmless on the graphics page.
    local maxAttempts = result.wasDirty and 2 or 1
    local waitMs = result.wasDirty and APPLY_WAIT_MS or 2500
    local cleared = false
    local answered = false

    for attempt = 1, maxAttempts do
        result.attempts = attempt

        PressControl(FRONTEND_X)
        WaitFrames(2)

        local attemptCleared, attemptAnswered = WaitApply(
            graphicsInfo,
            applyStartedAt,
            waitMs,
            result.wasDirty and APPLY_PROMPT_WAIT_MS or 400
        )
        answered = answered or attemptAnswered

        if attemptCleared then
            cleared = true
            break
        end

        -- Fallback for clients where the simulated key never reaches the menu:
        -- press the page's own Apply row when it has one.
        if not answered and TriggerApplyActionRow() then
            print("[TOT_pauseMenu] apply: triggered the Apply row")
            local rowCleared, rowAnswered = WaitApply(graphicsInfo, applyStartedAt, 1500, APPLY_PROMPT_WAIT_MS)
            answered = answered or rowAnswered

            if rowCleared then
                cleared = true
                break
            end
        end

        -- Some builds keep the "keep these settings?" prompt invisible to both
        -- prompt APIs. Accepting once commits the pending values; if the prompt
        -- is not there, the settings list ignores the key.
        if not answered then
            print("[TOT_pauseMenu] apply: prompt not detected, sending ACCEPT")
            PressPrompt(FRONTEND_ACCEPT)
            Wait(700)

            local acceptCleared, acceptAnswered = WaitApply(graphicsInfo, applyStartedAt, 1500, 600)
            answered = answered or acceptAnswered

            if acceptCleared then
                cleared = true
                break
            end

            -- Nothing was prompted at all: the game is keeping the change
            -- pending for a restart, so a second Apply cannot clear it.
            if not acceptAnswered then
                break
            end
        end
    end

    result.dirty = IsGraphicsDirty()
    result.noChanges = not result.wasDirty and not answered

    result.restartRequired = graphicsInfo.restartRequired == true

    -- A change that the game accepts but keeps flagged as dirty needs a game
    -- restart (GTA raises no prompt for those settings). Report that instead of
    -- a generic "did not apply" failure.
    if result.dirty and not result.noChanges then
        result.restartRequired = true
    end

    result.ok = (not result.dirty) or result.restartRequired

    if not result.ok then
        result.error = "dirty"
    end

    result.keepSettings = graphicsInfo.keepSettings == true
    result.onlineWarning = graphicsInfo.onlineWarning == true
    result.unknownWarning = graphicsInfo.unknown == true
    graphicsInfo.restartRequired = nil
    graphicsInfo.keepSettings = nil
    graphicsInfo.onlineWarning = nil
    graphicsInfo.unknown = nil

    print(("[TOT_pauseMenu] apply: wasDirty=%s ok=%s dirty=%s attempts=%d prompts=%s took=%dms%s"):format(
        tostring(result.wasDirty),
        tostring(result.ok),
        tostring(result.dirty),
        result.attempts,
        WarningNames({
            restartRequired = result.restartRequired,
            keepSettings = result.keepSettings,
            onlineWarning = result.onlineWarning,
            unknown = result.unknownWarning,
        }),
        GetGameTimer() - applyStartedAt,
        result.error and (" error=" .. result.error) or ""
    ))

    return result
end

function GtaClose()
    if not menuOpen then
        GtaDriving = false
        return
    end

    ReleaseControlOfFrontend()

    if GetPauseMenuState() ~= PM_SHUTTING_DOWN then
        SetFrontendActive(false)
    end

    WaitFor(function()
        return not IsPauseMenuActive()
    end, 2000)

    menuOpen = false
    keymapOpen = false
    currentTab = nil
    SetMouseCursorVisibleInMenus(true)
    GtaDriving = false
end

function GtaMenuOpen()
    return menuOpen
end

local pauseHolds = {}

function PauseHold(key, value)
    pauseHolds[key] = value or nil
    CreateThread(function()
        if next(pauseHolds) then
            EnsureGtaMenu()
        elseif menuOpen then
            GtaClose()
        end
    end)
end

function PauseHeld()
    return next(pauseHolds) ~= nil
end

-- Reads all text chunks for a list of argument arrays.
local function FetchTexts(name, argumentLists)
    local results = {}

    for index, args in ipairs(argumentLists) do
        local text = ""

        for _ = 1, 20 do
            local request = { table.unpack(args) }
            request[#request + 1] = #text

            local chunk = CallFrontend(name, request)
            if chunk == nil then
                break
            end

            text = text .. chunk
            if #chunk < TEXT_CHUNK_SIZE then
                break
            end
        end

        results[index] = text
    end

    return results
end

local function GetKeymapState()
    local fields = SplitPipe(CallFrontend("GET_KEYMAP_STATE") or "")
    return {
        inKeymap = fields[1] == "1",
        menuLevel = tonumber(fields[2]) or 0,
        categoryRow = tonumber(fields[3]) or 0,
        capturing = fields[6] == "1",
    }
end

local function WaitForCommandResult(command, args, accepted)
    local deadline = GetGameTimer() + 3000
    while deadline > GetGameTimer() do
        local result = CallFrontendOnNewFrame(command, args)
        if accepted[result] then
            return result
        end
        if result ~= "ERR|list_not_ready" and result == nil then
            return nil
        end
    end
    return nil
end

local function EnsureKeymapPage()
    if keymapOpen and menuOpen and IsPauseMenuActive() and GetKeymapState().inKeymap then
        return true
    end

    if not EnsureGtaMenu() then
        return false
    end

    RefreshGraphicsContext()

    if not WaitForCommandResult("ENTER_KEYMAP", {}, { ENTERED = true, ALREADY = true }) then
        return false
    end

    if not WaitFor(function()
        return GetKeymapState().inKeymap
    end, 3000) then
        return false
    end

    keymapOpen = true
    currentTab = "keymap"
    CallFrontend("SET_STEALTH", { true })
    return true
end

local function EnterKeymapCategory(category)
    local state = GetKeymapState()
    if state.menuLevel == 2 and state.categoryRow == category then
        return
    end

    WaitForCommandResult("ENTER_KEYMAP_CATEGORY", { category }, { ENTERED = true, ALREADY = true })
end

local function ReadKeymapPage()
    local state = GetKeymapState()
    local categories = {}

    local categoryCount = CallFrontend("GET_KEYMAP_CATEGORY_COUNT", nil, true) or 0
    local categoryCalls = {}
    local categoryTextArgs = {}

    for index = 0, categoryCount - 1 do
        categoryCalls[#categoryCalls + 1] = { "GET_KEYMAP_CATEGORY", { index } }
        categoryTextArgs[#categoryTextArgs + 1] = { index }
    end

    local categoryResponses = CallBatch(categoryCalls)
    local categoryTexts = FetchTexts("GET_KEYMAP_CATEGORY_TEXT", categoryTextArgs)

    for index = 0, categoryCount - 1 do
        local fields = SplitPipe(categoryResponses[index + 1] or "")
        categories[#categories + 1] = {
            index = index,
            label = StripMarkup(categoryTexts[index + 1] or ""),
            alert = fields[2] == "1",
            restore = fields[4] == "restore",
        }
    end

    local rows = {}

    if state.menuLevel == 2 then
        local rowDefinitions = {}
        local offset = 0

        for _ = 1, 50 do
            local response = CallFrontend("GET_KEYMAP_ROWS", { offset })
            if response == nil then
                break
            end

            local fields = SplitPipe(response)
            local rowCount = tonumber(fields[2]) or 0
            if rowCount == 0 then
                break
            end

            local body = fields[3] or ""
            for part in (body .. ";"):gmatch("([^;]*);") do
                if part ~= "" then
                    rowDefinitions[#rowDefinitions + 1] = part
                end
            end

            offset = offset + rowCount
        end

        local labelRequests = {}
        local keyNameRequests = {}
        local keyCalls = {}

        for index = 0, #rowDefinitions - 1 do
            labelRequests[#labelRequests + 1] = { index, -1 }
            keyNameRequests[#keyNameRequests + 1] = { index, 0 }
            keyNameRequests[#keyNameRequests + 1] = { index, 1 }
            keyCalls[#keyCalls + 1] = { "GET_KEYMAP_KEY", { index, 0 } }
            keyCalls[#keyCalls + 1] = { "GET_KEYMAP_KEY", { index, 1 } }
        end

        local labels = FetchTexts("GET_KEYMAP_TEXT", labelRequests)
        local keyNames = FetchTexts("GET_KEYMAP_TEXT", keyNameRequests)
        local boundKeys = CallBatch(keyCalls)

        for index = 0, #rowDefinitions - 1 do
            local rowFields = {}
            for part in (rowDefinitions[index + 1] .. ","):gmatch("([^,]*),") do
                rowFields[#rowFields + 1] = tonumber(part)
            end

            rows[#rows + 1] = {
                row = index,
                label = StripMarkup(labels[index + 1] or ""),
                alert = rowFields[2] == 1,
                mappable = rowFields[3] == 1,
                keys = {
                    ResolveBoundKey(boundKeys[index * 2 + 1], keyNames[index * 2 + 1], 0),
                    ResolveBoundKey(boundKeys[index * 2 + 2], keyNames[index * 2 + 2], 1),
                },
            }
        end
    end

    return {
        categories = categories,
        category = state.menuLevel == 2 and state.categoryRow or nil,
        rows = rows,
    }
end

function GtaWarning()
    if not IsWarningMessageActive() then
        return nil
    end

    return WARNING_TEXT_KEYS[GetWarningMessageTitleHash()] or "unknown"
end

function GtaAnswer(choice)
    if IsWarningMessageActive() then
        local control = FRONTEND_ACCEPT
        if choice == "no" then
            control = FRONTEND_CANCEL
        elseif choice == "alt" then
            control = FRONTEND_X
        end

        PressControl(control)
        WaitFor(function()
            return not IsWarningMessageActive()
        end, 500)
        WaitFrames(2)
    end

    if keymapOpen then
        return ReadKeymapPage()
    end
end

function GtaKeymap(category)
    if not EnsureKeymapPage() then
        return nil
    end

    if category then
        EnterKeymapCategory(category)
    end

    return ReadKeymapPage()
end

function GtaRebind(row, slot)
    if not EnsureKeymapPage() then
        return nil
    end

    if CallFrontendOnNewFrame("BEGIN_REBIND", { row, slot }) ~= "OK" then
        return ReadKeymapPage()
    end

    WaitFor(function()
        return GetKeymapState().capturing
    end, 1000)

    local finished = WaitFor(function()
        return IsWarningMessageActive() or not GetKeymapState().capturing
    end, REBIND_TIMEOUT_MS)

    if not finished then
        PressControl(FRONTEND_CANCEL)
    end

    WaitFrames(2)
    return ReadKeymapPage()
end

function GtaClearKey(row, slot)
    if not EnsureKeymapPage() then
        return nil
    end

    if CallFrontendOnNewFrame("SELECT_KEYMAP_SLOT", { row, slot }) ~= "OK" then
        return ReadKeymapPage()
    end

    WaitFrames(1)
    PressControl(FRONTEND_DELETE)
    WaitFor(function()
        return CallFrontend("GET_KEYMAP_TEXT", { row, slot, 0 }) == ""
    end, 400)
    WaitFrames(1)
    return ReadKeymapPage()
end

function GtaRestoreKeys()
    if not EnsureKeymapPage() then
        return nil
    end

    WaitForCommandResult("RESTORE_KEYMAP_DEFAULTS", {}, { TRIGGERED = true })
    WaitFrames(2)
    return ReadKeymapPage()
end

function IsGtaSettingsTab()
    if not GtaDriving and not IsPauseMenuActive() then
        return false
    end
    return GetPauseMenuSelectionData() == SETTINGS_MENU_ID
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        StopAudioScene(AUDIO_SCENE)
    end

    if resource == GetCurrentResourceName() then
        if menuOpen then
            ReleaseControlOfFrontend()
            SetFrontendActive(false)
            SetMouseCursorVisibleInMenus(true)
        end
    end
end)

exports("PauseHold", PauseHold)

end

-- module: TOT_pauseMenu/client/settings.lua
do
local settingsOpen = false
local settingsClosing = false
local reopenPauseOnClose = false

local actionQueue = {}
local queueRunning = false
local capturing = false
local applyBusy = false
local lastDirtySent = nil

local originalPrefs = {}
local pendingSteps = {}
local dirtyPrefs = {}
local graphicsTouched = false
local loadedTabs = nil
local settingsLoadedAt = 0

-- Re-reading every GTA settings tab is a heavy burst. Cache the result for a
-- short while; cached rows are kept up to date by SendRows after each change.
local SETTINGS_CACHE_MS = 30000

local WARNING_KEYS = {
    keepSettings = "warnKeepSettings",
    restartRequired = "warnRestartRequired",
    onlineWarning = "warnOnlineWarning",
    keymapConflict = "warnKeymapConflict",
    keymapUnmappable = "warnKeymapUnmappable",
    keymapAutosave = "warnKeymapAutosave",
    keymapRestore = "warnKeymapRestore",
    keymapCantLeave = "warnKeymapCantLeave",
    keymapLeaveConflict = "warnKeymapLeaveConflict",
    keymapLeaveUnmapped = "warnKeymapLeaveUnmapped",
    unknown = "warnUnknown",
}

local function WarningText(warning)
    return TOTText(WARNING_KEYS[warning] or "warnUnknown")
end

local function CloseSettings()
    settingsOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "settings:close" })

    if reopenPauseOnClose then
        OpenPause()
    else
        TriggerScreenblurFadeOut(250)
        ClearExtraTimecycleModifier()
        SetPauseState(false)
    end
end

local function Notify(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, true)
end

local function HasDirty()
    return next(dirtyPrefs) ~= nil or graphicsTouched
end

-- After a successful apply GTA owns the values, so the next settings session
-- starts with a fresh diff baseline. Keep the row cache: each change already
-- refreshed it through SendRows, so reopening settings stays instant. A revert
-- still invalidates the cache because it changes rows without resending them.
local function ClearDirty(invalidateRows)
    dirtyPrefs = {}
    pendingSteps = {}
    graphicsTouched = false

    if invalidateRows then
        loadedTabs = nil
        settingsLoadedAt = 0
    elseif loadedTabs then
        -- The cached rows already match the applied values, so restart the
        -- cache window instead of forcing a full re-read the next time.
        settingsLoadedAt = GetGameTimer()
    end
end

local function SendDirty()
    local dirty = HasDirty()

    if dirty == lastDirtySent then
        return
    end

    lastDirtySent = dirty
    SendNUIMessage({
        action = "settings:dirty",
        dirty = dirty,
    })
end

local function ToUiRows(rows)
    local result = {}

    for _, row in ipairs(rows) do
        local entry = {
            key = "gta:" .. row.tab .. ":" .. row.row,
            label = row.label,
            desc = "",
            gta = {
                tab = row.tab,
                prefId = row.prefId,
                row = row.row,
                codeBuilt = row.codeBuilt,
            },
            disabled = row.active == 0,
        }

        if row.kind == "action" then
            entry.type = "action"
        elseif row.kind == "display" then
            entry.type = "display"
            entry.value = row.value
            entry.max = row.max
        elseif row.control == "slider" then
            entry.type = "slider"
            entry.value = row.value
            entry.step = 1
            entry.min = 0
            entry.max = row.max
        else
            entry.type = "select"
            entry.options = row.options

            if row.codeBuilt and row.options[1] then
                entry.value = row.options[1]
            else
                entry.value = row.options[row.value + 1]
            end
            entry.index = row.value
        end

        result[#result + 1] = entry
    end

    return result
end

local function SendRows(tab, rows)
    if loadedTabs then
        loadedTabs[tab] = rows
    end

    SendNUIMessage({
        action = "settings:gtaRows",
        tab = tab,
        rows = ToUiRows(rows),
    })
end

local function SendKeymapPage(page)
    local warning = GtaWarning()

    if warning then
        SendNUIMessage({
            action = "settings:gtaWarning",
            kind = warning,
            text = WarningText(warning),
            alt = warning == "keymapAutosave" or warning == "unknown",
        })
    elseif page then
        SendNUIMessage({
            action = "settings:keymap",
            page = page,
        })
    end
end

local function SetCapturing(value)
    capturing = value
    SetNuiFocus(true, not value)
    SetNuiFocusKeepInput(value)
    SendNUIMessage({
        action = "settings:capturing",
        on = value,
    })
end

local APPLY_BLOCKED_FRONTEND = { 199, 200, 202 }

-- Runs only while an apply is in flight, so no idle polling thread is kept
-- alive for the whole session.
local function StartApplyControlBlock()
    CreateThread(function()
        while applyBusy do
            -- Only the pause/back keys are blocked. DisableAllControlActions
            -- here also swallowed the simulated Apply key on some builds.
            for _, control in ipairs(APPLY_BLOCKED_FRONTEND) do
                DisableControlAction(FRONTEND_CONTROL, control, true)
            end

            Wait(0)
        end
    end)
end

local function ApplyGraphicsNow()
    if applyBusy then
        return { ok = false, error = "busy" }
    end

    applyBusy = true
    StartApplyControlBlock()
    GtaMute(true)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "settings:applying", on = true })

    local called, result = pcall(GtaApplyGraphics)
    if not called then
        print("[TOT_pauseMenu] apply failed: " .. tostring(result))
        result = { ok = false, error = "script" }
    end
    result = result or { ok = false, error = "script" }

    GtaMute(false)
    applyBusy = false

    if not result.ok then
        settingsClosing = false
    end

    if result.ok then
        ClearDirty()
    end

    local dirty = HasDirty()
    lastDirtySent = dirty

    -- Update the UI before handing input back, so a click on Apply cannot
    -- arrive while the previous result is still being displayed.
    SendNUIMessage({ action = "settings:applying", on = false })
    SendNUIMessage({
        action = "settings:applyResult",
        ok = result.ok == true,
        dirty = dirty,
        noChanges = result.noChanges == true,
        restartRequired = result.restartRequired == true,
        keepSettings = result.keepSettings == true,
        error = result.error,
    })

    if settingsOpen then
        SetNuiFocus(true, true)
    end

    return result
end

-- These actions drive GTA's own UI without the frontend mute scene.
local MUTE_EXEMPT = {
    set = true,
    step = true,
    answer = true,
    apply = true,
}

local processAction

local function RunAction(action)
    if not MUTE_EXEMPT[action.type] then
        GtaMute(true)
    end

    processAction(action)

    if not MUTE_EXEMPT[action.type] then
        GtaMute(false)
    end
end

local function ProcessAction(action)
    local actionType = action.type

    if actionType == "load" then
        -- Start every session with a fresh diff baseline, even on a cache hit.
        originalPrefs = {}
        pendingSteps = {}
        dirtyPrefs = {}
        graphicsTouched = false

        if loadedTabs and GetGameTimer() - settingsLoadedAt < SETTINGS_CACHE_MS then
            for tab, rows in pairs(loadedTabs) do
                for _, row in ipairs(rows) do
                    if row.kind == "pref" then
                        originalPrefs[tab .. row.prefId] = {
                            tab = tab,
                            prefId = row.prefId,
                            value = row.value,
                            codeBuilt = row.codeBuilt,
                        }
                    end
                end
            end

            SendDirty()
            return
        end

        local all = GtaReadAll()
        if not all then
            return
        end

        settingsLoadedAt = GetGameTimer()
        loadedTabs = all

        for tab, rows in pairs(all) do
            for _, row in ipairs(rows) do
                if row.kind == "pref" then
                    originalPrefs[tab .. row.prefId] = {
                        tab = tab,
                        prefId = row.prefId,
                        value = row.value,
                        codeBuilt = row.codeBuilt,
                    }
                end
            end
        end

        for tab, rows in pairs(all) do
            SendRows(tab, rows)
        end

        SendDirty()
    elseif actionType == "set" then
        local key = action.tab .. action.prefId
        dirtyPrefs[key] = true

        local rows = GtaSet(action.tab, action.prefId, action.value)
        if rows then
            SendRows(action.tab, rows)
        end

        SendDirty()
    elseif actionType == "step" then
        local key = action.tab .. action.prefId
        pendingSteps[key] = (pendingSteps[key] or 0) + action.direction
        dirtyPrefs[key] = true

        local rows = GtaStep(action.tab, action.prefId, action.direction)
        if rows then
            SendRows(action.tab, rows)
        end

        SendDirty()
    elseif actionType == "trigger" then
        graphicsTouched = true

        local rows = GtaTrigger(action.tab, action.row)
        if rows then
            SendRows(action.tab, rows)
        end

        SendDirty()
    elseif actionType == "keymap" then
        SendKeymapPage(GtaKeymap(action.category))
    elseif actionType == "rebind" then
        SetCapturing(true)
        local page = GtaRebind(action.row, action.slot)
        SetCapturing(false)
        SendKeymapPage(page)
    elseif actionType == "clearKey" then
        SendKeymapPage(GtaClearKey(action.row, action.slot))
    elseif actionType == "restoreKeys" then
        SendKeymapPage(GtaRestoreKeys())
    elseif actionType == "answer" then
        SendKeymapPage(GtaAnswer(action.choice))
    elseif actionType == "defaults" then
        graphicsTouched = true

        for tab, rows in pairs(GtaRestoreDefaults()) do
            SendRows(tab, rows)
        end

        SendDirty()
    elseif actionType == "apply" then
        local result = ApplyGraphicsNow()

        if not result.ok then
            Notify(TOTText("notifyApplyFailed"))
        end
    elseif actionType == "confirm" then
        if HasDirty() then
            local result = ApplyGraphicsNow()

            -- Keep the settings screen open when the game did not commit the
            -- changes. Closing here would hide the failure and could leave an
            -- unanswered GTA prompt behind the game view.
            if not result.ok then
                Notify(TOTText("notifyApplyFailed"))
                return
            end

            Wait(900)
        end

        CloseSettings()
        PauseHold("settings", false)
    elseif actionType == "restart" then
        -- The player confirmed the restart prompt. Closing the menu first keeps
        -- the frontend clean, then the game is closed so the next launch picks
        -- up the pending graphics settings.
        reopenPauseOnClose = false
        CloseSettings()
        PauseHold("settings", false)

        SetTimeout(1200, function()
            -- Quit cleanly first: the game flushes its settings file on a
            -- normal shutdown. The forced update native is only a fallback for
            -- clients where the command is blocked.
            ExecuteCommand("quit")

            SetTimeout(4000, function()
                pcall(function()
                    ForceSocialClubUpdate()
                end)
            end)
        end)
    elseif actionType == "back" then
        -- Discard: put every changed row back to the value it had when the
        -- settings screen opened. Nothing is applied unless GtaApplyGraphics is
        -- needed to commit the restored values.
        local hadChanges = next(pendingSteps) ~= nil or next(dirtyPrefs) ~= nil or graphicsTouched

        if hadChanges then
            for key, steps in pairs(pendingSteps) do
                local original = originalPrefs[key]
                if original then
                    for _ = 1, math.abs(steps) do
                        GtaStep(original.tab, original.prefId, steps > 0 and -1 or 1)
                    end
                end
            end

            if graphicsTouched then
                for tab, rows in pairs(GtaReadAll() or {}) do
                    for _, row in ipairs(rows) do
                        local original = originalPrefs[tab .. row.prefId]
                        if original
                            and not original.codeBuilt
                            and row.kind == "pref"
                            and original.value ~= row.value
                        then
                            GtaSet(tab, row.prefId, original.value)
                        end
                    end
                end
            else
                for key in pairs(dirtyPrefs) do
                    local original = originalPrefs[key]
                    if original then
                        GtaSet(original.tab, original.prefId, original.value)
                    end
                end
            end

            GtaApplyGraphics()
        end

        ClearDirty(true)
        PauseHold("settings", false)
    end
end

processAction = ProcessAction

local function EnqueueAction(action)
    actionQueue[#actionQueue + 1] = action

    if queueRunning then
        return
    end

    queueRunning = true
    CreateThread(function()
        while #actionQueue > 0 do
            RunAction(table.remove(actionQueue, 1))
        end
        queueRunning = false
    end)
end

function OpenSettings(fromPause)
    if settingsOpen then
        return
    end

    settingsOpen = true
    settingsClosing = false
    lastDirtySent = nil
    reopenPauseOnClose = fromPause == true

    if not reopenPauseOnClose then
        TriggerScreenblurFadeIn(250)
    end

    SetPauseState(true)
    PauseHold("settings", true)

    local locale = TOTLocale()

    SendNUIMessage({
        action = "settings:open",
        tabs = Config.Tabs,
        locale = locale,
        rtl = TOTRTL(),
        strings = Config.Locales[locale] or Config.Locales.en,
        theme = Config.Theme,
    })
    SetNuiFocus(true, true)

    if loadedTabs then
        for tab, rows in pairs(loadedTabs) do
            SendRows(tab, rows)
        end
    end

    EnqueueAction({ type = "load" })
end

RegisterNUICallback("settings:gtaSet", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "set",
        tab = data.tab,
        prefId = data.prefId,
        value = data.value,
    })
end)

RegisterNUICallback("settings:gtaStep", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "step",
        tab = data.tab,
        prefId = data.prefId,
        direction = data.direction,
    })
end)

RegisterNUICallback("settings:gtaTrigger", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "trigger",
        tab = data.tab,
        row = data.row,
    })
end)

RegisterNUICallback("settings:keymap", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "keymap",
        category = data.category,
    })
end)

RegisterNUICallback("settings:rebind", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "rebind",
        row = data.row,
        slot = data.slot,
    })
end)

RegisterNUICallback("settings:clearKey", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "clearKey",
        row = data.row,
        slot = data.slot,
    })
end)

RegisterNUICallback("settings:restoreKeys", function(_, cb)
    cb(1)
    EnqueueAction({ type = "restoreKeys" })
end)

RegisterNUICallback("settings:answer", function(data, cb)
    cb(1)
    EnqueueAction({
        type = "answer",
        choice = data.choice,
    })
end)

RegisterNUICallback("settings:default", function(_, cb)
    cb(1)
    EnqueueAction({ type = "defaults" })
end)

RegisterNUICallback("settings:apply", function(_, cb)
    cb(1)

    if not settingsOpen or settingsClosing or capturing then
        return
    end

    EnqueueAction({ type = "apply" })
end)

RegisterNUICallback("settings:confirm", function(_, cb)
    cb(1)

    if not settingsOpen or settingsClosing then
        return
    end

    settingsClosing = true
    EnqueueAction({ type = "confirm" })
end)

RegisterNUICallback("settings:restart", function(_, cb)
    cb(1)

    if not settingsOpen or settingsClosing then
        return
    end

    settingsClosing = true
    EnqueueAction({ type = "restart" })
end)

RegisterNUICallback("settings:back", function(_, cb)
    cb(1)

    if not settingsOpen or settingsClosing then
        return
    end

    settingsClosing = true
    CloseSettings()
    EnqueueAction({ type = "back" })
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and settingsOpen then
        CloseSettings()
    end
end)

exports("OpenSettings", OpenSettings)

exports("ShowSettingsTab", function(tab, scroll)
    SendNUIMessage({
        action = "settings:tab",
        tab = tab,
        scroll = scroll,
    })
end)

end

-- module: TOT_pauseMenu/client/freecam.lua
do
local camera = nil
local active = false
local anchor = nil

local angles = {
    pitch = 0.0,
    heading = 0.0,
}

local options = {
    speed = 100,
    fov = Config.FreeCam.fov,
    roll = 0,
    grid = false,
}

function FreeCamActive()
    return active
end

local function StopFreeCam()
    if not active then
        return
    end

    active = false
    SetPauseState(false)
    PauseHold("camera", false)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "cam:close" })

    RenderScriptCams(false, true, Config.FreeCam.back, true, true)

    local destroyedCam = camera
    camera = nil
    SetTimeout(Config.FreeCam.back + 100, function()
        DestroyCam(destroyedCam, false)
        ClearFocus()
    end)
end

function StartFreeCam()
    if active then
        return
    end

    local coords = GetGameplayCamCoord()
    local rotation = GetGameplayCamRot(2)

    anchor = GetEntityCoords(PlayerPedId())
    angles.pitch = rotation.x
    angles.heading = rotation.z
    options.fov = Config.FreeCam.fov

    camera = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        coords.x,
        coords.y,
        coords.z,
        rotation.x,
        0.0,
        rotation.z,
        options.fov,
        false,
        2
    )

    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)

    active = true
    SetPauseState(true)
    PauseHold("camera", true)

    local locale = TOTLocale()

    SendNUIMessage({
        action = "cam:open",
        opts = options,
        minFov = Config.FreeCam.minFov,
        maxFov = Config.FreeCam.maxFov,
        locale = locale,
        rtl = TOTRTL(),
        strings = Config.Locales[locale] or Config.Locales.en,
        theme = Config.Theme,
    })

    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    CreateThread(function()
        local FC = Config.FreeCam

        while active do
            local frameTime = GetFrameTime()

            DisableAllControlActions(0)
            HideHudAndRadarThisFrame()

            local heading = angles.heading
            local pitch = angles.pitch

            if IsDisabledControlPressed(0, 25) then
                local lookSpeed = FC.look * 10.0

                heading = heading - GetDisabledControlNormal(0, 1) * lookSpeed
                pitch = math.max(
                    -89.0,
                    math.min(89.0, pitch - GetDisabledControlNormal(0, 2) * lookSpeed)
                )

                angles.heading = heading
                angles.pitch = pitch
            end

            if IsDisabledControlJustPressed(0, 241) then
                options.fov = math.max(FC.minFov, options.fov - 3.0)
                SendNUIMessage({ action = "cam:opts", opts = options })
            end

            if IsDisabledControlJustPressed(0, 242) then
                options.fov = math.min(FC.maxFov, options.fov + 3.0)
                SendNUIMessage({ action = "cam:opts", opts = options })
            end

            local headingRad = math.rad(heading)
            local pitchRad = math.rad(pitch)
            local cosPitch = math.cos(pitchRad)
            local forwardX = -math.sin(headingRad) * cosPitch
            local forwardY = math.cos(headingRad) * cosPitch
            local forwardZ = math.sin(pitchRad)
            local rightX = math.cos(headingRad)
            local rightY = math.sin(headingRad)
            local moveX, moveY, moveZ = 0.0, 0.0, 0.0

            if IsDisabledControlPressed(0, 32) or IsDisabledControlPressed(0, 172) then
                moveX, moveY, moveZ = moveX + forwardX, moveY + forwardY, moveZ + forwardZ
            end
            if IsDisabledControlPressed(0, 33) or IsDisabledControlPressed(0, 173) then
                moveX, moveY, moveZ = moveX - forwardX, moveY - forwardY, moveZ - forwardZ
            end
            if IsDisabledControlPressed(0, 35) or IsDisabledControlPressed(0, 175) then
                moveX, moveY = moveX + rightX, moveY + rightY
            end
            if IsDisabledControlPressed(0, 34) or IsDisabledControlPressed(0, 174) then
                moveX, moveY = moveX - rightX, moveY - rightY
            end
            if IsDisabledControlPressed(0, 21) then
                moveZ = moveZ + 1.0
            end
            if IsDisabledControlPressed(0, 36) then
                moveZ = moveZ - 1.0
            end

            local camCoords = GetCamCoord(camera)
            local speed = FC.speed * options.speed / 100.0 * frameTime
            local newX = camCoords.x + moveX * speed
            local newY = camCoords.y + moveY * speed
            local newZ = camCoords.z + moveZ * speed

            local offsetX = newX - anchor.x
            local offsetY = newY - anchor.y
            local offsetZ = newZ - anchor.z
            local distance = math.sqrt(offsetX * offsetX + offsetY * offsetY + offsetZ * offsetZ)

            if distance > FC.radius then
                local scale = FC.radius / distance
                newX = anchor.x + offsetX * scale
                newY = anchor.y + offsetY * scale
                newZ = anchor.z + offsetZ * scale
            end

            SetCamCoord(camera, newX, newY, newZ)
            SetCamRot(camera, pitch, options.roll + 0.0, heading, 2)
            SetCamFov(camera, options.fov + 0.0)
            SetFocusPosAndVel(newX, newY, newZ, 0.0, 0.0, 0.0)

            Wait(0)
        end
    end)
end

RegisterNUICallback("cam:set", function(data, cb)
    cb(1)

    if options[data.key] ~= nil then
        options[data.key] = data.value
    end
end)

RegisterNUICallback("cam:back", function(_, cb)
    cb(1)
    PauseSound("back")
    StopFreeCam()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() or not camera then
        return
    end

    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(camera, false)
    ClearFocus()
    SetNuiFocusKeepInput(false)
end)

exports("StartFreeCam", StartFreeCam)

end

-- module: TOT_pauseMenu/client/pause.lua
do
local pauseOpen = false

function SetPauseState(state)
    LocalPlayer.state:set("pauseMenu", state, false)
end

local SOUNDSET = "HUD_FRONTEND_DEFAULT_SOUNDSET"

local sounds = {
    nav = "NAV_UP_DOWN",
    side = "NAV_LEFT_RIGHT",
    select = "SELECT",
    back = "BACK",
}

function PauseSound(name)
    if sounds[name] then
        PlaySoundFrontend(-1, sounds[name], SOUNDSET, true)
    end
end

local function CanOpenPause()
    return not IsNuiFocused()
        and not IsPauseMenuActive()
        and not IsPlayerSwitchInProgress()
        and not FreeCamActive()
end

function OpenPause()
    if pauseOpen then
        return
    end

    pauseOpen = true
    SetPauseState(true)
    TriggerScreenblurFadeIn(250)
    SetExtraTimecycleModifier("hud_def_blur")
    SetExtraTimecycleModifierStrength(1.0)
    PauseSound("select")

    local locale = TOTLocale()

    SendNUIMessage({
        action = "pause:open",
        store = Config.StoreUrl,
        help = Config.HelpUrl,
        locale = locale,
        rtl = TOTRTL(),
        strings = Config.Locales[locale] or Config.Locales.en,
        theme = Config.Theme,
    })
    SetNuiFocus(true, true)

    if GtaMenuOpen() then
        PauseHold("pause", true)
    else
        SetTimeout(350, function()
            if pauseOpen then
                PauseHold("pause", true)
            end
        end)
    end
end

local function ClosePause(keepState)
    pauseOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "pause:close" })
    PauseHold("pause", false)

    if not keepState then
        TriggerScreenblurFadeOut(250)
        ClearExtraTimecycleModifier()
        SetPauseState(false)
    end
end

RegisterNUICallback("sound", function(data, cb)
    cb(1)
    PauseSound(data.name)
end)

RegisterNUICallback("pause:close", function(_, cb)
    cb(1)
    ClosePause()
end)

RegisterNUICallback("pause:map", function(_, cb)
    cb(1)
    ClosePause()

    if GetResourceState("TOT_pauseMap") == "started" then
        exports.TOT_pauseMap:OpenBig()
    else
        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, -1)
    end
end)

RegisterNUICallback("pause:settings", function(_, cb)
    cb(1)
    ClosePause(true)
    OpenSettings(true)
end)

RegisterNUICallback("pause:camera", function(_, cb)
    cb(1)
    ClosePause()
    StartFreeCam()
end)

RegisterNUICallback("pause:disconnect", function(_, cb)
    cb(1)
    ClosePause()

    -- The server drop is the clean path; the client command is the first
    -- fallback, and the native is the last resort if commands are blocked.
    TriggerServerEvent("TOT_pauseMenu:requestDrop", "disconnect")

    SetTimeout(1500, function()
        ExecuteCommand("disconnect")

        SetTimeout(1000, function()
            NetworkSessionEnd(false, true)
        end)
    end)
end)

RegisterNUICallback("pause:quit", function(_, cb)
    cb(1)
    ClosePause()

    -- ForceSocialClubUpdate exits the game without needing console ACLs.
    SetTimeout(200, function()
        pcall(function()
            ForceSocialClubUpdate()
        end)

        -- Last-resort fallback if the native is unavailable.
        SetTimeout(2000, function()
            ExecuteCommand("quit")
        end)
    end)
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(500)
    end

    local lastFocus = 0
    local focusTick = 0
    local settingsTick = 0

    while true do
        DisableControlAction(0, 200, true)

        if not pauseOpen then
            -- Poll NUI focus four times a second instead of every frame. The
            -- press path checks it again, so the 500 ms guard stays exact.
            if focusTick <= 0 then
                focusTick = 15

                if IsNuiFocused() then
                    lastFocus = GetGameTimer()
                end
            end
            focusTick = focusTick - 1

            if IsDisabledControlJustPressed(0, 200) then
                if IsNuiFocused() then
                    lastFocus = GetGameTimer()
                elseif CanOpenPause() and GetGameTimer() - lastFocus > 500 then
                    OpenPause()
                end
            end
        end

        -- Only intercept the native pause menu when the player opened it.
        -- Our own pause/settings UI, and the hidden GTA menu used to read
        -- settings, always open the frontend on its Settings page, so checking
        -- during those states would instantly pop our settings UI open.
        if not GtaDriving and not PauseHeld() then
            settingsTick = settingsTick - 1

            if settingsTick <= 0 then
                settingsTick = 15

                if IsGtaSettingsTab() then
                    SetPauseMenuActive(false)
                    OpenSettings(false)
                end
            end
        end

        Wait(0)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and pauseOpen then
        ClosePause()
    end
end)

exports("OpenPause", OpenPause)

-- Shared with TOT_pauseMap so the map follows the pause-menu language/theme.
exports("GetLocale", TOTLocale)
exports("GetTheme", function()
    return Config.Theme
end)

end
