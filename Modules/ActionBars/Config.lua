local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local UPDATE_DEFAULT_MODE = {
    [""] = "Never",
    ANY_CLICK = "Any Click",
    LEFT_CLICK = "Left Click",
    RIGHT_CLICK = "Right Click",
    MIDDLE_CLICK = "Middle Click"
}
AB.UPDATE_DEFAULT_MODE = UPDATE_DEFAULT_MODE

R:RegisterModuleConfig(AB, {
    enabled = true,
    mainMenuBar = {enabled = true, fader = R.config.faders.onShow, stackBottomBars = false},
    multiBarBottomLeft = {enabled = true, fader = R.config.faders.onShow},
    multiBarBottomRight = {enabled = true, fader = R.config.faders.onShow},
    multiBarLeft = {enabled = true, point = {"RIGHT", "UIParent", "RIGHT", -38, 0}, fader = R.config.faders.mouseOver},
    multiBarRight = {enabled = true, point = {"RIGHT", "UIParent", "RIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    stanceBar = {enabled = true, fader = R.config.faders.onShow},
    petActionBar = {enabled = true, fader = R.config.faders.onShow},
    possessBar = {enabled = true, fader = R.config.faders.onShow},
    microButtonAndBags = {
        enabled = true,
        point = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0},
        fader = R.config.faders.mouseOver
    },
    extraActionButton = {
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 300},
    },
    flyoutBars = {
        ["Mage Bar"] = {
            enabled = true,
            tbc = true,
            point = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT", -12, 5},
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
                {
                    enabled = true,
                    showOnlyMaxRank = false,
                    name = L["Teleports"],
                    actions = R.spellDatabase.Mage.Teleports,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = false,
                    name = L["Portals"],
                    actions = R.spellDatabase.Mage.Portals,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = false,
                    name = L["Conjure Food"],
                    actions = R.spellDatabase.Mage.ConjureFood,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = false,
                    name = L["Conjure Water"],
                    actions = R.spellDatabase.Mage.ConjureWater,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = false,
                    name = L["Conjure Gems"],
                    actions = R.spellDatabase.Mage.ConjureGem,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Armors"],
                    actions = R.spellDatabase.Mage.Armors,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                }
            }
        },
        ["Shaman Bar"] = {
            enabled = true,
            tbc = true,
            point = {"BOTTOMRIGHT", "MultiBarBottomRightButton12", "TOPRIGHT", -12, 5},
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
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Fire Totems"],
                    actions = R.spellDatabase.Shaman.FireTotems,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Earth Totems"],
                    actions = R.spellDatabase.Shaman.EarthTotems,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Water Totems"],
                    actions = R.spellDatabase.Shaman.WaterTotems,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Air Totems"],
                    actions = R.spellDatabase.Shaman.AirTotems,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                },
                {
                    enabled = true,
                    showOnlyMaxRank = true,
                    name = L["Weapon Enchants"],
                    actions = R.spellDatabase.Shaman.WeaponEnchants,
                    defaultActionUpdateMode = UPDATE_DEFAULT_MODE.ANY_CLICK
                }
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
