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

function AB:CreateActionBarOptions(id, disabledFunc)
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
            disabledNote = {
                type = "description",
                name = L["NOTE: When using Vanilla style main action bars, some options are disabled."],
                order = 2,
                hidden = function()
                    return not AB.config["actionBar" .. id].enabled or not (disabledFunc and disabledFunc())
                end
            },
            art = {
                type = "group",
                name = L["Art"],
                order = 3,
                inline = true,
                hidden = id ~= 1,
                args = {
                    enableVanillaArt = R:CreateToggleOption(L["Enable Vanilla Art"], nil, 1, "full", nil, function()
                        return AB.config.actionBar1.vanillaArt.enabled
                    end, function(value)
                        AB.config.actionBar1.vanillaArt.enabled = value
                    end, AB.Update),
                    stackBottomBars = R:CreateToggleOption(L["Stack Bottom Bars"], nil, 2, nil, function()
                        return id ~= 1 or not AB.config.actionBar1.vanillaArt.enabled
                    end, function()
                        return AB.config.actionBar1.vanillaArt.stackBottomBars
                    end, function(value)
                        AB.config.actionBar1.vanillaArt.stackBottomBars = value
                    end, AB.Update)
                }
            },
            layout = {
                type = "group",
                name = L["Layout"],
                order = 4,
                inline = true,
                disabled = function()
                    return not AB.config["actionBar" .. id].enabled or (disabledFunc and disabledFunc())
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
                order = 5,
                inline = true,
                disabled = function()
                    return not AB.config["actionBar" .. id].enabled or (disabledFunc and disabledFunc())
                end,
                args = {
                    fade = R:CreateToggleOption(L["Mouseover Fade"], L["Whether to only show this bar when the mouse is over it"], 4, nil, nil, function()
                        return AB.config["actionBar" .. id].fader == R.config.faders.mouseOver
                    end, function(value)
                        AB.config["actionBar" .. id].fader = value and R.config.faders.mouseOver or R.config.faders.onShow
                    end, function()
                        AB:Update()
                    end),
                    linebreak1 = { type = "description", name = "", order = 5 },
                    backdrop = R:CreateToggleOption(L["Show Backdrop"], L["Whether or not to show a backdrop behind this bar"], 6, nil, nil, function()
                        return AB.config["actionBar" .. id].backdrop
                    end, function(value)
                        AB.config["actionBar" .. id].backdrop = value
                    end, function()
                        AB:Update()
                    end),
                    border = R:CreateToggleOption(L["Show Border"], L["Whether or not to show a border around this bar"], 7, nil, nil, function()
                        return AB.config["actionBar" .. id].border
                    end, function(value)
                        AB.config["actionBar" .. id].border = value
                    end, function()
                        AB:Update()
                    end),
                    shadow = R:CreateToggleOption(L["Shadow"], L["Whether or not to show a shadow behind this bar"], 8, nil, nil, function()
                        return AB.config["actionBar" .. id].shadow
                    end, function(value)
                        AB.config["actionBar" .. id].shadow = value
                    end, function()
                        AB:Update()
                    end),
                    linebreak2 = { type = "description", name = "", order = 9 },
                    showGrid = R:CreateToggleOption(L["Show Grid"], L["Whether to show buttons when unassigned an action"], 10, nil, nil, function()
                        return AB.config["actionBar" .. id].showGrid
                    end, function(value)
                        AB.config["actionBar" .. id].showGrid = value
                    end, function()
                        AB:Update()
                    end)
                }
            }
        }
    }
end

