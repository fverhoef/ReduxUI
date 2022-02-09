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
        mainMenuBar = {
            type = "group",
            name = L["Main Action Bar"],
            order = 3,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return AB.config.mainMenuBar.enabled end, function(value) AB.config.mainMenuBar.enabled = value end, AB.Update),
                lineBreak = {type = "header", name = "", order = 2},
                fadeIn = R:CreateToggleOption(L["Mouseover Fade In"], nil, 3, nil, nil, function() return AB.config.mainMenuBar.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.mainMenuBar.fader = value and R.config.faders.mouseOver or nil end, AB.Update),
                stackRightBar = R:CreateToggleOption(L["Stack Bottom Right Bar"], nil, 4, nil, nil, function() return AB.config.mainMenuBar.stackRightBar end,
                                                     function(value) AB.config.mainMenuBar.stackRightBar = value end, AB.Update)
            }
        },
        multiBarRight = {
            type = "group",
            name = L["Right Action Bar 1"],
            order = 12,
            inline = true,
            args = {
                fadeIn = R:CreateToggleOption(L["Mouseover Fade In"], nil, 1, nil, nil, function() return AB.config.multiBarRight.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.multiBarRight.fader = value and R.config.faders.mouseOver or nil end, AB.Update)
            }
        },
        multiBarLeft = {
            type = "group",
            name = L["Right Action Bar 2"],
            order = 13,
            inline = true,
            args = {
                fadeIn = R:CreateToggleOption(L["Mouseover Fade In"], nil, 1, nil, nil, function() return AB.config.multiBarLeft.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.multiBarLeft.fader = value and R.config.faders.mouseOver or nil end, AB.Update)
            }
        },
        microButtonAndBags = {
            type = "group",
            name = L["Micro Buttons & Bags Bar"],
            order = 14,
            inline = true,
            args = {
                fadeIn = R:CreateToggleOption(L["Mouseover Fade In"], nil, 1, nil, nil, function() return AB.config.microButtonAndBags.fader == R.config.faders.mouseOver end,
                                              function(value) AB.config.microButtonAndBags.fader = value and R.config.faders.mouseOver or nil end, AB.Update)
            }
        }
    }
})
