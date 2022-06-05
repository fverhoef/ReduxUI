local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

R:RegisterModuleConfig(S, {
    enabled = true,
    colors = {guild = {0 / 255, 230 / 255, 0 / 255}},
    fonts = {
        enabled = true,
        damage = R.Libs.SharedMedia:Fetch("font", "Adventure"),
        normal = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        number = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        unitName = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        chatBubble = R.Libs.SharedMedia:Fetch("font", "Expressway Free")
    },
    character = {enabled = true},
    classTrainer = {enabled = true},
    durability = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260}},
    friends = {enabled = true},
    guild = {enabled = true},
    objectiveTracker = {enabled = true, point = {"TOPLEFT", "UIParent", "TOPLEFT", 40, -20}},
    questLog = {enabled = true},
    ticketStatus = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -228, -240}},
    tradeSkill = {enabled = true},
    vehicleSeat = {enabled = true, point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -260}},
    widgets = {enabled = true, top = {enabled = true, point = {"TOP", "UIParent", "TOP", 0, -50}}, belowMinimap = {enabled = true, point = {"TOP", "UIParent", "TOP", 0, -100}}},
    who = {enabled = true},
    worldMap = {enabled = true, scale = 0.7, movingOpacity = 0.5, stationaryOpacity = 1.0}
})
