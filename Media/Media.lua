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
            modern = {
                actionBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Modern\\ActionBar",
                actionBarBackground = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Modern\\ActionBarBackground",
                bagSlots = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Modern\\BagSlots",
                microMenu = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Modern\\MicroMenu"
            },
            vanilla = {
                mainMenuBarBackground = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MainMenuBar-Background",
                mainMenuBarEndCap = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MainMenuBar-EndCap",
                mainMenuBarTrackingBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MainMenuBar-TrackingBar",
                microButtonAndBagsBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MicroButtonAndBagsBar",
                microButtonSettings_Up = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MicroButtonSettings-Up",
                microButtonSettings_Down = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\MicroButtonSettings-Down",
                performanceBar = MEDIA_PREFIX .. "\\Textures\\ActionBars\\Vanilla\\PerformanceBar"
            }
        },
        backdrops = {
            moverHighlightBackground = MEDIA_PREFIX .. "\\Textures\\Backdrops\\MoverHighlightBackground",
            moverSelectedBackground = MEDIA_PREFIX .. "\\Textures\\Backdrops\\MoverSelectedBackground"
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
            moverHighlight = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\MoverHighlight",
            moverSelected = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\MoverSelected",
            separatorHorizontal = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorHorizontal",
            separatorVertical = MEDIA_PREFIX .. "\\Textures\\EdgeFiles\\SeparatorVertical"
        },
        frames = {
            modern = {
                dualPaneFrame_Left = MEDIA_PREFIX .. "\\Textures\\Frames\\Modern\\DualPaneFrame-Left",
                dualPaneFrame_Right = MEDIA_PREFIX .. "\\Textures\\Frames\\Modern\\DualPaneFrame-Right",
                paperDollInfoFrame = MEDIA_PREFIX .. "\\Textures\\Frames\\Modern\\PaperDollInfoFrame"
            },
            vanilla = {
                dualPaneFrame_Left = MEDIA_PREFIX .. "\\Textures\\Frames\\Vanilla\\DualPaneFrame-Left",
                dualPaneFrame_Right = MEDIA_PREFIX .. "\\Textures\\Frames\\Vanilla\\DualPaneFrame-Right",
                paperDollInfoFrame = MEDIA_PREFIX .. "\\Textures\\Frames\\Vanilla\\PaperDollInfoFrame"
            }
        },
        icons = { backpack = MEDIA_PREFIX .. "\\Textures\\Icons\\Backpack", bank = MEDIA_PREFIX .. "\\Textures\\Icons\\Bank" },
        minimap = {
            modern = {
                atlas = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\Atlas",
                border = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\Border",
                buttonFrameToggle = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\ButtonFrameToggle",
                buttonFrameToggle_Highlight = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\ButtonFrameToggle-Highlight",
                calendarBlank = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\CalendarBlank",
                mask = MEDIA_PREFIX .. "\\Textures\\Minimap\\Modern\\Mask"
            },
            vanilla = {
                border = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\Border",
                minimapButtonHighlight = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\MinimapButton-Highlight",
                starButton_Down = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\StarButton-Up",
                starButton_Up = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\StarButton-Down",
                zoneBorder = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\ZoneBorder",
                mask = MEDIA_PREFIX .. "\\Textures\\Minimap\\Vanilla\\Mask"
            }
        },
        statusBars = {
            artifactPower = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ArtifactPower",
            castbar = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Castbar",
            castbarGlow = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarGlow",
            castbarChanneling = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarChanneling",
            castbarChannelingGlow = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarChannelingGlow",
            castbarCrafting = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarCrafting",
            castbarCraftingGlow = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarCraftingGlow",
            castbarEmpowering = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarEmpowering",
            castbarInterrupted = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarInterrupted",
            castbarUninterruptable = MEDIA_PREFIX .. "\\Textures\\StatusBars\\CastbarUninterruptable",
            experienceNormal = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ExperienceNormal",
            experienceRested = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ExperienceRested",
            honor = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Honor",
            redux = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Redux",
            onePixel = MEDIA_PREFIX .. "\\Textures\\StatusBars\\OnePixel",
            empty = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Empty",
            flat = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Flat",
            kait1 = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Kait1",
            kait2 = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Kait2",
            melli = MEDIA_PREFIX .. "\\Textures\\StatusBars\\Melli",
            melliDark = MEDIA_PREFIX .. "\\Textures\\StatusBars\\MelliDark",
            reputationGreen = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ReputationGreen",
            reputationOrange = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ReputationOrange",
            reputationRed = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ReputationRed",
            reputationYellow = MEDIA_PREFIX .. "\\Textures\\StatusBars\\ReputationYellow"
        },
        unitFrames = {
            comboPointBackground = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\ComboPointBackground",
            comboPointFill = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\ComboPointFill",
            restingFlipbook = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\RestingFlipbook",
            shield = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Shield",
            modern = {
                castingBar = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\CastingBar",
                castingBarChannelMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\CastingBarChannelMask",
                castingBarEnergyMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\CastingBarEnergyMask",
                castingBarFullMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\CastingBarFullMask",
                castingBarFx = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\CastingBarFx",
                playerPortraitMask = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\PlayerPortraitMask",
                unitFrame = MEDIA_PREFIX .. "\\Textures\\UnitFrames\\Modern\\UnitFrame"
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
R.Libs.SharedMedia:Register("statusbar", "Castbar", R.media.textures.statusBars.castbar)
R.Libs.SharedMedia:Register("statusbar", "Castbar - Channeling", R.media.textures.statusBars.castbarChanneling)
R.Libs.SharedMedia:Register("statusbar", "Castbar - Crafting", R.media.textures.statusBars.castbarCrafting)
R.Libs.SharedMedia:Register("statusbar", "Castbar - Empowering", R.media.textures.statusBars.castbarEmpowering)
R.Libs.SharedMedia:Register("statusbar", "Castbar - Interrupted", R.media.textures.statusBars.castbarInterrupted)
R.Libs.SharedMedia:Register("statusbar", "Castbar - Uninterruptable", R.media.textures.statusBars.castbarUninterruptable)
