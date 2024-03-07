local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

S.Styles = { Vanilla = "Vanilla", Modern = "Modern" }

R:RegisterModuleConfig(S, {
    enabled = true,
    colors = { guild = { 0 / 255, 230 / 255, 0 / 255 } },
    fonts = {
        enabled = true,
        damage = R.Libs.SharedMedia:Fetch("font", "Adventure"),
        unitName = R.media.defaultFont,
        chatBubble = R.media.defaultFont
    },
    character = { enabled = true, style = S.Styles.Vanilla, showGearScore = true, selectedEnhancement = "PLAYERSTAT_MELEE_COMBAT" },
    durability = { enabled = true, point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260 } },
    friends = { enabled = true },
    guild = { enabled = true },
    objectiveTracker = { enabled = true, point = { "TOPLEFT", "UIParent", "TOPLEFT", 40, -20 } },
    questLog = { enabled = true, style = S.Styles.Vanilla },
    ticketStatus = { enabled = true, point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -228, -240 } },
    tradeSkill = { enabled = true, style = S.Styles.Vanilla },
    vehicleSeat = { enabled = true, point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260 } },
    widgets = {
        enabled = true,
        top = { enabled = true, point = { "TOP", "UIParent", "TOP", 0, -10 } },
        belowMinimap = { enabled = true, point = { "TOP", "UIParent", "TOP", 0, -60 } },
        powerbar = { enabled = true, point = { "BOTTOM", "UIParent", "BOTTOM", 0, 200 } }
    },
    who = { enabled = true },
    worldMap = { enabled = true, scale = 0.7, movingOpacity = 0.5, stationaryOpacity = 1.0 }
})
