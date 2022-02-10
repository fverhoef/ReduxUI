local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

R:RegisterModuleConfig(S, {
    enabled = true,
    colors = {guild = {0 / 255, 230 / 255, 0 / 255}},
    character = {enabled = true},
    classTrainer = {enabled = true},
    friends = {enabled = true},
    guild = {enabled = true},
    questLog = {enabled = true},
    tradeSkill = {enabled = true},
    who = {enabled = true},
    worldMap = {enabled = true, scale = 0.7, movingOpacity = 0.5, stationaryOpacity = 1.0}
})
