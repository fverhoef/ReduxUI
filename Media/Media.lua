local addonName, ns = ...
local R = _G.ReduxUI

R.media = {
    fonts = {adventure = "Interface\\AddOns\\" .. addonName .. "\\Media\\Fonts\\Adventure.ttf", expresswayFree = "Interface\\AddOns\\" .. addonName .. "\\Media\\Fonts\\ExpresswayFree.ttf"},
    textures = {
        blank = [[Interface\Buttons\WHITE8X8]],

        arrow = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Arrow",
        logo = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Logo",

        actionBars = {
            dataBarPanel = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\ActionBars\\DataBarPanel",
            mainMenuBar = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\ActionBars\\MainMenuBar",
            mainMenuBar_Alliance = "Interface\\PLAYERACTIONBARALT\\ALLIANCE",
            mainMenuBar_Amber = "Interface\\PLAYERACTIONBARALT\\Amber",
            mainMenuBar_Bamboo = "Interface\\PLAYERACTIONBARALT\\BAMBOO",
            mainMenuBar_Darkmoon = "Interface\\PLAYERACTIONBARALT\\Darkmoon",
            mainMenuBar_Fancy = "Interface\\PLAYERACTIONBARALT\\FANCY",
            mainMenuBar_Generic = "Interface\\PLAYERACTIONBARALT\\GENERICWOW",
            mainMenuBar_Horde = "Interface\\PLAYERACTIONBARALT\\HORDE",
            mainMenuBar_Mechanical = "Interface\\PLAYERACTIONBARALT\\Mechanical",
            mainMenuBar_Mechanical2 = "Interface\\PLAYERACTIONBARALT\\MECHANICAL2",
            mainMenuBar_Natural = "Interface\\PLAYERACTIONBARALT\\Natural",
            mainMenuBar_PandarenWood = "Interface\\PLAYERACTIONBARALT\\PandarenWood",
            mainMenuBar_Stone = "Interface\\PLAYERACTIONBARALT\\STONE",
            mainMenuBar_Tree = "Interface\\PLAYERACTIONBARALT\\TREE",
            mainMenuBar_Wood = "Interface\\PLAYERACTIONBARALT\\WOOD",
            microButtonSettings_Up = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\ActionBars\\MicroButtonSettings-Up",
            microButtonSettings_Down = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\ActionBars\\MicroButtonSettings-Down",
            performanceBar = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\ActionBars\\PerformanceBar"
        },

        backdrops = {blank = [[Interface\Buttons\WHITE8X8]], button = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Backdrops\\Button"},

        edgeFiles = {
            borderThick = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\BorderThick",
            borderThin = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\BorderThin",
            glow = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\Glow",
            inlay = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\Inlay",
            separatorHorizontal = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\SeparatorHorizontal",
            separatorVertical = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\EdgeFiles\\SeparatorVertical"
        },

        minimap = {
            minimapMask1 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Minimap\\MinimapMask1",
            minimapMask2 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Minimap\\MinimapMask2",
            minimapMask3 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Minimap\\MinimapMask3",
            minimapButtonBorder = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Minimap\\MinimapButtonBorder",
            minimapButtonBorder2 = "Interface\\AddOns\\" .. addonName .. "\\Media\\Textures\\Minimap\\MinimapButtonBorder2"
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
        },

        unitFrames = {
            unitFrame_Large = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\UnitFrame-Large",
            unitFrame_Large_Gold = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\UnitFrame-Large-Gold",
            unitFrame_Large_NoPower = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\UnitFrame-Large-NoPower",
            unitFrame_Large_NoPower_Gold = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\UnitFrame-Large-NoPower-Gold",

            targetFrame = "Interface\\TARGETINGFRAME\\UI-TargetingFrame",
            targetFrame_Elite = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Elite",
            targetFrame_Rare = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Rare",
            targetFrame_RareElite = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-RareElite",
            targetTargetFrame = "Interface\\TARGETINGFRAME\\UI-TargetofTargetFrame",
            smallTargetingFrame = "Interface\\TARGETINGFRAME\\UI-SmallTargetingFrame",
            partyFrame = "Interface\\TARGETINGFRAME\\UI-PartyFrame",
            targetFrame_LargerHealth = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\TargetFrame",
            targetFrame_Elite = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\TargetFrameElite",
            targetFrame_Rare = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\TargetFrameRare",
            targetFrame_RareElite = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\TargetFrameRareElite",
            targetFrame_Flash = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Flash",
            partyFrame_Flash = "Interface\\TARGETINGFRAME\\UI-PartyFrame-Flash",
            nameplate_Flash = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\NameplateFlash",
            playerStatus = "Interface\\CharacterFrame\\UI-Player-Status",
            playerStatus_LargerHealth = "Interface\\Addons\\" .. addonName .. "\\Media\\Textures\\UnitFrames\\TargetFrameStatus",
            groupIndicator = "Interface\\CharacterFrame\\UI-CHARACTERFRAME-GROUPINDICATOR",
            comboFrameBackground = "Interface\\COMBOFRAME\\ComboFrameBackground",
            comboPoint = "Interface\\COMBOFRAME\\COMBOPOINT"
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
