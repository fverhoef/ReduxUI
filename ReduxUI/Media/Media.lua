local addonName, ns = ...
local R = _G.ReduxUI

R.media = {
    fonts = {
        adventure = "Interface\\AddOns\\" .. addonName .. "\\Media\\Fonts\\Adventure.ttf",
        expresswayFree = "Interface\\AddOns\\" .. addonName .. "\\Media\\Fonts\\ExpresswayFree.ttf"
    },
    textures = {
        blank = [[Interface\Buttons\WHITE8X8]],

        arrow = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Arrow",
        logo = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Logo",

        -- Blizzard Arrows
        arrowDown_Down = "Interface\\BUTTONS\\Arrow-Down-Down",
        arrowDown_Up = "Interface\\BUTTONS\\Arrow-Down-Up",
        arrowUp_Down = "Interface\\BUTTONS\\Arrow-Up-Down",
        arrowUp_Up = "Interface\\BUTTONS\\Arrow-Up-Up",

        backdrops = {
            beautycase = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Backdrops\\Beautycase",
            glow = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Backdrops\\Glow"
        },

        borders = {
            beautycase = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Borders\\Beautycase",
            beautycaseGloss = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Borders\\BeautycaseGloss",
            beautycaseWhite = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Borders\\BeautycaseWhite",
            beautycaseShadow = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Borders\\BeautycaseShadow"
        },

        statusBars = {
            redux = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Redux",
            onePixel = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\OnePixel",
            empty = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Empty",
            flat = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Flat",
            kait1 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Kait1",
            kait2 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Kait2",
            melli = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\Melli",
            melliDark = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\StatusBars\\MelliDark"
        }
    }
}

-- register shared media
R.Libs.SharedMedia:Register("font", "Adventure", R.media.fonts.adventure)
R.Libs.SharedMedia:Register("font", "Expressway Free", R.media.fonts.expresswayFree)
R.Libs.SharedMedia:Register("statusbar", "Redux", R.media.textures.statusBars.redux)
R.Libs.SharedMedia:Register("statusbar", "Redux (One Pixel)", R.media.textures.statusBars.onePixel)
R.Libs.SharedMedia:Register("statusbar", "Empty", R.media.textures.statusBars.empty)
R.Libs.SharedMedia:Register("statusbar", "Flat", R.media.textures.statusBars.flat)
R.Libs.SharedMedia:Register("statusbar", "Kait1", R.media.textures.statusBars.kait1)
R.Libs.SharedMedia:Register("statusbar", "Kait2", R.media.textures.statusBars.kait2)
R.Libs.SharedMedia:Register("statusbar", "Melli", R.media.textures.statusBars.melli)
R.Libs.SharedMedia:Register("statusbar", "MelliDark", R.media.textures.statusBars.melliDark)
