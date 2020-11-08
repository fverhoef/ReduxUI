local AddonName, AddonTable = ...
local Addon = AddonTable[1]

Addon.media = {
    fonts = {
        Adventure = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Fonts\\Adventure.ttf",
        ExpresswayFree = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Fonts\\ExpresswayFree.ttf"
    },
    textures = {
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
        
        -- ActionBars
        MainMenuBar = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MainMenuBar",
        MainMenuBar_Alliance = "Interface\\PLAYERACTIONBARALT\\ALLIANCE",
        MainMenuBar_Amber = "Interface\\PLAYERACTIONBARALT\\Amber",
        MainMenuBar_Bamboo = "Interface\\PLAYERACTIONBARALT\\BAMBOO",
        MainMenuBar_Darkmoon = "Interface\\PLAYERACTIONBARALT\\Darkmoon",
        MainMenuBar_Fancy = "Interface\\PLAYERACTIONBARALT\\FANCY",
        MainMenuBar_Generic = "Interface\\PLAYERACTIONBARALT\\GENERICWOW",
        MainMenuBar_Horde = "Interface\\PLAYERACTIONBARALT\\HORDE",
        MainMenuBar_Mechanical = "Interface\\PLAYERACTIONBARALT\\Mechanical",
        MainMenuBar_Mechanical2 = "Interface\\PLAYERACTIONBARALT\\MECHANICAL2",
        MainMenuBar_Natural = "Interface\\PLAYERACTIONBARALT\\Natural",
        MainMenuBar_PandarenWood = "Interface\\PLAYERACTIONBARALT\\PandarenWood",
        MainMenuBar_Stone = "Interface\\PLAYERACTIONBARALT\\STONE",
        MainMenuBar_Tree = "Interface\\PLAYERACTIONBARALT\\TREE",
        MainMenuBar_Wood = "Interface\\PLAYERACTIONBARALT\\WOOD",
        PerformanceBar = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\PerformanceBar",
        SilverButtonLeft = "Interface\\BUTTONS\\UI-SilverButtonLG-Left-Up",
        SilverButtonRight = "Interface\\BUTTONS\\UI-SilverButtonLG-Right-Up",

        -- UnitFrames
        TargetFrame = "Interface\\TARGETINGFRAME\\UI-TargetingFrame",
        TargetFrame_Elite = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Elite",
        TargetFrame_Rare = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Rare",
        TargetFrame_RareElite = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-RareElite",
        TargetTargetFrame = "Interface\\TARGETINGFRAME\\UI-TargetofTargetFrame",
        SmallTargetingFrame = "Interface\\TARGETINGFRAME\\UI-SmallTargetingFrame",
        PartyFrame = "Interface\\TARGETINGFRAME\\UI-PartyFrame",

        TargetFrame_LargerHealth = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\TargetFrame",
        TargetFrame_LargerHealth_Elite = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\TargetFrameElite",
        TargetFrame_LargerHealth_Rare = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\TargetFrameRare",
        TargetFrame_LargerHealth_RareElite = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\TargetFrameRareElite",

        TargetFrame_Flash = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Flash",
        PartyFrame_Flash = "Interface\\TARGETINGFRAME\\UI-PartyFrame-Flash",
        Nameplate_Flash = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\NameplateFlash",

        PlayerStatus = "Interface\\CharacterFrame\\UI-Player-Status",
        PlayerStatus_LargerHealth = "Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\TargetFrameStatus",

        GroupIndicator = "Interface\\CharacterFrame\\UI-CHARACTERFRAME-GROUPINDICATOR",
        ComboFrameBackground = "Interface\\COMBOFRAME\\ComboFrameBackground",
        ComboPoint = "Interface\\COMBOFRAME\\COMBOPOINT",

        -- Blizzard Arrows
        arrowDown_Down = "Interface\\BUTTONS\\Arrow-Down-Down",
        arrowDown_Up = "Interface\\BUTTONS\\Arrow-Down-Up",
        arrowUp_Down = "Interface\\BUTTONS\\Arrow-Up-Down",
        arrowUp_Up = "Interface\\BUTTONS\\Arrow-Up-Up",

        -- Minimap
        autoQuestParts = "Interface\\QUESTFRAME\\AutoQuest-Parts",
        bonusObjectives = "Interface\\QUESTFRAME\\BonusObjectives",
        mailIcon = "Interface\\MINIMAP\\TRACKING\\Mailbox",
        minimapMask1 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MinimapMask1",
        minimapMask2 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MinimapMask2",
        minimapMask3 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MinimapMask3",
        minimapButtonBorder = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MinimapButtonBorder",
        minimapButtonBorder2 = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\MinimapButtonBorder2",
        portraitAlphaMask = "Interface\\CharacterFrame\\TempPortraitAlphaMask",

        -- Buttons        
        buttonNormal = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonNormal",
        buttonPushed = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonPushed",
        buttonHighlight = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonHighlight",
        buttonChecked = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonChecked",
        buttonFlash = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonFlash",
        buttonBorderWhite = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonBorderWhite",
        buttonBorderWhiteThin = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonBorderWhiteThin",
        buttonBackdrop = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonBackdrop",
        buttonBackdropBorder = "Interface\\AddOns\\" .. AddonName .. "\\Media\\Textures\\ButtonBackdropBorder",
    }
}

-- register shared media
Addon.Libs.SharedMedia:Register("font", "Adventure", Addon.media.fonts.Adventure )
Addon.Libs.SharedMedia:Register("font", "Expressway Free", Addon.media.fonts.ExpresswayFree)
Addon.Libs.SharedMedia:Register("statusbar", "Redux", Addon.media.textures.StatusBar_Redux)
Addon.Libs.SharedMedia:Register("statusbar", "Redux (One Pixel)", Addon.media.textures.StatusBar_OnePixel)
Addon.Libs.SharedMedia:Register("statusbar", "Empty", Addon.media.textures.StatusBar_Empty)
Addon.Libs.SharedMedia:Register("statusbar", "Flat", Addon.media.textures.StatusBar_Flat)
Addon.Libs.SharedMedia:Register("statusbar", "Kait1", Addon.media.textures.StatusBar_Kait1)
Addon.Libs.SharedMedia:Register("statusbar", "Kait2", Addon.media.textures.StatusBar_Kait2)
Addon.Libs.SharedMedia:Register("statusbar", "Melli", Addon.media.textures.StatusBar_Melli)
Addon.Libs.SharedMedia:Register("statusbar", "MelliDark", Addon.media.textures.StatusBar_MelliDark)