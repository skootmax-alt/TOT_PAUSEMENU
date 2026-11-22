# THIS SCRIPT IS MADE BY TOT

**https://discord.gg/VnpMqz96YH**

---

## TOT_pauseMenu و TOT_pauseMap — التركيب والإعداد

موردان لـ FiveM: قائمة إيقاف مع الإعدادات والكاميرا الحرة، وخريطة إيقاف. لا يحتاجان SQL ولا موارد إضافية.

## التركيب

1. ضع المجلدين داخل مجلد الموارد:

   ```text
   resources/[qbx]/[TOT-pausemenu]/TOT_pauseMenu
   resources/[qbx]/[TOT-pausemenu]/TOT_pauseMap
   ```

2. أضف السكربتين إلى `server.cfg`:

   ```cfg
   ensure TOT_pauseMenu
   ensure TOT_pauseMap
   ```

3. شغّل السيرفر، أو استخدم في الكونسول:

   ```text
   refresh
   ensure TOT_pauseMenu
   ensure TOT_pauseMap
   ```

## الإعداد

كل التعديلات تُجرى في ملفات `config.lua`، ثم أعد تشغيل المورد:

```text
restart TOT_pauseMenu
restart TOT_pauseMap
```

### اللغة

في `TOT_pauseMenu/config.lua`:

```lua
Config.Locale = 'ar' -- 'en' للإنجليزية، و'ar' أو 'arabic' للعربية
```

- تتحول كل النصوص إلى العربية ويتحول الاتجاه إلى RTL تلقائيًا.
- نصوص الواجهة كلها في `Config.Locales` أسفل الملف.
- تبويبات الإعدادات في `Config.Tabs`: استخدم `labelAr` و`titleAr` للعربية.
- صفوف إعدادات GTA نفسها تأتي من اللعبة، لذلك تتبع لغة اللعبة.

في `TOT_pauseMap/config.lua`:

```lua
Config.FollowPauseMenu = true -- الخريطة تتبع لغة وألوان قائمة الإيقاف
```

لغة الخريطة وحدها: اجعل `Config.FollowPauseMenu = false` واضبط `Config.Locale` في نفس الملف. أسماء الفئات في `TOT_pauseMap/categories.lua`، وأسماء العلامات والمناطق في `TOT_pauseMap/blips_config.lua`.

### الألوان

في `TOT_pauseMenu/config.lua`:

```lua
Config.Theme = {
    accent = '#22c55e',
    accent2 = '#22c55e',
    panel = '#21202b',
    panel2 = '#242235',
    background = '#22202b',
    cam = 'rgba(27, 28, 48, 0.9)',
    text = '#e6e6ea',
    title = '#f2ecf3',
    active = '#222222',
    tint = 'rgba(8, 7, 16, 0.72)',
    button = '#f8f8f8',
}
```

- أي لون CSS مقبول (`#rrggbb` أو `rgba(...)`).
- اجعل القيمة `nil` للإبقاء على المظهر الأصلي لذلك الجزء.
- صورة صفحة الإعدادات: `settingsImage`، ولونها `settingsImageColor` (أو `false` لإبقاء الوردي الأصلي)، مع `settingsHue` و`settingsSaturation` و`settingsBrightness`.

### تبويبات الإعدادات

```lua
Config.Tabs = {
    { id = 'display', label = 'DISPLAY', labelAr = 'العرض',
      sections = { { page = 'display', title = 'DISPLAY', titleAr = 'العرض' } } },
    -- ...
}
```

- `page` هو اسم صفحة GTA من `GtaTabs` داخل `client/main.lua`.
- `keys = true` لتبويب اختصارات المفاتيح.

### الكاميرا الحرة

```lua
Config.FreeCam = {
    speed = 6.0,
    radius = 40.0,
    fov = 50.0,
    minFov = 15.0,
    maxFov = 90.0,
    look = 6.0,
    back = 700,
}
```

### الخريطة

في `TOT_pauseMap/config.lua`:

- `Config.Theme` ألوان الخريطة (يُستخدم منها `hint` و`map` دائمًا).
- `Config.Route` و`Config.Waypoint` لخط الطريق ودبوس الوجهة.
- `Config.Blips` لشكل العلامات وحجمها وألوانها.
- `Config.Player` و`Config.Zoom` و`Config.Buildings` و`Config.Zones`.
- `Config.AlwaysShow` لعلامات تبقى ظاهرة دائمًا (معرّفات GTA).

عند `Config.FollowPauseMenu = true` تُؤخذ ألوان `accent` و`panel` و`panel2` و`text` و`title` من قائمة الإيقاف.

### الروابط

في `TOT_pauseMenu/config.lua`:

```lua
Config.StoreUrl = 'https://example.tebex.io'
Config.HelpUrl = 'https://discord.gg/VnpMqz96YH'
```
