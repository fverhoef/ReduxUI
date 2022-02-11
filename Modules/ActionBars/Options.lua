local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

R:RegisterModuleOptions(AB, {
    type = "group",
    name = L["Action Bars"],
    args = {
        header = {type = "header", name = R.title .. " > Action Bars", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return AB.config.enabled end, function(value) AB.config.enabled = value end,
                                       function() (not AB.config.enabled and ReloadUI or AB.Initialize)() end,
                                       function() return AB.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak = {type = "header", name = "", order = 2},
        stackBottomBars = R:CreateToggleOption(L["Stack Bottom Bars"], nil, 3, nil, nil, function() return AB.config.mainMenuBar.stackBottomBars end,
                                               function(value) AB.config.mainMenuBar.stackBottomBars = value end, AB.Update),
        faders = {
            type = "group",
            name = L["Mouseover Fade In"],
            order = 4,
            inline = true,
            args = {
                mainMenuBar = R:CreateToggleOption(L["Main Action Bar"], nil, 3, nil, nil, function() return AB.config.mainMenuBar.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.mainMenuBar.fader = value and R.config.faders.mouseOver or nil end, AB.Update),
                multiBarRight = R:CreateToggleOption(L["Right Action Bar 1"], nil, 2, nil, nil, function() return AB.config.multiBarRight.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.multiBarRight.fader = value and R.config.faders.mouseOver or nil end, AB.Update),
                multiBarLeft = R:CreateToggleOption(L["Right Action Bar 2"], nil, 3, nil, nil, function() return AB.config.multiBarLeft.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.multiBarLeft.fader = value and R.config.faders.mouseOver or nil end, AB.Update),
                microButtonAndBags = R:CreateToggleOption(L["Menu & Bags Bar"], nil, 4, nil, nil, function() return AB.config.microButtonAndBags.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.microButtonAndBags.fader = value and R.config.faders.mouseOver or nil end, AB.Update)
            }
        }
    }
})
