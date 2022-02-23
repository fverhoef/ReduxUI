local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver
local L = R.L

R:RegisterModuleOptions(SS, {
    type = "group",
    name = L["Screen Saver"],
    args = {
        header = {type = "header", name = R.title .. " > Screen Saver", order = 0},
        enabled = R:CreateModuleEnabledOption(1, nil, "ScreenSaver"),
        lineBreak = {type = "header", name = "", order = 2}
    }
})