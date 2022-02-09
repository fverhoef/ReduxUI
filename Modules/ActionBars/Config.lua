local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

R:RegisterModuleConfig(AB, {
    enabled = true,
    mainMenuBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 0}, fader = R.config.faders.onShow, stackRightBar = true},
    multiBarBottomLeft = {enabled = true, detached = false, point = {"RIGHT", "RIGHT", -38, 0}, fader = R.config.faders.mouseOver},
    multiBarBottomRight = {enabled = true, detached = false, point = {"RIGHT", "RIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    multiBarLeft = {enabled = true, point = {"RIGHT", "RIGHT", -38, 0}, fader = R.config.faders.mouseOver},
    multiBarRight = {enabled = true, point = {"RIGHT", "RIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    stanceBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 89}, fader = R.config.faders.onShow},
    petActionBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 89}, fader = R.config.faders.onShow},
    vehicleExitBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 200}, fader = R.config.faders.onShow},
    microButtonAndBags = {
        enabled = true,
        point = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0},
        fader = R.config.faders.mouseOver,
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
