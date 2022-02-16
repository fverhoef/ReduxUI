local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local UPDATE_DEFAULT_MODE = {[""] = "Never", ANY_CLICK = "Any Click", LEFT_CLICK = "Left Click", RIGHT_CLICK = "Right Click", MIDDLE_CLICK = "Middle Click"}
AB.UPDATE_DEFAULT_MODE = UPDATE_DEFAULT_MODE
AB.COLUMN_DIRECTIONS = {"Right", "Left"}
AB.ROW_DIRECTIONS = {"Up", "Down"}

R:RegisterModuleConfig(AB, {
    enabled = true,
    statusbars = {experience = R.Libs.SharedMedia:Fetch("statusbar", "Redux"), reputation = R.Libs.SharedMedia:Fetch("statusbar", "Redux")},
    colors = {},
    mainMenuBarArt = {enabled = true, fader = R.config.faders.onShow, stackBottomBars = false},
    microButtonAndBags = {enabled = true, point = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    actionBar1 = {
        enabled = true,
        keyBoundTarget = "ACTIONBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar2 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR1BUTTON",
        page = 6,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 35},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar3 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR2BUTTON",
        page = 5,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 65},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar4 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR3BUTTON",
        page = 3,
        point = {"RIGHT", "UIParent", "RIGHT", -5, 0},
        fader = R.config.faders.mouseOver,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar5 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR4BUTTON",
        page = 4,
        point = {"RIGHT", "UIParent", "RIGHT", -43, 0},
        fader = R.config.faders.mouseOver,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar6 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR6BUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar7 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR7BUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar8 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR8BUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar9 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR9BUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    actionBar10 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR10BUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    stanceBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 95},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    petActionBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 95},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    possessBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 95},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2
    },
    extraActionButton = {point = {"BOTTOM", "UIParent", "BOTTOM", 0, 300}},
    flyoutBars = {
        ["Mage Bar"] = {
            enabled = true,
            tbc = true,
            point = {"BOTTOMRIGHT", addonName .. "_Bar3_Button12", "TOPRIGHT", -12, 5},
            name = "Mage Bar",
            class = "MAGE",
            buttonSize = 32,
            buttonSpacing = 2,
            mouseover = true,
            inheritGlobalFade = false,
            backdrop = false,
            backdropSpacing = 2,
            direction = "UP",
            buttons = {
                {enabled = true, showOnlyMaxRank = false, name = L["Teleports"], actions = R.spellDatabase.Mage.Teleports, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = false, name = L["Portals"], actions = R.spellDatabase.Mage.Portals, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = false, name = L["Conjure Food"], actions = R.spellDatabase.Mage.ConjureFood, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = false, name = L["Conjure Water"], actions = R.spellDatabase.Mage.ConjureWater, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = false, name = L["Conjure Gems"], actions = R.spellDatabase.Mage.ConjureGem, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = true, name = L["Armors"], actions = R.spellDatabase.Mage.Armors, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK}
            }
        },
        ["Shaman Bar"] = {
            enabled = true,
            tbc = true,
            point = {"BOTTOMRIGHT", addonName .. "_Bar3_Button12", "TOPRIGHT", -12, 5},
            name = "Shaman Bar",
            class = "SHAMAN",
            buttonSize = 32,
            buttonSpacing = 2,
            mouseover = true,
            inheritGlobalFade = false,
            backdrop = false,
            backdropSpacing = 2,
            direction = "UP",
            buttons = {
                {enabled = true, showOnlyMaxRank = true, name = L["Fire Totems"], actions = R.spellDatabase.Shaman.FireTotems, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = true, name = L["Earth Totems"], actions = R.spellDatabase.Shaman.EarthTotems, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = true, name = L["Water Totems"], actions = R.spellDatabase.Shaman.WaterTotems, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = true, name = L["Air Totems"], actions = R.spellDatabase.Shaman.AirTotems, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK},
                {enabled = true, showOnlyMaxRank = true, name = L["Weapon Enchants"], actions = R.spellDatabase.Shaman.WeaponEnchants, defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK}
            }
        }

    },
    systemInfo = {
        enabled = true,
        lowLatencyTreshold = 70,
        lowLatencyColor = {0 / 255, 175 / 255, 0 / 255},
        mediumLatencyTreshold = 120,
        mediumLatencyColor = {225 / 255, 150 / 255, 0 / 255},
        highLatencyColor = {225 / 255, 0 / 255, 0 / 255},
        lowFpsTreshold = 20,
        lowFpsColor = {225 / 255, 0 / 255, 0 / 255},
        mediumFpsTreshold = 50,
        mediumFpsColor = {225 / 255, 150 / 255, 0 / 255},
        highFpsColor = {0 / 255, 175 / 255, 0 / 255},
        addonsToDisplay = 10
    }
})
