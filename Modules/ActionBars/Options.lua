local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local CLASS_RESTRICTIONS = {[""] = L["None"]}
local NEW_BAR = L["New Bar"]

for key, value in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do CLASS_RESTRICTIONS[key] = value end

local selectedSpells = {}
local addSpellFilter

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

function AB:CreateCooldownBarsOptions(order)
    local options = {type = "group", name = L["Cooldown Bars"], order = order, childGroups = "tab", args = {}}

    for name, config in pairs(AB.config.cooldownBars) do
        options.args[name] = {
            type = "group",
            name = name,
            hidden = function() return config.tbc and R.isRetail end,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "full", nil, function() return config.enabled end, function(value) config.enabled = value end,
                                               function() AB.cooldownBars[name]:Configure() end),
                lineBreak = {type = "header", name = "", order = 3},
                showLabels = R:CreateToggleOption(L["Show Labels"], nil, 4, "full", nil, function() return config.showLabels end, function(value) config.showLabels = value end,
                                                  function() AB.cooldownBars[name]:Configure() end),
                backdrop = R:CreateToggleOption(L["Show Backdrop"], nil, 5, "full", nil, function() return config.backdrop end, function(value) config.backdrop = value end,
                                                function() AB.cooldownBars[name]:Configure() end),
                border = R:CreateToggleOption(L["Show Border"], nil, 6, "full", nil, function() return config.border end, function(value) config.border = value end,
                                              function() AB.cooldownBars[name]:Configure() end),
                shadow = R:CreateToggleOption(L["Show Shadow"], nil, 7, "full", nil, function() return config.shadow end, function(value) config.shadow = value end,
                                              function() AB.cooldownBars[name]:Configure() end),
                lineBreak2 = {type = "description", name = "", order = 8},
                width = R:CreateRangeOption(L["Width"], nil, 9, nil, 1, nil, 1000, 1, function() return config.size[1] end, function(value) config.size[1] = value end,
                                            function() AB.cooldownBars[name]:Configure() end),
                height = R:CreateRangeOption(L["Height"], nil, 10, nil, 1, nil, 200, 1, function() return config.size[2] end, function(value) config.size[2] = value end,
                                             function() AB.cooldownBars[name]:Configure() end),
                iconSize = R:CreateRangeOption(L["Icon Size"], nil, 11, nil, 1, nil, 120, 1, function() return config.iconSize end, function(value) config.iconSize = value end,
                                               function() AB.cooldownBars[name]:Configure() end)
            }
        }
    end

    return options
end

local function BarIsForCurrentClass(config) return config.class ~= nil and config.class ~= "" and config.class ~= R.PlayerInfo.class end

