local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local CLASS_RESTRICTIONS = { [""] = L["None"] }
local NEW_BAR = L["New Bar"]

for key, value in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
    CLASS_RESTRICTIONS[key] = value
end

local selectedSpells = {}
local addSpellFilter

function AB:CreateActionBarOptions(id)
    return {
        type = "group",
        name = L["Action Bar"] .. " " .. id,
        order = 10 + id,
        args = {
            header = { type = "header", name = R.title .. " > Action Bars > Action Bar " .. id, order = 0 },
            enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function()
                return AB.config["actionBar" .. id].enabled
            end, function(value)
                AB.config["actionBar" .. id].enabled = value
            end, function()
                AB:Update()
            end),
            layout = {
                type = "group",
                name = L["Layout"],
                order = 2,
                inline = true,
                disabled = function()
                    return not AB.config["actionBar" .. id].enabled
                end,
                args = {
                    buttons = R:CreateRangeOption(L["Button Count"], L["The number of buttons on this bar."], 3, nil, 1, 12, nil, 1, function()
                        return AB.config["actionBar" .. id].buttons
                    end, function(value)
                        AB.config["actionBar" .. id].buttons = value
                    end, function()
                        AB:Update()
                    end),
                    buttonSize = R:CreateRangeOption(L["Button Size"], L["The size of the buttons on this bar."], 4, nil, 10, 50, nil, 1, function()
                        return AB.config["actionBar" .. id].buttonSize
                    end, function(value)
                        AB.config["actionBar" .. id].buttonSize = value
                    end, function()
                        AB:Update()
                    end),
                    buttonsPerRow = R:CreateRangeOption(L["Buttons Per Row"], L["The number of buttons in each row."], 5, nil, 1, 12, nil, 1, function()
                        return AB.config["actionBar" .. id].buttonsPerRow
                    end, function(value)
                        AB.config["actionBar" .. id].buttonsPerRow = value
                    end, function()
                        AB:Update()
                    end),
                    lineBreak2 = { type = "description", name = "", order = 6 },
                    columnSpacing = R:CreateRangeOption(L["Column Spacing"], L["The spacing between each column."], 7, nil, 1, 12, nil, 1, function()
                        return AB.config["actionBar" .. id].columnSpacing
                    end, function(value)
                        AB.config["actionBar" .. id].columnSpacing = value
                    end, function()
                        AB:Update()
                    end),
                    columnDirection = R:CreateSelectOption(L["Column Growth Direction"], L["The direction in which columns grow."], 8, nil, AB.COLUMN_DIRECTIONS, function()
                        return AB.config["actionBar" .. id].columnDirection
                    end, function(value)
                        AB.config["actionBar" .. id].columnDirection = value
                    end, function()
                        AB:Update()
                    end),
                    linebreak3 = { type = "description", name = "", order = 9 },
                    rowSpacing = R:CreateRangeOption(L["Row Spacing"], L["The spacing between each row."], 10, nil, 1, 12, nil, 1, function()
                        return AB.config["actionBar" .. id].rowSpacing
                    end, function(value)
                        AB.config["actionBar" .. id].rowSpacing = value
                    end, function()
                        AB:Update()
                    end),
                    rowDirection = R:CreateSelectOption(L["Row Growth Direction"], L["The direction in which rows grow."], 11, nil, AB.ROW_DIRECTIONS, function()
                        return AB.config["actionBar" .. id].rowDirection
                    end, function(value)
                        AB.config["actionBar" .. id].rowDirection = value
                    end, function()
                        AB:Update()
                    end)
                }
            },
            styling = {
                type = "group",
                name = L["Styling"],
                order = 3,
                inline = true,
                disabled = function()
                    return not AB.config["actionBar" .. id].enabled
                end,
                args = {
                    fade = R:CreateToggleOption(L["Mouseover Fade"], nil, 13, nil, nil, function()
                        return AB.config["actionBar" .. id].fader == R.config.faders.mouseOver
                    end, function(value)
                        AB.config["actionBar" .. id].fader = value and R.config.faders.mouseOver or R.config.faders.onShow
                    end, function()
                        AB:Update()
                    end),
                    linebreak5 = { type = "description", name = "", order = 14 },
                    backdrop = R:CreateToggleOption(L["Show Backdrop"], nil, 15, nil, nil, function()
                        return AB.config["actionBar" .. id].backdrop
                    end, function(value)
                        AB.config["actionBar" .. id].backdrop = value
                    end, function()
                        AB:Update()
                    end),
                    border = R:CreateToggleOption(L["Show Border"], nil, 16, nil, nil, function()
                        return AB.config["actionBar" .. id].border
                    end, function(value)
                        AB.config["actionBar" .. id].border = value
                    end, function()
                        AB:Update()
                    end),
                    shadow = R:CreateToggleOption(L["Shadow"], nil, 17, nil, nil, function()
                        return AB.config["actionBar" .. id].shadow
                    end, function(value)
                        AB.config["actionBar" .. id].shadow = value
                    end, function()
                        AB:Update()
                    end)
                }
            }
        }
    }