function AB:CreateMiscBarOptions(name, title, order, hidden, disabledFunc)
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
            disabledNote = {
                type = "description",
                name = L["NOTE: When using Vanilla style main action bars, some options are disabled."],
                order = 2,
                hidden = function()
                    return not AB.config[name].enabled or not (disabledFunc and disabledFunc())
                end
            },
            layout = {
                type = "group",
                name = L["Layout"],
                order = 3,
                inline = true,
                disabled = function()
                    return not AB.config[name].enabled or (disabledFunc and disabledFunc())
                end,
                args = {
                    buttonSize = R:CreateRangeOption(L["Button Size"], L["The size of the buttons on this bar."], 1, nil, 10, 50, nil, 1, function()
                        return AB.config[name].buttonSize
                    end, function(value)
                        AB.config[name].buttonSize = value
                    end, function()
                        AB:Update()
                    end),
                    columnSpacing = R:CreateRangeOption(L["Button Spacing"], L["The spacing between each button."], 2, nil, 1, 12, nil, 1, function()
                        return AB.config[name].columnSpacing
                    end, function(value)
                        AB.config[name].columnSpacing = value
                    end, function()
                        AB:Update()
                    end)
                }
            },
            styling = {
                type = "group",
                name = L["Styling"],
                order = 4,
                inline = true,
                disabled = function()
                    return not AB.config[name].enabled or (disabledFunc and disabledFunc())
                end,
                args = {
                    fade = R:CreateToggleOption(L["Mouseover Fade"], L["Whether or not to show a backdrop behind this bar"], 1, nil, nil, function()
                        return AB.config[name].fader == R.config.faders.mouseOver
                    end, function(value)
                        AB.config[name].fader = value and R.config.faders.mouseOver or R.config.faders.onShow
                    end, function()
                        AB:Update()
                    end),
                    linebreak1 = { type = "description", name = "", order = 2 },
                    backdrop = R:CreateToggleOption(L["Show Backdrop"], L["Whether or not to show a backdrop behind this bar"], 3, nil, nil, function()
                        return AB.config[name].backdrop
                    end, function(value)
                        AB.config[name].backdrop = value
                    end, function()
                        AB:Update()
                    end),
                    border = R:CreateToggleOption(L["Show Border"], L["Whether or not to show a border around this bar"], 4, nil, nil, function()
                        return AB.config[name].border
                    end, function(value)
                        AB.config[name].border = value
                    end, function()
                        AB:Update()
                    end),
                    shadow = R:CreateToggleOption(L["Shadow"], L["Whether or not to show a shadow behind this bar"], 5, nil, nil, function()
                        return AB.config[name].shadow
                    end, function(value)
                        AB.config[name].shadow = value
                    end, function()
                        AB:Update()
                    end),
                    linebreak2 = { type = "description", name = "", order = 6 },
                    showGrid = R:CreateToggleOption(L["Show Grid"], L["Whether to show buttons when unassigned an action"], 7, nil, nil, function()
                        return AB.config[name].showGrid
                    end, function(value)
                        AB.config[name].showGrid = value
                    end, function()
                        AB:Update()
                    end)
                }
            }
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
            actionBar1 = AB:CreateActionBarOptions(1, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            actionBar2 = AB:CreateActionBarOptions(2, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            actionBar3 = AB:CreateActionBarOptions(3, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            actionBar4 = AB:CreateActionBarOptions(4, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            actionBar5 = AB:CreateActionBarOptions(5, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            actionBar6 = AB:CreateActionBarOptions(6),
            actionBar7 = AB:CreateActionBarOptions(7),
            actionBar8 = AB:CreateActionBarOptions(8),
            actionBar9 = AB:CreateActionBarOptions(9),
            actionBar10 = AB:CreateActionBarOptions(10),
            petBar = AB:CreateMiscBarOptions("petBar", L["Pet Bar"], 21, nil, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            stanceBar = AB:CreateMiscBarOptions("stanceBar", L["Stance Bar"], 22, nil, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            totemBar = AB:CreateMiscBarOptions("totemBar", L["Totem Bar"], 23, R.isRetail or R.PlayerInfo.class ~= "SHAMAN", function()
                return AB.config.actionBar1.vanillaArt.enabled
            end)
        }
    }
end)
