-- #####################################################################
-- #                                                                   #
-- #                 THIS SCRIPT IS MADE BY TOT                        #
-- #                 https://discord.gg/VnpMqz96YH                     #
-- #                                                                   #
-- #####################################################################
-- pause map blip menu (the left icons): each blip goes to the first category that lists its sprite id
-- (sprite ids: https://docs.fivem.net/docs/game-references/blips/), blips no category lists go to Personal
-- order here = order of the icons; icon = html/icons/<icon>.svg; labelAr shows when Config.Locale = 'ar'
Config.Categories = {
    { id = 'personal', label = 'PERSONAL', labelAr = 'شخصي', icon = 'navigation' },
    { id = 'bank', label = 'BANK & ATM', labelAr = 'البنك والصراف', icon = 'sack-dollar', sprites = { 108, 207, 500 } },
    { id = 'markets', label = 'MARKETS', labelAr = 'المتاجر', icon = 'cart-shopping', sprites = { 52, 361 } },
    { id = 'garages', label = 'GARAGES', labelAr = 'الكراجات', icon = 'car', sprites = { 50, 72, 225, 357, 369, 524, 856, 872 } },
    { id = 'weapons', label = 'WEAPON SHOPS', labelAr = 'متاجر الأسلحة', icon = 'gun', sprites = { 110, 313, 844 } },
    { id = 'clothes', label = 'CLOTHES SHOPS', labelAr = 'متاجر الملابس', icon = 'shirt', sprites = { 71, 73, 75, 366 } },
    { id = 'food', label = 'RESTAURANTS', labelAr = 'المطاعم', icon = 'utensils', sprites = { 93, 121, 827, 889 } },
}

-- blip names by sprite id are in blips_config.lua (Config.BlipNames / Config.BlipNamesAr)
