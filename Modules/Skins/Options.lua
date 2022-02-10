local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

R:RegisterModuleOptions(S, {
    type = "group",
    name = L["Skins"],
    args = {
        header = {type = "header", name = R.title .. " > Skins", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return S.config.enabled end, function(value) S.config.enabled = value end,
                                       function() (not S.config.enabled and ReloadUI or C.Initialize)() end,
                                       function() return S.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak1 = {type = "header", name = "", order = 2}
    }
})
