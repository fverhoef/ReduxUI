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
            equippedOverlay = MEDIA_PREFIX .. "\\Textures\\Buttons\\EquippedOverlay",
            round = MEDIA_PREFIX .. "\\Textures\\Buttons\\Round",
            roundGoldInlay = MEDIA_PREFIX .. "\\Textures\\Buttons\\RoundGoldInlay"
        },
        edgeFiles = {
            border = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\Border",
            glow = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\Glow",
            inlay = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\Inlay",
            separatorHorizontal = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorHorizontal",
            separatorVertical = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorVertical"
        },
        frames = {
            dualPaneFrame_Left = MEDIA_PREFIX .. "\\Textures\\Frames\\DualPaneFrame-Left",
            dualPaneFrame_Right = MEDIA_PREFIX .. "\\Textures\\Frames\\DualPaneFrame-Right",
            paperDollInfoFrame = MEDIA_PREFIX .. "\\Textures\\Frames\\PaperDollInfoFrame"
        },
        icons = { backpack = MEDIA_PREFIX .. "\\Textures\\Icons\\Backpack", bank = MEDIA_PREFIX .. "\\Textures\\Icons\\Bank" },
        minimap = {
            dragonflight = {
                atlas = MEDIA_PREFIX .. "\\Textures\\Minimap\\Dragonflight\\Atlas",
                buttonFrameToggle = MEDIA_PREFIX .. "\\Textures\\Minimap\\Dragonflight\\ButtonFrameToggle",
                buttonFrameToggle_Highlight = MEDIA_PREFIX .. "\\Textures\\Minimap\\Dragonflight\\ButtonFrameToggle-Highlight",
                calendarBlank = MEDIA_PREFIX .. "\\Textures\\Minimap\\Dragonflight\\CalendarBlank",
                mask = MEDIA_PREFIX .. "\\Textures\\Minimap\\Dragonflight\\Mask"
            },
            vanilla = {
                border = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\Border",
                minimapButtonHighlight = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\MinimapButton-Highlight",
                starButton_Down = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\StarButton-Up",
                starButton_Up = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\StarButton-Down",
                zoneBorder = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\ZoneBorder",
            }
        },
        statusBars = {
            castbar = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Castbar",
            castbarMana = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarMana",
            castbarSteel = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarSteel",
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
            shield = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Shield",
            dragonflight = {
                castingBar = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Dragonflight\\CastingBar",
                castingBarFullMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Dragonflight\\CastingBarFullMask",
                castingBarFx = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Dragonflight\\CastingBarFx",
                playerPortraitMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Dragonflight\\PlayerPortraitMask",
                unitFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Dragonflight\\UnitFrame"
            },
            vanilla = {
                additionalPowerBorder = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\AdditionalPowerBorder",
                focusFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\FocusFrame",
                focusFrame_Flash = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\FocusFrame-Flash",
                focusFrame_LargeHealth = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\FocusFrame-LargeHealth",
                partyFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\PartyFrame",
                partyFrame_Flash = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\PartyFrame-Flash",
                partyFrame_LargeHealth = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\PartyFrame-LargeHealth",
                partyFrame_LargeHealth_Flash = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\PartyFrame-LargeHealth-Flash",
                targetingFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame",
                targetingFrame_Flash = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-Flash",
                targetingFrame_Elite = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-Elite",
                targetingFrame_Elite_Flash = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-Elite-Flash",
                targetingFrame_Rare = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-Rare",
                targetingFrame_RareElite = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-Rare-Elite",
                targetingFrame_LargeHealth = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-LargeHealth",
                targetingFrame_LargeHealth_Elite = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-LargeHealth-Elite",
                targetingFrame_LargeHealth_Rare = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-LargeHealth-Rare",
                targetingFrame_LargeHealth_RareElite = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetingFrame-LargeHealth-Rare-Elite",
                targetOfTargetFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Vanilla\\TargetOfTargetFrame"
            }
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
