local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionBarOptions(id)
    return {
        type = "group",
        name = L["Action Bar"] .. " " .. id,
        order = 10 + id,
        args = {
            header = {type = "header", name = R.title .. " > Action Bars > Action Bar " .. id, order = 0},
            enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return AB.config["actionBar" .. id].enabled end, function(value)
                AB.config["actionBar" .. id].enabled = value
            end, function() AB:Update() end),
            lineBreak = {type = "header", name = "", order = 2},
            buttons = R:CreateRangeOption(L["Button Count"], L["The number of buttons on this bar."], 3, nil, 1, 12, nil, 1, function() return AB.config["actionBar" .. id].buttons end,
                                          function(value) AB.config["actionBar" .. id].buttons = value end, function() AB:Update() end),
            buttonSize = R:CreateRangeOption(L["Button Size"], L["The size of the buttons on this bar."], 4, nil, 10, 50, nil, 1, function() return AB.config["actionBar" .. id].buttonSize end,
                                             function(value) AB.config["actionBar" .. id].buttonSize = value end, function() AB:Update() end),
            buttonsPerRow = R:CreateRangeOption(L["Buttons Per Row"], L["The number of buttons in each row."], 5, nil, 1, 12, nil, 1, function()
                return AB.config["actionBar" .. id].buttonsPerRow
            end, function(value) AB.config["actionBar" .. id].buttonsPerRow = value end, function() AB:Update() end),
            lineBreak2 = {type = "description", name = "", order = 6},
            columnSpacing = R:CreateRangeOption(L["Column Spacing"], L["The spacing between each column."], 7, nil, 1, 12, nil, 1, function()
                return AB.config["actionBar" .. id].columnSpacing
            end, function(value) AB.config["actionBar" .. id].columnSpacing = value end, function() AB:Update() end),
            columnDirection = R:CreateSelectOption(L["Column Growth Direction"], L["The direction in which columns grow."], 8, nil, AB.COLUMN_DIRECTIONS,
                                                   function() return AB.config["actionBar" .. id].columnDirection end, function(value) AB.config["actionBar" .. id].columnDirection = value end,
                                                   function() AB:Update() end),
            linebreak3 = {type = "description", name = "", order = 9},
            rowSpacing = R:CreateRangeOption(L["Row Spacing"], L["The spacing between each row."], 10, nil, 1, 12, nil, 1, function() return AB.config["actionBar" .. id].rowSpacing end,
                                             function(value) AB.config["actionBar" .. id].rowSpacing = value end, function() AB:Update() end),
            rowDirection = R:CreateSelectOption(L["Row Growth Direction"], L["The direction in which rows grow."], 11, nil, AB.ROW_DIRECTIONS,
                                                function() return AB.config["actionBar" .. id].rowDirection end, function(value) AB.config["actionBar" .. id].rowDirection = value end,
                                                function() AB:Update() end),
            linebreak4 = {type = "description", name = "", order = 12},
            fade = R:CreateToggleOption(L["Mouseover Fade"], nil, 13, nil, nil, function() return AB.config["actionBar" .. id].fader == R.config.faders.mouseOver end,
                                        function(value) AB.config["actionBar" .. id].fader = value and R.config.faders.mouseOver or R.config.faders.onShow end, function() AB:Update() end),
            linebreak5 = {type = "description", name = "", order = 14},
            backdrop = R:CreateToggleOption(L["Show Backdrop"], nil, 15, nil, nil, function() return AB.config["actionBar" .. id].backdrop end,
                                            function(value) AB.config["actionBar" .. id].backdrop = value end, function() AB:Update() end),
            border = R:CreateToggleOption(L["Show Border"], nil, 16, nil, nil, function() return AB.config["actionBar" .. id].border end,
                                          function(value) AB.config["actionBar" .. id].border = value end, function() AB:Update() end),
            shadow = R:CreateToggleOption(L["Shadow"], nil, 17, nil, nil, function() return AB.config["actionBar" .. id].shadow end, function(value)
                AB.config["actionBar" .. id].shadow = value
            end, function() AB:Update() end)
        }
    }
end

R:RegisterModuleOptions(AB, {
    type = "group",
    name = L["Action Bars"],
    args = {
        header = {type = "header", name = R.title .. " > Action Bars", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "full", nil, function() return AB.config.enabled end, function(value) AB.config.enabled = value end,
                                       function() (not AB.config.enabled and ReloadUI or AB.Initialize)() end,
                                       function() return AB.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak = {type = "header", name = "", order = 2},
        toggleKeybindMode = {order = 3, type = "execute", name = L["Toggle Keybind Mode"], desc = L["Enter/leave keybind mode."], func = function() R.Libs.KeyBound:Toggle() end},
        enableArt = R:CreateToggleOption(L["Enable Main Menu Bar Art"], nil, 4, "full", nil, function() return AB.config.mainMenuBarArt.enabled end,
                                         function(value) AB.config.mainMenuBarArt.enabled = value end, AB.Update),
        stackBottomBars = R:CreateToggleOption(L["Stack Bottom Bars"], nil, 5, "full", function() return not AB.config.mainMenuBarArt.enabled end,
                                               function() return AB.config.mainMenuBarArt.stackBottomBars end, function(value) AB.config.mainMenuBarArt.stackBottomBars = value end, AB.Update),
        actionBar1 = AB:CreateActionBarOptions(1),
        actionBar2 = AB:CreateActionBarOptions(2),
        actionBar3 = AB:CreateActionBarOptions(3),
        actionBar4 = AB:CreateActionBarOptions(4),
        actionBar5 = AB:CreateActionBarOptions(5),
        actionBar6 = AB:CreateActionBarOptions(6),
        actionBar7 = AB:CreateActionBarOptions(7),
        actionBar8 = AB:CreateActionBarOptions(8),
        actionBar9 = AB:CreateActionBarOptions(9),
        actionBar10 = AB:CreateActionBarOptions(10)
    }
})
