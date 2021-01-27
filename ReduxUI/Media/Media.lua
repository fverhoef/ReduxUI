local AddonName, AddonTable = ...
local R = _G.ReduxUI

R.media = {
    fonts = {
        Adventure = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Fonts\\Adventure.ttf",
        ExpresswayFree = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Fonts\\ExpresswayFree.ttf"
    },
    textures = {
        Blank = [[Interface\Buttons\WHITE8X8]],

        Arrow = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\Arrow",
        BorderNormal = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\BorderNormal",
        BorderNormalGloss = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\BorderNormalGloss",
        BorderNormalWhite = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\BorderNormalWhite",
        BorderShadow = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\BorderShadow",
        Glow = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\Glow",
        Logo = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\Logo",
        StatusBar_Redux = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Redux",
        StatusBar_OnePixel = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\OnePixel",
        StatusBar_Empty = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Empty",
        StatusBar_Flat = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Flat",
        StatusBar_Kait1 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Kait1",
        StatusBar_Kait2 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Kait2",
        StatusBar_Melli = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\Melli",
        StatusBar_MelliDark = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\StatusBars\\MelliDark",

        -- Blizzard Arrows
        arrowDown_Down = "Interface\\BUTTONS\\Arrow-Down-Down",
        arrowDown_Up = "Interface\\BUTTONS\\Arrow-Down-Up",
        arrowUp_Down = "Interface\\BUTTONS\\Arrow-Up-Down",
        arrowUp_Up = "Interface\\BUTTONS\\Arrow-Up-Up"
    }
}

-- register shared media
R.Libs.SharedMedia:Register("font", "Adventure", R.media.fonts.Adventure)
R.Libs.SharedMedia:Register("font", "Expressway Free", R.media.fonts.ExpresswayFree)
R.Libs.SharedMedia:Register("statusbar", "Redux", R.media.textures.StatusBar_Redux)
R.Libs.SharedMedia:Register("statusbar", "Redux (One Pixel)", R.media.textures.StatusBar_OnePixel)
R.Libs.SharedMedia:Register("statusbar", "Empty", R.media.textures.StatusBar_Empty)
R.Libs.SharedMedia:Register("statusbar", "Flat", R.media.textures.StatusBar_Flat)
R.Libs.SharedMedia:Register("statusbar", "Kait1", R.media.textures.StatusBar_Kait1)
R.Libs.SharedMedia:Register("statusbar", "Kait2", R.media.textures.StatusBar_Kait2)
R.Libs.SharedMedia:Register("statusbar", "Melli", R.media.textures.StatusBar_Melli)
R.Libs.SharedMedia:Register("statusbar", "MelliDark", R.media.textures.StatusBar_MelliDark)
