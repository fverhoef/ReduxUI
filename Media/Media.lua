local addonName, ns = ...
local R = _G.ReduxUI

local MEDIA_PREFIX = "Interface\\AddOns\\" .. addonName .. "\\Media"

R.media = {
    fonts = { adventure = MEDIA_PREFIX .. "\\Fonts\\Adventure.ttf", expresswayFree = MEDIA_PREFIX .. "\\Fonts\\ExpresswayFree.ttf" },
    textures = {
        blank = [[Interface\Buttons\WHITE8X8]],
        arrow1 = MEDIA_PREFIX .. "\\Textures\\Arrow1",
        logo = MEDIA_PREFIX .. "\\Textures\\Logo",
        actionBars = {
            mainMenuBarBackground = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MainMenuBar-Background",
            mainMenuBarEndCap = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MainMenuBar-EndCap",
            mainMenuBarTrackingBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MainMenuBar-TrackingBar",
            microButtonAndBagsBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MicroButtonAndBagsBar",
            microButtonSettings_Up = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MicroButtonSettings-Up",
            microButtonSettings_Down = MEDIA_PREFIX .. "\\Textures\\ActionBars\\MicroButtonSettings-Down",
            performanceBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\PerformanceBar"
        },
        buttons = {
            backdrop = MEDIA_PREFIX .. "\\Textures\\Buttons\\Backdrop",
            border = MEDIA_PREFIX .. "\\Textures\\Buttons\\Border",
            round = MEDIA_PREFIX .. "\\Textures\\Buttons\\Round",
            roundGoldInlay = MEDIA_PREFIX .. "\\Textures\\Buttons\\RoundGoldInlay"
        },
        edgeFiles = {
            borderMetal = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\BorderMetal",
            borderThick = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\BorderThick",
            borderThin = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\BorderThin",
            glow = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\Glow",
            inlay = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\Inlay",
            separatorHorizontal = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorHorizontal",
            separatorVertical = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorVertical"
        },
        frames = { paperDollInfoFrame = MEDIA_PREFIX .. "\\Textures\\Frames\\PaperDollInfoFrame" },
        icons = { backpack = MEDIA_PREFIX .. "\\Textures\\Icons\\Backpack", bank = MEDIA_PREFIX .. "\\Textures\\Icons\\Bank" },
        minimap = {
            border = MEDIA_PREFIX .. "\\Textures\\Minimap\\Border",
            zoneBorder = MEDIA_PREFIX .. "\\Textures\\Minimap\\ZoneBorder",
            round = {
                buttonFrameToggle = MEDIA_PREFIX .. "\\Textures\\Minimap\\Round\\ButtonFrameToggle",
                buttonFrameToggle_Highlight = MEDIA_PREFIX .. "\\Textures\\Minimap\\Round\\ButtonFrameToggle-Highlight"
            }
        },
        statusBars = {
            redux = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Redux",
            onePixel = MEDIA_PREFIX .. "\\Textures\\StatusBars\\OnePixel",
            empty = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Empty",
            flat = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Flat",
            kait1 = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Kait1",
            kait2 = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Kait2",
            melli = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Melli",
            melliDark = MEDIA_PREFIX .. "\\Textures\\StatusBars\\MelliDark"
        },
        unitFrames = {
            restingFlipbook = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\RestingFlipbook",
            targetingFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\TargetingFrame",
            targetingFrame_LargeHealth = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\TargetingFrame-LargeHealth"
        }
    }
}

-- register shared media
R.Libs.SharedMedia:Register("font", "Adventure", R.media.fonts.adventure)
R.Libs.SharedMedia:Register("font", "Expressway Free", R.media.fonts.expresswayFree)
R.Libs.SharedMedia:Register("statusbar", "Redux", R.media.textures.statusBars.redux)
R.Libs.SharedMedia:Register("statusbar", "One Pixel", R.media.textures.statusBars.onePixel)
R.Libs.SharedMedia:Register("statusbar", "Empty", R.media.textures.statusBars.empty)
R.Libs.SharedMedia:Register("statusbar", "Flat", R.media.textures.statusBars.flat)
R.Libs.SharedMedia:Register("statusbar", "Kait1", R.media.textures.statusBars.kait1)
R.Libs.SharedMedia:Register("statusbar", "Kait2", R.media.textures.statusBars.kait2)
R.Libs.SharedMedia:Register("statusbar", "Melli", R.media.textures.statusBars.melli)
R.Libs.SharedMedia:Register("statusbar", "MelliDark", R.media.textures.statusBars.melliDark)
