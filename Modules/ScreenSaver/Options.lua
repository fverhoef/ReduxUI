local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver
local L = R.L

R:RegisterModuleOptions(SS, {
    type = "group",
    name = L["Screen Saver"],
    args = {
        enabled = R:CreateModuleEnabledOption(1, nil, "ScreenSaver")
    }
}, true)