local function GetActionName(action)
    local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(action)
    local subText = GetSpellSubtext(spellId or action)
    if subText and subText ~= "" then name = name .. " (" .. subText .. ")" end
    return icon and string.format("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 40, name) or name
end

local function GetKnownActions(button)
    local actions = {}
    for _, action in ipairs(button.actions) do if IsSpellKnown(action) and (not button.showOnlyMaxRank or R:IsMaxKnownRank(action)) then table.insert(actions, GetActionName(action)) end end
    return actions
end

local function GetDefaultActionIndex(button)
    local currentIndex = 1
    for _, action in ipairs(button.actions) do
        if IsSpellKnown(action) and (not button.showOnlyMaxRank or R:IsMaxKnownRank(action)) then
            if action == button.defaultAction then
                return currentIndex
            else
                currentIndex = currentIndex + 1
            end
        end
    end
end

local function GetKnownAction(button, index)
    local currentIndex = 1
    for _, action in ipairs(button.actions) do
        if IsSpellKnown(action) and (not button.showOnlyMaxRank or R:IsMaxKnownRank(action)) then
            if currentIndex == index then
                return action
            else
                currentIndex = currentIndex + 1
            end
        end
    end
end

function AB:CreateFlyoutButtonOptions(group, barConfig, barName)
    for i, button in ipairs(barConfig.buttons) do
        local buttonName = L["Button"] .. " " .. i
        local buttonTitle = buttonName .. ((button.name and (" (" .. button.name .. ")")) or "")
        if button.custom then buttonTitle = "|cff00FF00" .. buttonTitle .. "|r" end

        group.args[buttonName] = {
            order = 52 + i,
            type = "group",
            name = buttonTitle,
            args = {
                header = {type = "header", order = 0, name = buttonTitle},
                enabled = {
                    order = 2,
                    type = "toggle",
                    name = L["Enabled"],
                    desc = L["Whether or not this button is enabled."],
                    get = function(info) return button.enabled end,
                    set = function(info, value)
                        button.enabled = value
                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                name = {
                    order = 10,
                    type = "input",
                    name = L["Name"],
                    desc = L["The name of the button."],
                    width = "full",
                    get = function(info) return button.name end,
                    set = function(info, value)
                        button.name = value
                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                showOnlyMaxRank = {
                    order = 11,
                    type = "toggle",
                    name = L["Show Only Max Rank"],
                    desc = L["Whether this button will only show the max rank of each spell."],
                    width = "full",
                    get = function(info) return button.showOnlyMaxRank end,
                    set = function(info, value)
                        button.showOnlyMaxRank = value
                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                actions = {
                    order = 20,
                    type = "multiselect",
                    width = 1.75,
                    name = L["Actions"],
                    tristate = false,
                    values = function()
                        local actions = {}
                        for i, action in ipairs(button.actions) do actions[i] = GetActionName(action) end
                        return actions
                    end,
                    get = function(info, key) for i, action in ipairs(button.actions) do if i == key then return selectedSpells[action] end end end,
                    set = function(info, key) for i, action in ipairs(button.actions) do if i == key then selectedSpells[action] = not selectedSpells[action] end end end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                removeAction = {
                    order = 21,
                    type = "execute",
                    name = L["Remove Selected Spell(s)"],
                    func = function()
                        for selectedSpell, _ in pairs(selectedSpells) do
                            for i, action in ipairs(button.actions) do
                                if selectedSpell == action then
                                    table.remove(button.actions, i)
                                    break
                                end
                            end
                        end
                        selectedSpells = {}

                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                addSpellBreak = {order = 22, type = "description", name = ""},
                findSpellName = {
                    order = 23,
                    type = "input",
                    name = L["Filter"],
                    desc = L["Name or ID of the spell to add."],
                    get = function(info)
                        R.Libs.SpellCache:BuildKnownSpellCache()
                        return addSpellFilter
                    end,
                    set = function(info, value)
                        addSpellFilter = R.Libs.SpellCache:MatchSpellName(value, true)
                        spellToAdd = nil
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                findSpellResults = {
                    order = 24,
                    type = "select",
                    name = L["Select Spell"],
                    values = function()
                        local spells = {}
                        if addSpellFilter then
                            local ids = R.Libs.SpellCache:GetKnownSpells(addSpellFilter)
                            for _, id in ipairs(ids) do if IsSpellKnown(id) then spells[id] = GetActionName(id) end end
                        end
                        return spells
                    end,
                    get = function(info, key) return spellToAdd end,
                    set = function(info, key) spellToAdd = key end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                addSpell = {
                    order = 25,
                    type = "execute",
                    name = L["Add Selected Spell"],
                    disabled = function() return not spellToAdd end,
                    func = function()
                        if not spellToAdd then return end

                        for i, action in ipairs(button.actions) do if action == spellToAdd then return end end

                        table.insert(button.actions, spellToAdd)

                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                defaultAction = {
                    order = 26,
                    type = "select",
                    name = L["Default Action"],
                    desc = L["The default action to show when the button is collapsed."],
                    values = function() return GetKnownActions(button) end,
                    get = function(info) return GetDefaultActionIndex(button) end,
                    set = function(info, index)
                        button.defaultAction = GetKnownAction(button, index)
                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                defaultActionUpdateMode = {
                    order = 27,
                    type = "select",
                    name = L["Default Action Update Mode"],
                    desc = L["When and how to update the default action for this button."],
                    values = AB.UPDATE_DEFAULT_MODE,
                    get = function() for key, value in pairs(AB.UPDATE_DEFAULT_MODE) do if value == (button.defaultActionUpdateMode or "") then return key end end end,
                    set = function(_, key)
                        local value = AB.UPDATE_DEFAULT_MODE[key]
                        if value == "" then value = nil end
                        button.defaultActionUpdateMode = value
                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return BarIsForCurrentClass(barConfig) end
                },
                defaultActionMaxRankDescription = {
                    type = "description",
                    order = 28,
                    name = L["|cffFF0000Warning:|r The 'Show Only Max Rank' option is currently enabled; you can only set the default action to the max rank of each spell."],
                    hidden = function() return not button.showOnlyMaxRank end
                },
                deleteHeader = {type = "header", order = 50, name = ""},
                delete = {
                    order = 51,
                    type = "execute",
                    name = L["Delete Button"],
                    func = function()
                        table.remove(barConfig.buttons, i)
                        group.args[buttonName] = nil
                        R.Libs.AceConfigDialog:SelectGroup(R.name, "ActionBars", "flyoutBars", barName, "Button 1")

                        AB:UpdateFlyoutBars()
                    end,
                    disabled = function() return not button.custom end
                }
            }
        }
    end
end

function AB:CreateFlyoutBarOptions(config, name, order)
    local barOptions = {
        order = order or #(AB.options.args.flyoutBars.args),
        type = "group",
        name = config.custom and ("|cff00FF00" .. ((name == NEW_BAR and ("+ " .. name)) or name) .. "|r") or name,
        args = {
            enabled = {
                order = 1,
                type = "toggle",
                name = L["Enabled"],
                desc = L["Whether or not this bar is enabled."],
                get = function(info) return config.enabled end,
                set = function(info, value)
                    config.enabled = value
                    AB:UpdateFlyoutBars()
                end
            },
            header = {type = "header", order = 2, name = ""},
            name = {
                order = 3,
                type = "input",
                name = L["Name"],
                desc = L["Enter the name of the new bar."],
                get = function(info) return config.name end,
                set = function(info, value) config.name = value end,
                disabled = function() return name ~= NEW_BAR end,
                hidden = function() return not config.custom end
            },
            nameBreak = {type = "description", order = 4, name = ""},
            addBar = {
                order = 5,
                type = "execute",
                name = L["Add Bar"],
                desc = L["Add a new bar with the name entered above."],
                func = function()
                    AB.config.flyoutBars[config.name] = config
                    AB.options.args.flyoutBars.args[config.name] = AB:CreateFlyoutBarOptions(config, config.name)
                    R.Libs.AceConfigDialog:SelectGroup(R.name, "ActionBars", "flyoutBars", config.name)

                    AB:UpdateFlyoutBars()
                end,
                disabled = function() return (config.name or "") == "" or config.name == NEW_BAR end,
                hidden = function() return not config.custom end
            },
            deleteBar = {
                order = 6,
                type = "execute",
                name = L["Delete Bar"],
                desc = L["Delete the current bar."],
                func = function()
                    AB.config.flyoutBars[name] = nil
                    AB.options.args.flyoutBars.args[name] = nil
                    R.Libs.AceConfigDialog:SelectGroup(R.name, "ActionBars", "flyoutBars", "Mage Bar")

                    AB:UpdateFlyoutBars()
                end,
                disabled = function() return name == NEW_BAR end,
                hidden = function() return not config.custom end
            },
            header2 = {type = "header", order = 7, name = "", hidden = function() return not config.custom end},
            class = {
                order = 10,
                type = "select",
                name = L["Class Restriction"],
                desc = L["This bar will only show for the selected class. Set to 'None' if it should always be shown."],
                values = CLASS_RESTRICTIONS,
                get = function() for key, val in pairs(CLASS_RESTRICTIONS) do if (config.class or "") == key then return key end end end,
                set = function(_, key)
                    if key == "" then key = nil end
                    config.class = key
                    AB:UpdateFlyoutBars()
                end
            },
            sizeSpacer = {type = "description", order = 20, name = ""},
            buttonSize = {
                order = 21,
                type = "range",
                name = L["Button Size"],
                desc = L["The size of the action buttons."],
                min = 15,
                max = 60,
                step = 1,
                get = function(info) return config.buttonSize end,
                set = function(info, value)
                    config.buttonSize = value
                    AB:UpdateFlyoutBars()
                end
            },
            buttonSpacing = {
                order = 22,
                type = "range",
                name = L["Button Spacing"],
                desc = L["The spacing between buttons."],
                min = -3,
                max = 20,
                step = 1,
                get = function(info) return config.buttonSpacing end,
                set = function(info, value)
                    config.buttonSpacing = value
                    AB:UpdateFlyoutBars()
                end
            },
            backdropSpacer = {type = "description", order = 30, name = ""},
            backdrop = {
                order = 31,
                type = "toggle",
                name = L["Backdrop"],
                desc = L["Whether or not this bar's backdrop is enabled."],
                get = function(info) return config.backdrop end,
                set = function(info, value)
                    config.backdrop = value
                    AB:UpdateFlyoutBars()
                end
            },
            backdropSpacing = {
                order = 32,
                type = "range",
                name = L["Backdrop Spacing"],
                desc = L["The spacing between the backdrop and the buttons."],
                min = 0,
                max = 10,
                step = 1,
                get = function(info) return config.backdropSpacing end,
                set = function(info, value)
                    config.backdropSpacing = value
                    AB:UpdateFlyoutBars()
                end
            },
            fadeSpacer = {type = "description", order = 40, name = ""},
            inheritGlobalFade = {
                order = 41,
                type = "toggle",
                name = L["Inherit Global Fade"],
                desc = L["Whether this bar should inherit the global ElvUI fade state."],
                get = function(info) return config.inheritGlobalFade end,
                set = function(info, value)
                    config.inheritGlobalFade = value
                    AB:UpdateFlyoutBars()
                end
            },
            buttonsHeader = {type = "header", order = 50, name = L["Buttons"]},
            disabledDescription = {
                type = "description",
                order = 51,
                name = L["|cffFF0000Warning:|r You can only edit the buttons of bars for your own class, or of bars with no class restriction."],
                hidden = function() return not BarIsForCurrentClass(config) end
            }
        }
    }

    barOptions.args.addButton = {
        order = 52,
        type = "execute",
        name = L["Add New Button"],
        func = function()
            table.insert(config.buttons, {enabled = true, showOnlyMaxRank = false, name = L["New Button"], actions = {}, defaultActionUpdateMode = AB.UPDATE_DEFAULT_MODE.ANY_CLICK, custom = true})

            AB:CreateFlyoutButtonOptions(barOptions, config, name)
            R.Libs.AceConfigDialog:SelectGroup(R.name, "ActionBars", "flyoutBars", name, "Button " .. #config.buttons)

            AB:UpdateFlyoutBars()
        end,
        disabled = function() return BarIsForCurrentClass(config) end
    }

    AB:CreateFlyoutButtonOptions(barOptions, config, name)

    return barOptions
end

function AB:CreateFlyoutBarsOptions(order)
    local options = {type = "group", name = L["Flyout Bars"], order = order, childGroups = "tab", args = {}}

    local order = 10
    for name, config in pairs(AB.config.flyoutBars) do
        options.args[name] = AB:CreateFlyoutBarOptions(config, name, order)
        order = order + 1
    end

    options.args[NEW_BAR] = AB:CreateFlyoutBarOptions({
        enabled = true,
        point = {"CENTER"},
        custom = true,
        name = NEW_BAR,
        buttonSize = 32,
        buttonSpacing = 2,
        mouseover = true,
        inheritGlobalFade = false,
        backdrop = false,
        backdropSpacing = 2,
        direction = "UP",
        buttons = {}
    }, NEW_BAR, order)

    return options
end

R:RegisterModuleOptions(AB, function()
    return {
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
            actionBar10 = AB:CreateActionBarOptions(10),
            cooldownBars = AB:CreateCooldownBarsOptions(30),
            flyoutBars = AB:CreateFlyoutBarsOptions(31)
        }
    }
end)
