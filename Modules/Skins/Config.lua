local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

S.Styles = {
    Vanilla = "Vanilla",
    Dragonflight = "Dragonflight"
}

R:RegisterModuleConfig(S, {
    enabled = true,
    colors = {guild = {0 / 255, 230 / 255, 0 / 255}},
    fonts = {
        enabled = true,
        damage = R.Libs.SharedMedia:Fetch("font", "Adventure"),
        unitName = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        chatBubble = R.Libs.SharedMedia:Fetch("font", "Expressway Free")
    },
    character = {enabled = true, style = S.Styles.Dragonflight },
    durability = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260}},
    friends = {enabled = true},
    guild = {enabled = true},
    objectiveTracker = {enabled = true, point = {"TOPLEFT", "UIParent", "TOPLEFT", 40, -20}},
    ticketStatus = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -228, -240}},
    tradeSkill = {enabled = true, style = S.Styles.Dragonflight},
    vehicleSeat = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260}},
    widgets = {enabled = true, top = {enabled = true, point = {"TOP", "UIParent", "TOP", 0, -10}}, belowMinimap = {enabled = true, point = {"TOP", "UIParent", "TOP", 0, -60}}},
    who = {enabled = true},
    worldMap = {enabled = true, scale = 0.7, movingOpacity = 0.5, stationaryOpacity = 1.0}
})
