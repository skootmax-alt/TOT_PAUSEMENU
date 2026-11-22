-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
Config = {}

-- links opened in the player's browser
Config.StoreUrl = 'https://example.tebex.io'
Config.HelpUrl = 'https://discord.gg/VnpMqz96YH'

-- UI language: 'en' = English, 'ar' = Arabic ('english' / 'arabic' also work).
-- Every visible string is in Config.Locales at the bottom of this file, so you can
-- edit the translations or copy a block to add another language.
Config.Locale = 'ar'

-- UI colours: any CSS colour works ('#rrggbb', 'rgba(r, g, b, a)', ...).
-- Set a value to nil to keep the original look for that part.
Config.Theme = {
    accent = '#ff8bbb',       -- sliders, toggles, highlights
    accent2 = '#fc87b3',      -- memory bar, key capture
    panel = '#21202b',        -- pause menu panel
    panel2 = '#242235',       -- pause menu panel, far side
    background = '#22202b',   -- settings page background
    cam = 'rgba(27, 28, 48, 0.9)', -- free camera panel
    text = '#e6e6ea',         -- normal text
    title = '#f2ecf3',        -- headings
    active = '#222222',       -- text on a highlighted row
    tint = 'rgba(8, 7, 16, 0.72)', -- full-screen dim behind the pause menu
    button = '#f8f8f8',       -- selected settings tab

    -- settings page background (html/img/settings-bg.jpg)
    -- settingsImageColor changes the pink of the photo itself; the gradient and
    -- palm trees stay. Use any CSS colour. false keeps the original pink.
    settingsImage = 'img/settings-bg.jpg', -- image path or URL
    settingsImageColor = '#5e003a',            -- false keeps the original pink; e.g. '#3b82f6' (blue) or '#22c55e' (green)

    -- optional fine-tuning
    settingsHue = 0,                       -- degrees: rotates the image colours (0 = original)
    settingsSaturation = 100,              -- %: 0 = greyscale, 100 = original
    settingsBrightness = 100,              -- %: 0 = black, 100 = original

    -- advanced: a custom overlay instead of settingsImageColor (used only when it is false)
    settingsTint = 'rgba(0, 0, 0, 0)',     -- colour laid over the image; keep alpha 0 for no overlay
    settingsBlend = 'normal',              -- normal, multiply, overlay, color, soft-light, ...

    -- Examples:
    --   blue photo:     settingsImageColor = '#3b82f6'
    --   green photo:    settingsImageColor = '#22c55e'
    --   purple photo:   settingsImageColor = '#a855f7'
    --   soft blue:      settingsImageColor = 'rgba(59, 130, 246, 0.6)'
    --   original pink:  settingsImageColor = false
    --   purple shift:   settingsImageColor = false, settingsHue = -40
    --   greyscale:      settingsImageColor = false, settingsSaturation = 0
}

-- settings tabs: each one shows GTA's own settings pages as sections (rows, names and options come from GTA)
-- page = client/gta.lua GtaTabs key; keys = the key bindings page
-- labelAr / titleAr are used when Config.Locale = 'ar'
Config.Tabs = {
    { id = 'display', label = 'DISPLAY', labelAr = 'العرض', sections = { { page = 'display', title = 'DISPLAY', titleAr = 'العرض' } } },
    { id = 'graphics', label = 'GRAPHICS', labelAr = 'الرسومات', sections = { { page = 'graphics', title = 'GRAPHICS', titleAr = 'الرسومات' }, { page = 'advgfx', title = 'ADVANCED', titleAr = 'متقدّم' } } },
    { id = 'audio', label = 'AUDIO', labelAr = 'الصوت', sections = { { page = 'audio', title = 'AUDIO', titleAr = 'الصوت' } } },
    { id = 'voice', label = 'VOICE CHAT', labelAr = 'الدردشة الصوتية', sections = { { page = 'voice', title = 'VOICE CHAT', titleAr = 'الدردشة الصوتية' } } },
    { id = 'controller', label = 'CONTROLLER', labelAr = 'ذراع التحكم', sections = { { page = 'controls', title = 'CONTROLLER', titleAr = 'ذراع التحكم' } } },
    { id = 'keyboard', label = 'KEYBOARD', labelAr = 'لوحة المفاتيح', sections = { { page = 'keyboard', title = 'MOUSE & KEYBOARD', titleAr = 'الفأرة ولوحة المفاتيح' } } },
    { id = 'camera', label = 'CAMERA', labelAr = 'الكاميرا', sections = { { page = 'camera', title = 'CAMERA', titleAr = 'الكاميرا' } } },
    { id = 'replay', label = 'REPLAY', labelAr = 'الإعادة', sections = { { page = 'editor', title = 'ROCKSTAR EDITOR', titleAr = 'محرر روكستار' } } },
    { id = 'keys', label = 'KEY BINDINGS', labelAr = 'اختصارات المفاتيح', keys = true },
}

