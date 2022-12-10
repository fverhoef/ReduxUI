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
                name = string.format(L["%sNOTE:|r When using Vanilla style main action bars, some options are disabled."], R:Hex(1, 0, 0)),
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
                    enableModernArt = R:CreateToggleOption(L["Enable Modern Art"],
                                                           L["Whether or not the Modern Blizzard artwork for the main action bar (Gryphons/Wyverns, depending on faction) is shown."], 1, "full", nil,
                                                           function()
                        return AB.config.actionBar1.modernArt.enabled
                    end, function(value)
                        AB.config.actionBar1.modernArt.enabled = value
                        if value then
                            AB.config.actionBar1.vanillaArt.enabled = false
                        end
                    end, AB.Update),
                    enableVanillaArt = R:CreateToggleOption(L["Enable Vanilla Art"], string.format(
                                                                L["Whether or not the Vanilla Blizzard artwork for the main action bar is shown.\n\n%sNOTE:|r When using this option, you will not be able to adjust button layout and styling for the action bars 1-5."],
                                                                R:Hex(1, 0, 0)), 2, "full", nil, function()
                        return AB.config.actionBar1.vanillaArt.enabled
                    end, function(value)
                        AB.config.actionBar1.vanillaArt.enabled = value
                        if value then
                            AB.config.actionBar1.modernArt.enabled = false
                        end
                    end, AB.Update),
                    stackBottomBars = R:CreateToggleOption(L["Stack Bottom Bars"], nil, 3, nil, function()
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
                        return AB.config["actionBar" .. id].buttonStyle.size
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.size = value
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
                    end),
                    linebreak4 = { type = "description", name = "", order = 12 },
                    flyoutDirection = R:CreateSelectOption(L["Flyout Direction"], L["The direction in which flyout buttons expand"], 13, nil, AB.FLYOUT_DIRECTIONS, function()
                        return AB.config["actionBar" .. id].buttonStyle.flyoutDirection
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.flyoutDirection = value
                    end, function()
                        AB:Update()
                    end)
                }
            },
            barStyling = {
                type = "group",
                name = L["Bar Styling"],
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
                    showGrid = R:CreateToggleOption(L["Show Empty Buttons"], L["Whether to show buttons when unassigned an action"], 10, nil, nil, function()
                        return AB.config["actionBar" .. id].showGrid
                    end, function(value)
                        AB.config["actionBar" .. id].showGrid = value
                    end, function()
                        AB:Update()
                    end)
                }
            },
            buttonStyling = {
                type = "group",
                name = L["Button Styling"],
                order = 6,
                inline = true,
                disabled = function()
                    return not AB.config["actionBar" .. id].enabled or (disabledFunc and disabledFunc())
                end,
                args = {
                    clickOnDown = R:CreateToggleOption(L["Click on Down"], L["Whether or not to execute this button on mouse button down, rather than up"], 1, nil, nil, function()
                        return AB.config["actionBar" .. id].buttonStyle.clickOnDown
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.clickOnDown = value
                    end, function()
                        AB:Update()
                    end),
                    checkSelfCast = R:CreateToggleOption(L["Check Self-Cast"], L["Whether or not to check for self cast modifiers when executing this button's action"], 2, nil, nil, function()
                        return AB.config["actionBar" .. id].buttonStyle.checkSelfCast
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.checkSelfCast = value
                    end, function()
                        AB:Update()
                    end),
                    checkFocusCast = R:CreateToggleOption(L["Check Focus-Cast"], L["Whether or not to check for focus cast modifiers when executing this button's action"], 3, nil, nil, function()
                        return AB.config["actionBar" .. id].buttonStyle.checkFocusCast
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.checkFocusCast = value
                    end, function()
                        AB:Update()
                    end),
                    checkMouseoverCast = R:CreateToggleOption(L["Check Mouseover-Cast"], L["Whether or not to check for mousever cast modifiers when executing this button's action"], 4, nil, nil,
                                                              function()
                        return AB.config["actionBar" .. id].buttonStyle.checkMouseoverCast
                    end, function(value)
                        AB.config["actionBar" .. id].buttonStyle.checkMouseoverCast = value
                    end, function()
                        AB:Update()
                    end),
                    keybindText = {
                        type = "group",
                        name = L["Keybinding Text"],
                        order = 5,
                        inline = true,
                        args = {
                            hideKeybindText = R:CreateToggleOption(L["Hide Keybind Text"], L["Whether or not to show the keybinding for this button"], 0, nil, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.hideKeybindText
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.hideKeybindText = value
                            end, function()
                                AB:Update()
                            end),
                            linebreak1 = { type = "description", name = "", order = 1 },
                            font = R:CreateFontOption(L["Font"], L["The font to use for keybinding texts."], 2, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.keybindFont
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.keybindFont = value
                            end, function()
                                AB:Update()
                            end),
                            size = R:CreateRangeOption(L["Font Size"], L["The size of keybinding text."], 3, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                return AB.config["actionBar" .. id].buttonStyle.keybindFontSize
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.keybindFontSize = value
                            end, function()
                                AB:Update()
                            end),
                            outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of keybinding text."], 4, nil, R.FONT_OUTLINES, function()
                                return AB.config["actionBar" .. id].buttonStyle.keybindFontOutline
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.keybindFontOutline = value
                            end, function()
                                AB:Update()
                            end),
                            shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for keybinding text."], 5, nil, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.keybindFontShadow
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.keybindFontShadow = value
                            end, function()
                                AB:Update()
                            end)
                        }
                    },
                    countText = {
                        type = "group",
                        name = L["Count Text"],
                        order = 6,
                        inline = true,
                        args = {
                            font = R:CreateFontOption(L["Font"], L["The font to use for count text."], 1, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.countFont
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.countFont = value
                            end, function()
                                AB:Update()
                            end),
                            size = R:CreateRangeOption(L["Font Size"], L["The size of count text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                return AB.config["actionBar" .. id].buttonStyle.countFontSize
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.countFontSize = value
                            end, function()
                                AB:Update()
                            end),
                            outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of count text."], 3, nil, R.FONT_OUTLINES, function()
                                return AB.config["actionBar" .. id].buttonStyle.countFontOutline
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.countFontOutline = value
                            end, function()
                                AB:Update()
                            end),
                            shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for count text."], 4, nil, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.countFontShadow
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.countFontShadow = value
                            end, function()
                                AB:Update()
                            end)
                        }
                    },
                    macroText = {
                        type = "group",
                        name = L["Macro Text"],
                        order = 7,
                        inline = true,
                        args = {
                            hideMacroText = R:CreateToggleOption(L["Hide Macro Text"], L["Whether or not to show the macro name for this button"], 0, nil, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.hideMacroText
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.hideMacroText = value
                            end, function()
                                AB:Update()
                            end),
                            linebreak1 = { type = "description", name = "", order = 1 },
                            font = R:CreateFontOption(L["Font"], L["The font to use for macro text."], 2, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.macroFont
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.macroFont = value
                            end, function()
                                AB:Update()
                            end),
                            size = R:CreateRangeOption(L["Font Size"], L["The size of macro text."], 3, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                return AB.config["actionBar" .. id].buttonStyle.macroFontSize
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.macroFontSize = value
                            end, function()
                                AB:Update()
                            end),
                            outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of macro text."], 4, nil, R.FONT_OUTLINES, function()
                                return AB.config["actionBar" .. id].buttonStyle.macroFontOutline
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.macroFontOutline = value
                            end, function()
                                AB:Update()
                            end),
                            shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for macro text."], 5, nil, nil, function()
                                return AB.config["actionBar" .. id].buttonStyle.macroFontShadow
                            end, function(value)
                                AB.config["actionBar" .. id].buttonStyle.macroFontShadow = value
                            end, function()
                                AB:Update()
                            end)
                        }
                    }
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
                name = string.format(L["%sNOTE:|r When using Vanilla style main action bars, some options are disabled."], R:Hex(1, 0, 0)),
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
                        return AB.config[name].buttonStyle.size
                    end, function(value)
                        AB.config[name].buttonSize = value
                    end, function()
                        AB:Update()
                    end),
                    columnSpacing = R:CreateRangeOption(L["Button Spacing"], L["The spacing between each button."], 2, AB.config[name].columnSpacing == nil, 1, 12, nil, 1, function()
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
                name = L["Bar Styling"],
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
                    showGrid = R:CreateToggleOption(L["Show Empty Buttons"], L["Whether to show buttons when unassigned an action"], 7, nil, nil, function()
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

function AB:CreateTrackingBarOptions(name, title, order, disabledFunc)
    return {
        type = "group",
        name = title,
        order = order,
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
                name = string.format(L["%sNOTE:|r When using Vanilla style main action bars, some options are disabled."], R:Hex(1, 0, 0)),
                order = 2,
                hidden = function()
                    return not AB.config[name].enabled or not (disabledFunc and disabledFunc())
                end
            },
            size = {
                type = "group",
                name = L["Size"],
                order = 3,
                inline = true,
                disabled = function()
                    return not AB.config[name].enabled or (disabledFunc and disabledFunc())
                end,
                args = {
                    width = R:CreateRangeOption(L["Width"], L["The width of this bar."], 1, nil, 100, 800, nil, 1, function()
                        return AB.config[name].size[1]
                    end, function(value)
                        AB.config[name].size[1] = value
                    end, function()
                        AB:Update()
                    end),
                    height = R:CreateRangeOption(L["Height"], L["The height of this bar."], 1, nil, 10, 50, nil, 1, function()
                        return AB.config[name].size[2]
                    end, function(value)
                        AB.config[name].size[2] = value
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
            description = { type = "description", name = L["To configure individual action bars, select it from the tree on the left."], order = 2 },
            lineBreak = { type = "header", name = "", order = 3 },
            toggleKeybindMode = {
                order = 4,
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
            end),
            vehicleExitBar = AB:CreateMiscBarOptions("vehicleExitBar", L["Vehicle Exit Bar"], 24, nil, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            experienceBar = AB:CreateTrackingBarOptions("experienceBar", L["Experience Bar"], 25, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end),
            statusTrackingBar = AB:CreateTrackingBarOptions("statusTrackingBar", L["Reputation/Tracking Bar"], 26, function()
                return AB.config.actionBar1.vanillaArt.enabled
            end)
        }
    }
end)
