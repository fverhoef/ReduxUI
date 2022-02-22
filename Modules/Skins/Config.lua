local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

R:RegisterModuleConfig(S, {
    enabled = true,
    colors = {guild = {0 / 255, 230 / 255, 0 / 255}},
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
    who = {enabled = true},
    worldMap = {enabled = true, scale = 0.7, movingOpacity = 0.5, stationaryOpacity = 1.0}
})