-- Free Camera: moves with WASD / arrows, Shift up, Ctrl down, right mouse looks around, wheel zooms
Config.FreeCam = {
    speed = 6.0,        -- m/s at 100%
    radius = 40.0,      -- m: how far from the player it can go
    fov = 50.0,         -- start field of view
    minFov = 15.0,
    maxFov = 90.0,
    look = 6.0,         -- mouse look speed
    back = 700,         -- ms: the camera eases back to the player
}

-- translations used by the pause menu, settings page, free camera and warning dialogs
Config.Locales = {
    en = {
        -- pause menu
        map = 'Map',
        game = 'Game',
        store = 'Store',
        help = 'Help',
        camera = 'Free Camera',
        settings = 'Settings',
        gameTitle = 'GAME',
        disconnect = 'Disconnect',
        exit = 'Exit',
        exitTitle = 'EXIT GAME',
        disconnectAsk = 'Are you sure you want to leave this server?',
        exitAsk = 'Are you sure you want to quit the game?',
        select = 'SELECT',
        back = 'BACK',

        -- settings
        settingsTitle = 'SETTINGS',
        restoreAll = 'RESTORE ALL',
        keyBindings = 'KEY BINDINGS',
        category = 'Category',
        on = 'On',
        off = 'Off',
        pressKey = 'Press a key',
        empty = 'Empty',
        no = 'NO',
        yes = 'YES',
        other = 'OTHER',
        confirmation = 'CONFIRMATION',
        settingsLeaveAsk = 'You have unapplied changes. Apply them before closing?',
        apply = 'APPLY',
        applying = 'APPLYING',
        applySuccess = 'Settings applied.',
        restartTitle = 'RESTART REQUIRED',
        restartAsk = 'The new settings only take effect after a restart. Restart the game now?',
        restartLater = 'Settings saved. Restart the game later to apply them.',
        applyNoChanges = 'No pending changes.',
        applyFailed = 'The game did not apply the changes. Press Apply to try again.',

        -- free camera
        cameraTitle = 'CAMERA',
        hideUi = 'HIDE UI',
        speed = 'Speed',
        speedDesc = 'The movement speed of the camera.',
        fov = 'Field of View',
        fovDesc = 'How wide the camera sees. The mouse wheel zooms too.',
        roll = 'Roll',
        rollDesc = 'Tilts the camera to the side.',
        grid = 'Grid',
        gridDesc = 'Shows a grid to help line up the shot.',

        -- GTA warnings and notifications
        warnKeepSettings = 'Keep these graphics settings?',
        warnRestartRequired = 'The game must be restarted to apply these settings.',
        warnOnlineWarning = 'This change may affect the online session. Continue?',
        warnKeymapConflict = 'This key is already in use. Replace it?',
        warnKeymapUnmappable = 'This key cannot be replaced.',
        warnKeymapAutosave = 'An autosave of the key bindings exists. Load it?',
        warnKeymapRestore = 'Reset all key bindings to their defaults?',
        warnKeymapCantLeave = 'A key conflict prevents leaving this page.',
        warnKeymapLeaveConflict = 'Some keys are in conflict. Leave anyway?',
        warnKeymapLeaveUnmapped = 'Some controls have no key. Leave anyway?',
        warnUnknown = 'The game is asking for a confirmation.',
        notifyApplyFailed = 'Could not apply the graphics settings',
    },
    ar = {
        -- pause menu
        map = 'الخريطة',
        game = 'اللعبة',
        store = 'المتجر',
        help = 'المساعدة',
        camera = 'الكاميرا الحرة',
        settings = 'الإعدادات',
        gameTitle = 'اللعبة',
        disconnect = 'قطع الاتصال',
        exit = 'الخروج',
        exitTitle = 'الخروج من اللعبة',
        disconnectAsk = 'هل أنت متأكد من مغادرة هذا السيرفر؟',
        exitAsk = 'هل أنت متأكد من الخروج من اللعبة؟',
        select = 'اختيار',
        back = 'رجوع',

        -- settings
        settingsTitle = 'الإعدادات',
        restoreAll = 'استعادة الكل',
        keyBindings = 'اختصارات المفاتيح',
        category = 'الفئة',
        on = 'مفعّل',
        off = 'معطّل',
        pressKey = 'اضغط مفتاحاً',
        empty = 'فارغ',
        no = 'لا',
        yes = 'نعم',
        other = 'خيار آخر',
        confirmation = 'تأكيد',
        settingsLeaveAsk = 'لديك تغييرات لم تُطبَّق. هل تريد تطبيقها قبل الإغلاق؟',
        apply = 'تطبيق',
        applying = 'جارٍ التطبيق',
        applySuccess = 'تم تطبيق الإعدادات.',
        restartTitle = 'إعادة التشغيل مطلوبة',
        restartAsk = 'الإعدادات الجديدة تعمل بعد إعادة التشغيل فقط. هل تريد إعادة تشغيل اللعبة الآن؟',
        restartLater = 'تم حفظ الإعدادات. أعد تشغيل اللعبة لاحقاً لتطبيقها.',
        applyNoChanges = 'لا توجد تغييرات معلّقة.',
        applyFailed = 'لم تطبّق اللعبة التغييرات. اضغط تطبيق للمحاولة مرة أخرى.',

        -- free camera
        cameraTitle = 'الكاميرا',
        hideUi = 'إخفاء الواجهة',
        speed = 'السرعة',
        speedDesc = 'سرعة حركة الكاميرا.',
        fov = 'مجال الرؤية',
        fovDesc = 'مدى اتساع رؤية الكاميرا. عجلة الفأرة تقرّب أيضاً.',
        roll = 'الميلان',
        rollDesc = 'إمالة الكاميرا إلى الجانب.',
        grid = 'الشبكة',
        gridDesc = 'يعرض شبكة تساعدك على ضبط زاوية التصوير.',

        -- GTA warnings and notifications
        warnKeepSettings = 'هل تريد الاحتفاظ بإعدادات الرسومات هذه؟',
        warnRestartRequired = 'يجب إعادة تشغيل اللعبة لتطبيق هذه الإعدادات.',
        warnOnlineWarning = 'قد يؤثر هذا التغيير على جلسة اللعب عبر الإنترنت. هل تريد المتابعة؟',
        warnKeymapConflict = 'هذا المفتاح مستخدم بالفعل. هل تريد استبداله؟',
        warnKeymapUnmappable = 'لا يمكن استبدال هذا المفتاح.',
        warnKeymapAutosave = 'يوجد حفظ تلقائي لاختصارات المفاتيح. هل تريد تحميله؟',
        warnKeymapRestore = 'إعادة تعيين جميع اختصارات المفاتيح إلى الافتراضي؟',
        warnKeymapCantLeave = 'يوجد تعارض في المفاتيح يمنع مغادرة هذه الصفحة.',
        warnKeymapLeaveConflict = 'هناك تعارض في بعض المفاتيح. هل تريد المغادرة على أي حال؟',
        warnKeymapLeaveUnmapped = 'بعض الإجراءات بدون مفتاح. هل تريد المغادرة على أي حال؟',
        warnUnknown = 'اللعبة تطلب تأكيداً.',
        notifyApplyFailed = 'تعذّر تطبيق إعدادات الرسومات',
    },
}

-- active language key ('en' or 'ar'); falls back to English for anything missing
function TOTLocale()
    local locale = tostring(Config.Locale or 'en'):lower()

    if locale == 'arabic' then
        locale = 'ar'
    elseif locale == 'english' then
        locale = 'en'
    end

    if Config.Locales[locale] then
        return locale
    end

    return 'en'
end

function TOTText(key)
    local locale = TOTLocale()
    local strings = Config.Locales[locale] or Config.Locales.en
    local text = strings[key]

    if text == nil then
        text = Config.Locales.en[key]
    end

    return text or key
end

function TOTRTL()
    return TOTLocale() == 'ar'
end