end

function AB:CreateMiscBarOptions(name, title, order, hidden)
    return {
        type = "group",
        name = title,
        order = order,
        hidden = hidden,
        args = {
            header = { type = "header", name = R.title .. " > Action Bars > " .. title, order = 0 },
            enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function()
                return AB.config[name].enabled
            end, function(value)
                AB.config[name].enabled = value
            end, function()
                AB:Update()
            end),
            lineBreak = { type = "header", name = "", order = 2 },
            buttonSize = R:CreateRangeOption(L["Button Size"], L["The size of the buttons on this bar."], 4, nil, 10, 50, nil, 1, function()
                return AB.config[name].buttonSize
            end, function(value)
                AB.config[name].buttonSize = value
            end, function()
                AB:Update()
            end),
            columnSpacing = R:CreateRangeOption(L["Button Spacing"], L["The spacing between each button."], 5, nil, 1, 12, nil, 1, function()
                return AB.config[name].columnSpacing
            end, function(value)
                AB.config[name].columnSpacing = value
            end, function()
                AB:Update()
            end),
            lineBreak2 = { type = "description", name = "", order = 6 },
            fade = R:CreateToggleOption(L["Mouseover Fade"], nil, 13, nil, nil, function()
                return AB.config[name].fader == R.config.faders.mouseOver
            end, function(value)
                AB.config[name].fader = value and R.config.faders.mouseOver or R.config.faders.onShow
            end, function()
                AB:Update()
            end),
            linebreak5 = { type = "description", name = "", order = 14 },
            backdrop = R:CreateToggleOption(L["Show Backdrop"], nil, 15, nil, nil, function()
                return AB.config[name].backdrop
            end, function(value)
                AB.config[name].backdrop = value
            end, function()
                AB:Update()
            end),
            border = R:CreateToggleOption(L["Show Border"], nil, 16, nil, nil, function()
                return AB.config[name].border
            end, function(value)
                AB.config[name].border = value
            end, function()
                AB:Update()
            end),
            shadow = R:CreateToggleOption(L["Shadow"], nil, 17, nil, nil, function()
                return AB.config[name].shadow
            end, function(value)
                AB.config[name].shadow = value
            end, function()
                AB:Update()
            end)
        }
    }
end

R:RegisterModuleOptions(AB, function()
    return {
        type = "group",
        name = L["Action Bars"],
        args = {
            header = { type = "header", name = R.title .. " > Action Bars", order = 0 },
            enabled = R:CreateModuleEnabledOption(1, nil, "ActionBars"),
            lineBreak = { type = "header", name = "", order = 2 },
            toggleKeybindMode = {
                order = 3,
                type = "execute",
                name = L["Toggle Keybind Mode"],
                desc = L["Enter/leave keybind mode."],
                func = function()
                    R.Libs.KeyBound:Toggle()
                end
            },
            mainMenuBarArt = {
                type = "group",
                name = L["Main Menu Bar Art"],
                order = 4,
                inline = true,
                args = {
                    enableArt = R:CreateToggleOption(L["Enabled"], nil, 1, "full", nil, function()
                        return AB.config.mainMenuBarArt.enabled
                    end, function(value)
                        AB.config.mainMenuBarArt.enabled = value
                    end, AB.Update),
                    stackBottomBars = R:CreateToggleOption(L["Stack Bottom Bars"], nil, 2, nil, function()
                        return not AB.config.mainMenuBarArt.enabled
                    end, function()
                        return AB.config.mainMenuBarArt.stackBottomBars
                    end, function(value)
                        AB.config.mainMenuBarArt.stackBottomBars = value
                    end, AB.Update)
                }
            },
            actionBar1 = AB:CreateActionBarOptions(1),
            actionBar2 = AB:CreateActionBarOptions(2),
            actionBar3 = AB:CreateActionBarOptions(3),
            actionBar4 = AB:CreateActionBarOptions(4),
            actionBar5 = AB:CreateActionBarOptions(5),
            actionBar6 = AB:CreateActionBarOptions(6),
            actionBar7 = AB:CreateActionBarOptions(7),
            actionBar8 = AB:CreateActionBarOptions(8),
            actionBar9 = AB:CreateActionBarOptions(9),
            actionBar10 = AB:CreateActionBarOptions(10),
            petBar = AB:CreateMiscBarOptions("petBar", L["Pet Bar"], 21),
            stanceBar = AB:CreateMiscBarOptions("stanceBar", L["Stance Bar"], 22),
            totemBar = AB:CreateMiscBarOptions("totemBar", L["Totem Bar"], 23, R.isRetail)
        }
    }
end)
