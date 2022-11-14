local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

R.UNIT_ANCHORS = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
R.GROUP_ANCHORS = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
R.GROUP_UNITS = {["party"] = true, ["raid"] = true, ["assist"] = true, ["tank"] = true, ["arena"] = true, ["boss"] = true}

function UF:UnitConfig(unit)
    return UF.config[unit] or UF.config.nameplates[unit]
end

function UF:UnitDefaults(unit)
    return UF.defaults[unit] or UF.defaults.nameplates[unit]
end

function UF:CreateStatusBarTextureOption(name, desc, option, order)
    return R:CreateStatusBarOption(name, desc, order, nil, function() return UF.config.statusbars[option] end, function(value) UF.config.statusbars[option] = value end, UF.UpdateAll)
end

function UF:CreateStatusBarColorOption(name, option, order)
    return R:CreateColorOption(name, nil, order, nil, false, UF.defaults.colors[option], function() return UF.config.colors[option] end, UF.UpdateAll)
end

function UF:CreateClassColorOption(class, name, order, hidden)
    return R:CreateColorOption(name, nil, order, hidden, false, UF.defaults.colors.class[class], function() return UF.config.colors.class[class] end, UF.UpdateAll)
end

function UF:CreateRangeOption(unit, name, desc, order, hidden, min, max, softMax, step, get, set)
    return R:CreateRangeOption(name, desc, order, hidden, min, max, softMax, step, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateToggleOption(unit, name, desc, order, width, hidden, get, set, confirm)
    return R:CreateToggleOption(name, desc, order, width, hidden, get, set, function() UF:UpdateUnit(unit) end, confirm)
end

function UF:CreatePointOption(unit, order, get, set)
    return R:CreateSelectOption(L["Point"], L["The anchor point on this element."], order, nil, R.ANCHOR_POINTS, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateAnchorOption(unit, order, hidden, get, set)
    return R:CreateSelectOption(L["Anchor"], L["The frame to attach to."], order, hidden, R.ANCHORS, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateRelativePointOption(unit, order, get, set)
    return R:CreateSelectOption(L["Relative Point"], L["The point on the unit frame to attach to."], order, nil, R.ANCHOR_POINTS, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateOffsetXOption(unit, order, get, set)
    return R:CreateRangeOption(L["Offset (X)"], L["The horizontal offset from the anchor point."], order, nil, -500, nil, 500, 1, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateOffsetYOption(unit, order, get, set)
    return R:CreateRangeOption(L["Offset (Y)"], L["The vertical offset from the anchor point."], order, nil, -500, nil, 500, 1, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateFontFamilyOption(unit, order, get, set) return R:CreateFontOption(L["Font Family"], L["The font family for this text."], order, nil, get, set, function() UF:UpdateUnit(unit) end) end

function UF:CreateFontSizeOption(unit, order, get, set)
    return R:CreateRangeOption(L["Font Size"], L["The size of the text."], order, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateFontOutlineOption(unit, order, get, set)
    return R:CreateSelectOption(L["Font Outline"], L["The outline style of this text."], order, nil, R.FONT_OUTLINES, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateFontShadowOption(unit, order, get, set)
    return R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for this text."], order, nil, nil, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateFontJustifyHOption(unit, order, get, set)
    return R:CreateSelectOption(L["Horizontal Justification"], L["The horizontal justification for this text."], order, nil, R.JUSTIFY_H, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateFontJustifyVOption(unit, order, get, set)
    return R:CreateSelectOption(L["Vertical Justification"], L["The vertical justification for this text."], order, nil, R.JUSTIFY_V, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateTagOption(unit, order, get, set)
    return R:CreateInputOption(L["Tag"], L["The tag determines what is displayed in the this text string."], order, nil, get, set, function() UF:UpdateUnit(unit) end)
end

function UF:CreateUnitOptions(unit, order, name, hidden, isNameplate)
    local options = {
        type = "group",
        childGroups = "tab",
        name = name,
        order = order,
        hidden = hidden,
        args = {
            header = {type = "header", name = R.title .. " > Unit Frames: " .. name, order = 0},
            enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "double", isNameplate, function() return UF:UnitConfig(unit).enabled end, function(value) UF:UnitConfig(unit).enabled = value end, ReloadUI,
                                           L["Disabling this unit requires a UI reload. Proceed?"]),
            general = {
                type = "group",
                name = L["General"],
                order = 4,
                args = {size = UF:CreateUnitSizeOption(unit, 1), position = UF:CreateUnitPositionOption(unit, 2), highlight = UF:CreateUnitHighlightOption(unit, 3)}
            },
            elements = {
                type = "group",
                name = L["Elements"],
                order = 5,
                args = {
                    health = UF:CreateUnitHealthOption(unit, 1),
                    power = UF:CreateUnitPowerOption(unit, 2),
                    castbar = UF:CreateUnitCastbarOption(unit, 3, unit == "player"),
                    portrait = UF:CreateUnitPortraitOption(unit, 4)
                }
            },
            texts = {
                type = "group",
                name = L["Texts"],
                order = 6,
                args = {
                    name = UF:CreateUnitNameOption(unit, 1),
                    health = UF:CreateUnitHealthValueOption(unit, 2),
                    healthPercent = UF:CreateUnitHealthPercentOption(unit, 3),
                    power = UF:CreateUnitPowerValueOption(unit, 4),
                    level = UF:CreateUnitLevelOption(unit, 5)
                }
            },
            indicators = {
                type = "group",
                name = L["Indicators"],
                order = 7,
                args = {
                    combatIndicator = UF:CreateUnitIndicatorOption(unit, "combatIndicator", 1, L["Combat"], unit ~= "player"),
                    restingIndicator = UF:CreateUnitIndicatorOption(unit, "restingIndicator", 2, L["Resting"], unit ~= "player"),
                    pvpIndicator = UF:CreateUnitIndicatorOption(unit, "pvpIndicator", 3, L["PvP Status"]),
                    pvpClassificationIndicator = UF:CreateUnitIndicatorOption(unit, "pvpClassificationIndicator", 4, L["PvP Classification"], not R.isRetail),
                    masterLooterIndicator = UF:CreateUnitIndicatorOption(unit, "masterLooterIndicator", 5, L["Master Looter"], R.isRetail),
                    leaderIndicator = UF:CreateUnitIndicatorOption(unit, "leaderIndicator", 6, L["Raid Leader"]),
                    assistantIndicator = UF:CreateUnitIndicatorOption(unit, "assistantIndicator", 7, L["Raid Assistant"]),
                    raidRoleIndicator = UF:CreateUnitIndicatorOption(unit, "raidRoleIndicator", 8, L["Raid Role"]),
                    groupRoleIndicator = UF:CreateUnitIndicatorOption(unit, "groupRoleIndicator", 9, L["Group Role"], not R.isRetail),
                    raidTargetIndicator = UF:CreateUnitIndicatorOption(unit, "raidTargetIndicator", 10, L["Target Icon"]),
                    readyCheckIndicator = UF:CreateUnitIndicatorOption(unit, "readyCheckIndicator", 11, L["Ready Check"]),
                    phaseIndicator = UF:CreateUnitIndicatorOption(unit, "phaseIndicator", 12, L["Phase"]),
                    resurrectIndicator = UF:CreateUnitIndicatorOption(unit, "resurrectIndicator", 13, L["Resurrect"]),
                    summonIndicator = UF:CreateUnitIndicatorOption(unit, "summonIndicator", 14, L["Summon"], not R.isRetail),
                    questIndicator = UF:CreateUnitIndicatorOption(unit, "questIndicator", 15, L["Quest"], not R.isRetail)
                }
            },
            auras = {
                type = "group",
                name = L["Auras"],
                order = 8,
                args = {
                    enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).auras.enabled end, function(value)
                        UF:UnitConfig(unit).auras.enabled = value
                    end),
                    lineBreak0 = {type = "header", name = "", order = 2},
                    separateBuffsAndDebuffs = UF:CreateToggleOption(unit, L["Separate Buffs & Debuffs"], L["Whether to show buffs & debuffs separately, or grouped together."], 3, nil, nil,
                                                                    function() return UF:UnitConfig(unit).auras.separateBuffsAndDebuffs end,
                                                                    function(value) UF:UnitConfig(unit).auras.separateBuffsAndDebuffs = value end),
                    buffsAndDebuffs = UF:CreateUnitAurasOption(unit, 4, L["Buffs & Debuffs"], "buffsAndDebuffs", function() return UF:UnitConfig(unit).auras.separateBuffsAndDebuffs end),
                    buffs = UF:CreateUnitAurasOption(unit, 5, L["Buffs"], "buffs", function() return not UF:UnitConfig(unit).auras.separateBuffsAndDebuffs end),
                    buffFilter = UF:CreateUnitAuraFilterOption(unit, 6, L["Buff Filter"], "buffs", true),
                    debuffs = UF:CreateUnitAurasOption(unit, 7, L["Debuffs"], "debuffs", function() return not UF:UnitConfig(unit).auras.separateBuffsAndDebuffs end),
                    debuffFilter = UF:CreateUnitAuraFilterOption(unit, 8, L["Debuff Filter"], "debuffs", false)
                }
            }
        }
    }

    if R.GROUP_UNITS[unit] then
        options.args.forceShow = {
            order = 2,
            type = "execute",
            name = function() return UF.headers[unit].isForced and L["Hide Frames"] or L["Show Frames"] end,
            desc = string.format(L["Forcibly show/hide the %s frames."], unit),
            func = function()
                if not UF.headers[unit].isForced then
                    UF.headers[unit]:ForceShow()
                else
                    UF.headers[unit]:UnforceShow()
                end
            end
        }

        options.args.general.args.layout = {
            type = "group",
            name = L["Layout"],
            order = 3,
            inline = true,
            args = {
                desc = {type = "description", name = L["These options control how each unit is positioned within the group."], order = 0},
                unitAnchorPoint = R:CreateSelectOption(L["Unit Anchor Point"], L["The point on each unit to attach to."], 1, nil, R.UNIT_ANCHORS, function()
                    return UF:UnitConfig(unit).unitAnchorPoint
                end, function(value) UF:UnitConfig(unit).unitAnchorPoint = value end, function() UF:UpdateUnit(unit) end),
                unitSpacing = UF:CreateRangeOption(unit, L["Unit Spacing"], L["The spacing between each unit."], 2, nil, 0, nil, 50, 1, function() return UF:UnitConfig(unit).unitSpacing end,
                                                   function(value) UF:UnitConfig(unit).unitSpacing = value end),
                lineBreak1 = {type = "description", name = "", order = 3, hidden = unit ~= "raid"},
                groupAnchorPoint = R:CreateSelectOption(L["Group Anchor Point"], L["The point on each group to attach to."], 4, unit ~= "raid", R.GROUP_ANCHORS,
                                                        function() return UF:UnitConfig(unit).groupAnchorPoint end, function(value) UF:UnitConfig(unit).groupAnchorPoint = value end,
                                                        function() UF:UpdateUnit(unit) end),
                groupSpacing = UF:CreateRangeOption(unit, L["Group Spacing"], L["The spacing between each group."], 5, unit ~= "raid", 0, nil, 50, 1,
                                                    function() return UF:UnitConfig(unit).groupSpacing end, function(value) UF:UnitConfig(unit).groupSpacing = value end),
                lineBreak2 = {type = "description", name = "", order = 10, hidden = unit ~= "party"},
                showPlayer = UF:CreateToggleOption(unit, L["Show Player"], nil, 11, nil, unit ~= "party", function() return UF:UnitConfig(unit).showPlayer end,
                                                   function(value) UF:UnitConfig(unit).showPlayer = value end),
                showRaid = UF:CreateToggleOption(unit, L["Show in Raid"], nil, 12, nil, unit ~= "party", function() return UF:UnitConfig(unit).showRaid end,
                                                 function(value) UF:UnitConfig(unit).showRaid = value end),
                showSolo = UF:CreateToggleOption(unit, L["Show when Solo"], nil, 13, nil, unit ~= "party", function() return UF:UnitConfig(unit).showSolo end,
                                                 function(value) UF:UnitConfig(unit).showSolo = value end)
            }
        }
    end

    return options
end

function UF:CreateUnitPositionOption(unit, order)
    return {
        type = "group",
        name = L["Position"],
        order = order,
        inline = true,
        args = {
            desc = {
                type = "description",
                name = L["Frame and header positions can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand."],
                order = 1
            },
            point = UF:CreatePointOption(unit, 2, function() return UF:UnitConfig(unit).point[1] end, function(value) UF:UnitConfig(unit).point[1] = value end),
            anchor = UF:CreateAnchorOption(unit, 3, nil, function() return UF:UnitConfig(unit).point[2] end, function(value) UF:UnitConfig(unit).point[2] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).point[3] end, function(value) UF:UnitConfig(unit).point[3] = value end),
            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).point[4] end, function(value) UF:UnitConfig(unit).point[4] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).point[5] end, function(value) UF:UnitConfig(unit).point[5] = value end)
        }
    }
end

function UF:CreateUnitSizeOption(unit, order)
    return {
        type = "group",
        name = L["Size"],
        order = order,
        inline = true,
        args = {
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the unit frame."], 1, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).size[1] end,
                                         function(value) UF:UnitConfig(unit).size[1] = value end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the unit frame."], 2, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).size[2] end,
                                          function(value) UF:UnitConfig(unit).size[2] = value end),
            scale = UF:CreateRangeOption(unit, L["Scale"], L["The scale of the unit frame."], 3, nil, 0.1, nil, 3, 0.1, function() return UF:UnitConfig(unit).scale end,
                                         function(value) UF:UnitConfig(unit).scale = value end)
        }
    }
end

function UF:CreateUnitHealthOption(unit, order)
    return {
        type = "group",
        name = L["Health Bar"],
        order = order,
        args = {desc = {order = 1, type = "description", name = L["NOTE: The size of the health bar for a unit always matches the frame size; to resize it, adjust the size of the frame."]}}
    }
end

function UF:CreateUnitHealthValueOption(unit, order)
    return {
        type = "group",
        name = L["Health"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).health.value.enabled end,
                                            function(value) UF:UnitConfig(unit).health.value.enabled = value end),
            lineBreakPoint = {type = "header", name = L["Position"], order = 2},
            point = UF:CreatePointOption(unit, 3, function() return UF:UnitConfig(unit).health.value.point[1] end, function(value) UF:UnitConfig(unit).health.value.point[1] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).health.value.point[2] end, function(value) UF:UnitConfig(unit).health.value.point[2] = value end),
            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).health.value.point[3] end, function(value) UF:UnitConfig(unit).health.value.point[3] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).health.value.point[4] end, function(value) UF:UnitConfig(unit).health.value.point[4] = value end),
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = UF:CreateFontFamilyOption(unit, 21, function() return UF:UnitConfig(unit).health.value.font end, function(value) UF:UnitConfig(unit).health.value.font = value end),
            fontSize = UF:CreateFontSizeOption(unit, 22, function() return UF:UnitConfig(unit).health.value.fontSize end, function(value) UF:UnitConfig(unit).health.value.fontSize = value end),
            fontOutline = UF:CreateFontOutlineOption(unit, 23, function() return UF:UnitConfig(unit).health.value.fontOutline end, function(value)
                UF:UnitConfig(unit).health.value.fontOutline = value
            end),
            fontShadow = UF:CreateFontShadowOption(unit, 24, function() return UF:UnitConfig(unit).health.value.fontShadow end, function(value) UF:UnitConfig(unit).health.value.fontShadow = value end),
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = UF:CreateTagOption(unit, 31, function() return UF:UnitConfig(unit).health.value.tag end, function(value) UF:UnitConfig(unit).health.value.tag = value end)
        }
    }
end

function UF:CreateUnitHealthPercentOption(unit, order)
    return {
        type = "group",
        name = L["Health (Percentage)"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).health.percent.enabled end,
                                            function(value) UF:UnitConfig(unit).health.percent.enabled = value end),
            lineBreakPoint = {type = "header", name = L["Position"], order = 2},
            point = UF:CreatePointOption(unit, 3, function() return UF:UnitConfig(unit).health.percent.point[1] end, function(value) UF:UnitConfig(unit).health.percent.point[1] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).health.percent.point[2] end, function(value)
                UF:UnitConfig(unit).health.percent.point[2] = value
            end),
            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).health.percent.point[3] end, function(value) UF:UnitConfig(unit).health.percent.point[3] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).health.percent.point[4] end, function(value) UF:UnitConfig(unit).health.percent.point[4] = value end),
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = UF:CreateFontFamilyOption(unit, 21, function() return UF:UnitConfig(unit).health.percent.font end, function(value) UF:UnitConfig(unit).health.percent.font = value end),
            fontSize = UF:CreateFontSizeOption(unit, 22, function() return UF:UnitConfig(unit).health.percent.fontSize end, function(value) UF:UnitConfig(unit).health.percent.fontSize = value end),
            fontOutline = UF:CreateFontOutlineOption(unit, 23, function() return UF:UnitConfig(unit).health.percent.fontOutline end, function(value)
                UF:UnitConfig(unit).health.percent.fontOutline = value
            end),
            fontShadow = UF:CreateFontShadowOption(unit, 24, function() return UF:UnitConfig(unit).health.percent.fontShadow end, function(value)
                UF:UnitConfig(unit).health.percent.fontShadow = value
            end),
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = UF:CreateTagOption(unit, 31, function() return UF:UnitConfig(unit).health.percent.tag end, function(value) UF:UnitConfig(unit).health.percent.tag = value end)
        }
    }
end

function UF:CreateUnitPowerOption(unit, order)
    return {
        type = "group",
        name = L["Power Bar"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).power.enabled end, function(value) UF:UnitConfig(unit).power.enabled = value end),
            lineBreakLayout = {type = "description", name = "", order = 2},
            layout = {
                type = "group",
                name = L["Layout"],
                order = 3,
                inline = true,
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the power bar."], 1, nil, 0, nil, 500, 1, function() return UF:UnitConfig(unit).power.size[1] end,
                                                 function(value) UF:UnitConfig(unit).power.size[1] = value end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the power bar."], 2, nil, 0, nil, 100, 1, function() return UF:UnitConfig(unit).power.size[2] end,
                                                  function(value) UF:UnitConfig(unit).power.size[2] = value end),
                    lineBreakSize = {type = "description", name = "", order = 3},
                    showSeparator = UF:CreateToggleOption(unit, L["Show Separator"], L["Whether the power bar has a separator between it and the health bar."], 4, nil, nil,
                                                          function() return UF:UnitConfig(unit).power.showSeparator end, function(value) UF:UnitConfig(unit).power.showSeparator = value end),
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the power bar is detached from the health bar."], 5, nil, unit ~= "player",
                                                     function() return UF:UnitConfig(unit).power.detached end, function(value)
                        UF:UnitConfig(unit).power.inset = false;
                        UF:UnitConfig(unit).power.detached = value
                    end),
                    inset = UF:CreateToggleOption(unit, L["Inset"], L["Whether the power bar is displayed as an inset."], 6, nil, nil, function() return UF:UnitConfig(unit).power.inset end,
                                                  function(value)
                        UF:UnitConfig(unit).power.detached = false;
                        UF:UnitConfig(unit).power.inset = value
                    end),
                    detachedPoint = {
                        type = "group",
                        name = L["Detached Point"],
                        order = 7,
                        inline = true,
                        hidden = function() return unit ~= "player" or not UF:UnitConfig(unit).power.detached end,
                        args = {
                            desc = {
                                type = "description",
                                name = L["Detached power bar position can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand."],
                                order = 1
                            },
                            point = UF:CreatePointOption(unit, 2, function() return UF:UnitConfig(unit).power.point[1] end, function(value)
                                UF:UnitConfig(unit).power.point[1] = value
                            end),
                            anchor = UF:CreateAnchorOption(unit, 3, nil, function() return UF:UnitConfig(unit).power.point[2] end, function(value)
                                UF:UnitConfig(unit).power.point[2] = value
                            end),
                            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).power.point[3] end, function(value)
                                UF:UnitConfig(unit).power.point[3] = value
                            end),
                            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).power.point[4] end, function(value)
                                UF:UnitConfig(unit).power.point[4] = value
                            end),
                            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).power.point[5] end, function(value)
                                UF:UnitConfig(unit).power.point[5] = value
                            end)
                        }
                    },
                    insetPoint = {
                        type = "group",
                        name = L["Inset Point"],
                        order = 8,
                        inline = true,
                        hidden = function() return not UF:UnitConfig(unit).power.inset end,
                        args = {
                            point = UF:CreatePointOption(unit, 3, function() return UF:UnitConfig(unit).power.insetPoint[1] end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[1] = value
                            end),
                            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).power.insetPoint[2] end,
                                                                         function(value) UF:UnitConfig(unit).power.insetPoint[2] = value end),
                            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).power.insetPoint[3] end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[3] = value
                            end),
                            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).power.insetPoint[4] end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[4] = value
                            end)
                        }
                    }
                }
            },
            lineBreak2 = {type = "description", name = "", order = 7},
            powerPrediction = UF:CreateToggleOption(unit, L["Power Prediction"], L["Whether power prediction is enabled for the player's power bar."], 8, nil, unit ~= "player",
                                                    function() return UF:UnitConfig(unit).power.powerPrediction end, function(value) UF:UnitConfig(unit).power.powerPrediction = value end),
            energyManaRegen = UF:CreateToggleOption(unit, L["Energy/Mana Regen Tick"], nil, 9, nil, R.isRetail or unit ~= "player", function() return UF:UnitConfig(unit).power.energyManaRegen end,
                                                    function(value) UF:UnitConfig(unit).power.energyManaRegen = value end)
        }
    }
end

function UF:CreateUnitPowerValueOption(unit, order)
    return {
        type = "group",
        name = "Power",
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).power.value.enabled end,
                                            function(value) UF:UnitConfig(unit).power.value.enabled = value end),
            lineBreakPoint = {type = "header", name = L["Position"], order = 2},
            point = UF:CreatePointOption(unit, 3, function() return UF:UnitConfig(unit).power.value.point[1] end, function(value) UF:UnitConfig(unit).power.value.point[1] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 4, function() return UF:UnitConfig(unit).power.value.point[2] end, function(value) UF:UnitConfig(unit).power.value.point[2] = value end),
            offsetX = UF:CreateOffsetXOption(unit, 5, function() return UF:UnitConfig(unit).power.value.point[3] end, function(value) UF:UnitConfig(unit).power.value.point[3] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 6, function() return UF:UnitConfig(unit).power.value.point[4] end, function(value) UF:UnitConfig(unit).power.value.point[4] = value end),
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = UF:CreateFontFamilyOption(unit, 21, function() return UF:UnitConfig(unit).power.value.font end, function(value) UF:UnitConfig(unit).power.value.font = value end),
            fontSize = UF:CreateFontSizeOption(unit, 22, function() return UF:UnitConfig(unit).power.value.fontSize end, function(value) UF:UnitConfig(unit).power.value.fontSize = value end),
            fontOutline = UF:CreateFontOutlineOption(unit, 23, function() return UF:UnitConfig(unit).power.value.fontOutline end, function(value) UF:UnitConfig(unit).power.value.fontOutline = value end),
            fontShadow = UF:CreateFontShadowOption(unit, 24, function() return UF:UnitConfig(unit).power.value.fontShadow end, function(value) UF:UnitConfig(unit).power.value.fontShadow = value end),
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = UF:CreateTagOption(unit, 31, function() return UF:UnitConfig(unit).power.value.tag end, function(value) UF:UnitConfig(unit).power.value.tag = value end)
        }
    }
end

function UF:CreateUnitNameOption(unit, order)
    return {
        type = "group",
        name = L["Name"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).name.enabled end, function(value) UF:UnitConfig(unit).name.enabled = value end),
            lineBreakSize = {type = "header", name = "Size", order = 2},
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the name text."], 3, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).name.size[1] end,
                                         function(value) UF:UnitConfig(unit).name.size[1] = value end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the name text."], 4, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).name.size[2] end,
                                          function(value) UF:UnitConfig(unit).name.size[2] = value end),
            lineBreakPoint = {type = "header", name = L["Position"], order = 5},
            point = UF:CreatePointOption(unit, 6, function() return UF:UnitConfig(unit).name.point[1] end, function(value) UF:UnitConfig(unit).name.point[1] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 7, function() return UF:UnitConfig(unit).name.point[2] end, function(value) UF:UnitConfig(unit).name.point[2] = value end),
            offsetX = UF:CreateOffsetXOption(unit, 8, function() return UF:UnitConfig(unit).name.point[3] end, function(value) UF:UnitConfig(unit).name.point[3] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 9, function() return UF:UnitConfig(unit).name.point[4] end, function(value) UF:UnitConfig(unit).name.point[4] = value end),
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = UF:CreateFontFamilyOption(unit, 21, function() return UF:UnitConfig(unit).name.font end, function(value) UF:UnitConfig(unit).name.font = value end),
            fontSize = UF:CreateFontSizeOption(unit, 22, function() return UF:UnitConfig(unit).name.fontSize end, function(value) UF:UnitConfig(unit).name.fontSize = value end),
            fontOutline = UF:CreateFontOutlineOption(unit, 23, function() return UF:UnitConfig(unit).name.fontOutline end, function(value) UF:UnitConfig(unit).name.fontOutline = value end),
            fontShadow = UF:CreateFontShadowOption(unit, 24, function() return UF:UnitConfig(unit).name.fontShadow end, function(value) UF:UnitConfig(unit).name.fontShadow = value end),
            justifyH = UF:CreateFontJustifyHOption(unit, 25, function() return UF:UnitConfig(unit).name.justifyH end, function(value) UF:UnitConfig(unit).name.justifyH = value end),
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = UF:CreateTagOption(unit, 31, function() return UF:UnitConfig(unit).name.tag end, function(value) UF:UnitConfig(unit).name.tag = value end)
        }
    }
end

function UF:CreateUnitLevelOption(unit, order)
    return {
        type = "group",
        name = L["Level"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).level.enabled end, function(value) UF:UnitConfig(unit).level.enabled = value end),
            lineBreakSize = {type = "header", name = "Size", order = 2},
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the name text."], 3, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).level.size[1] end,
                                         function(value) UF:UnitConfig(unit).level.size[1] = value end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the name text."], 4, nil, 10, nil, 400, 1, function() return UF:UnitConfig(unit).level.size[2] end,
                                          function(value) UF:UnitConfig(unit).level.size[2] = value end),
            lineBreakPoint = {type = "header", name = L["Position"], order = 5},
            point = UF:CreatePointOption(unit, 6, function() return UF:UnitConfig(unit).level.point[1] end, function(value) UF:UnitConfig(unit).level.point[1] = value end),
            relativePoint = UF:CreateRelativePointOption(unit, 7, function() return UF:UnitConfig(unit).level.point[2] end, function(value) UF:UnitConfig(unit).level.point[2] = value end),
            offsetX = UF:CreateOffsetXOption(unit, 8, function() return UF:UnitConfig(unit).level.point[3] end, function(value) UF:UnitConfig(unit).level.point[3] = value end),
            offsetY = UF:CreateOffsetYOption(unit, 9, function() return UF:UnitConfig(unit).level.point[4] end, function(value) UF:UnitConfig(unit).level.point[4] = value end),
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = UF:CreateFontFamilyOption(unit, 21, function() return UF:UnitConfig(unit).level.font end, function(value) UF:UnitConfig(unit).level.font = value end),
            fontSize = UF:CreateFontSizeOption(unit, 22, function() return UF:UnitConfig(unit).level.fontSize end, function(value) UF:UnitConfig(unit).level.fontSize = value end),
            fontOutline = UF:CreateFontOutlineOption(unit, 23, function() return UF:UnitConfig(unit).level.fontOutline end, function(value) UF:UnitConfig(unit).level.fontOutline = value end),
            fontShadow = UF:CreateFontShadowOption(unit, 24, function() return UF:UnitConfig(unit).level.fontShadow end, function(value) UF:UnitConfig(unit).level.fontShadow = value end),
            justifyH = UF:CreateFontJustifyHOption(unit, 25, function() return UF:UnitConfig(unit).level.justifyH end, function(value) UF:UnitConfig(unit).level.justifyH = value end),
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = UF:CreateTagOption(unit, 31, function() return UF:UnitConfig(unit).level.tag end, function(value) UF:UnitConfig(unit).level.tag = value end)
        }
    }
end

function UF:CreateUnitPortraitOption(unit, order)
    return {
        type = "group",
        name = L["Portrait"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).portrait.enabled end, function(value)
                UF:UnitConfig(unit).portrait.enabled = value
            end),
            lineBreakOptions = {type = "description", name = "", order = 2},
            class = UF:CreateToggleOption(unit, L["Use Class Icons"], L["Whether to use class icons for the portrait texture."], 4, nil, nil, function()
                return UF:UnitConfig(unit).portrait.class
            end, function(value)
                UF:UnitConfig(unit).portrait.model = false;
                UF:UnitConfig(unit).portrait.class = value
            end),
            model = UF:CreateToggleOption(unit, L["Use 3D Portrait"], L["Whether to use class 3D portraits."], 5, nil, nil, function() return UF:UnitConfig(unit).portrait.model end, function(value)
                UF:UnitConfig(unit).portrait.class = false;
                UF:UnitConfig(unit).portrait.model = value
            end),
            lineBreakDetached = {type = "description", name = "", order = 6},
            detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the portrait is detached from the health bar."], 7, nil, nil, function()
                return UF:UnitConfig(unit).portrait.detached
            end, function(value) UF:UnitConfig(unit).portrait.detached = value end),
            showSeparator = UF:CreateToggleOption(unit, L["Show Separator"], L["Whether the portrait has a separator between it and the health bar."], 8, nil, nil,
                                                  function() return UF:UnitConfig(unit).portrait.showSeparator end, function(value) UF:UnitConfig(unit).portrait.showSeparator = value end),
            lineBreakSize = {type = "description", name = L["Size"], order = 10},
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the portrait."], 11, nil, 0, nil, 500, 1, function() return UF:UnitConfig(unit).portrait.size[1] end,
                                         function(value) UF:UnitConfig(unit).portrait.size[1] = value end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the portrait."], 12, nil, 0, nil, 100, 1, function() return UF:UnitConfig(unit).portrait.size[2] end,
                                          function(value) UF:UnitConfig(unit).portrait.size[2] = value end),
            detachedPosition = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 13,
                hidden = function() return not UF:UnitConfig(unit).portrait.detached end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function() return UF:UnitConfig(unit).portrait.point[1] end, function(value) UF:UnitConfig(unit).portrait.point[1] = value end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function() return UF:UnitConfig(unit).portrait.point[2] end, function(value)
                        UF:UnitConfig(unit).portrait.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function() return UF:UnitConfig(unit).portrait.point[3] end, function(value) UF:UnitConfig(unit).portrait.point[3] = value end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function() return UF:UnitConfig(unit).portrait.point[4] end, function(value) UF:UnitConfig(unit).portrait.point[4] = value end)
                }
            }
        }
    }
end

function UF:CreateUnitCastbarOption(unit, order, canDetach)
    return {
        type = "group",
        name = L["Castbar"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).castbar.enabled end, function(value)
                UF:UnitConfig(unit).castbar.enabled = value
            end),
            lineBreakOptions = {type = "description", name = "", order = 2},
            showIcon = UF:CreateToggleOption(unit, L["Show Icon"], L["Whether to show an icon in the castbar."], 3, nil, not canDetach, function() return UF:UnitConfig(unit).castbar.showIcon end,
                                             function(value) UF:UnitConfig(unit).castbar.showIcon = value end),
            showIconOutside = UF:CreateToggleOption(unit, L["Show Icon Outside"], L["Whether to show the icon outside the castbar."], 4, nil,
                                                    function() return not canDetach or not UF:UnitConfig(unit).castbar.showIcon end, function() return UF:UnitConfig(unit).castbar.showIconOutside end,
                                                    function(value) UF:UnitConfig(unit).castbar.showIconOutside = value end),
            showSafeZone = UF:CreateToggleOption(unit, L["Show Latency"], L["Whether to show a latency indicator."], 5, nil, unit ~= "player",
                                                 function() return UF:UnitConfig(unit).castbar.showSafeZone end, function(value) UF:UnitConfig(unit).castbar.showSafeZone = value end),
            showSpark = UF:CreateToggleOption(unit, L["Show Spark"], L["Whether to show the spark at the end of the castbar."], 6, nil, nil, function()
                return UF:UnitConfig(unit).castbar.showSpark
            end, function(value) UF:UnitConfig(unit).castbar.showSpark = value end),
            lineBreakDetached = {type = "description", name = "", order = 7},
            detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the castbar is detached from the unit frame."], 8, nil, not canDetach,
                                             function() return UF:UnitConfig(unit).castbar.detached end, function(value)
                UF:UnitConfig(unit).castbar.detached = value;
                UF:UnitConfig(unit).castbar.point = value and {"CENTER", "UIParent", "BOTTOM", 0, 150} or {"TOPLEFT", "BOTTOMLEFT", 0, -5}
            end),
            lineBreakSize = {type = "description", name = L["Size"], order = 9},
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the castbar."], 10, not canDetach, 10, nil, 400, 1, function() return UF:UnitConfig(unit).castbar.size[1] end,
                                         function(value) UF:UnitConfig(unit).castbar.size[1] = value end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the castbar."], 11, nil, 4, nil, 400, 1, function() return UF:UnitConfig(unit).castbar.size[2] end,
                                          function(value) UF:UnitConfig(unit).castbar.size[2] = value end),
            position = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 12,
                args = {
                    point = UF:CreatePointOption(unit, 1, function() return UF:UnitConfig(unit).castbar.point[1] end, function(value) UF:UnitConfig(unit).castbar.point[1] = value end),
                    anchor = UF:CreateAnchorOption(unit, 2, function() return not UF:UnitConfig(unit).castbar.detached end, function() return UF:UnitConfig(unit).castbar.point[2] end,
                                                   function(value) UF:UnitConfig(unit).castbar.point[2] = value end),
                    relativePoint = UF:CreateRelativePointOption(unit, 3, function() return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 2 or 3] end,
                                                                 function(value) UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 2 or 3] = value end),
                    offsetX = UF:CreateOffsetXOption(unit, 4, function() return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 3 or 4] end,
                                                     function(value) UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 3 or 4] = value end),
                    offsetY = UF:CreateOffsetYOption(unit, 5, function() return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 4 or 5] end,
                                                     function(value) UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 4 or 5] = value end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                inline = true,
                order = 13,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function() return UF:UnitConfig(unit).castbar.font end, function(value) UF:UnitConfig(unit).castbar.font = value end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function() return UF:UnitConfig(unit).castbar.fontSize end, function(value) UF:UnitConfig(unit).castbar.fontSize = value end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function() return UF:UnitConfig(unit).castbar.fontOutline end, function(value)
                        UF:UnitConfig(unit).castbar.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function() return UF:UnitConfig(unit).castbar.fontShadow end, function(value)
                        UF:UnitConfig(unit).castbar.fontShadow = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitIndicatorOption(unit, indicatorName, order, title, hidden)
    return {
        type = "group",
        name = title,
        order = order,
        hidden = hidden,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit)[indicatorName].enabled end,
                                            function(value) UF:UnitConfig(unit)[indicatorName].enabled = value end),
            position = {
                type = "group",
                name = L["Position"],
                order = order,
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function() return UF:UnitConfig(unit)[indicatorName].point[1] end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function() return UF:UnitConfig(unit)[indicatorName].point[2] end,
                                                                 function(value) UF:UnitConfig(unit)[indicatorName].point[2] = value end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function() return UF:UnitConfig(unit)[indicatorName].point[3] end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function() return UF:UnitConfig(unit)[indicatorName].point[4] end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[4] = value
                    end)
                }
            },
            size = {
                type = "group",
                name = L["Size"],
                order = order,
                inline = true,
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the indicator."], 10, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit)[indicatorName].size[1]
                    end, function(value) UF:UnitConfig(unit)[indicatorName].size[1] = value end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the indicator."], 11, nil, 4, nil, 400, 1, function()
                        return UF:UnitConfig(unit)[indicatorName].size[2]
                    end, function(value) UF:UnitConfig(unit)[indicatorName].size[2] = value end)
                }
            }
        }
    }
end

function UF:CreateUnitAurasOption(unit, order, name, setting, hidden)
    return {
        type = "group",
        name = name,
        order = order,
        inline = true,
        hidden = hidden,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).auras[setting].enabled end,
                                            function(value) UF:UnitConfig(unit).auras[setting].enabled = value end),
            lineBreak0 = {type = "description", name = "", order = 2},
            iconSize = UF:CreateRangeOption(unit, L["Icon Size"], L["The size of the aura icons."], 3, nil, 10, nil, 50, 1, function() return UF:UnitConfig(unit).auras[setting].iconSize end,
                                            function(value) UF:UnitConfig(unit).auras[setting].iconSize = value end),
            spacing = UF:CreateRangeOption(unit, L["Spacing"], L["The spacing between aura icons."], 4, nil, -10, nil, 30, 1, function() return UF:UnitConfig(unit).auras[setting].spacing end,
                                           function(value) UF:UnitConfig(unit).auras[setting].spacing = value end),
            numColumns = UF:CreateRangeOption(unit, L["Number of Columns"], L["The number of columns."], 5, nil, 1, nil, 32, 1, function() return UF:UnitConfig(unit).auras[setting].numColumns end,
                                              function(value) UF:UnitConfig(unit).auras[setting].numColumns = value end),
            num = UF:CreateRangeOption(unit, L["Number of " .. name], L["The number of auras to show."], 6, setting == "buffsAndDebuffs", 1, nil, 32, 1,
                                       function() return UF:UnitConfig(unit).auras[setting].num end, function(value) UF:UnitConfig(unit).auras[setting].num = value end),
            numBuffs = UF:CreateRangeOption(unit, L["Number of Buffs"], L["The number of buffs to show."], 7, setting ~= "buffsAndDebuffs", 1, nil, 32, 1,
                                            function() return UF:UnitConfig(unit).auras[setting].numBuffs end, function(value) UF:UnitConfig(unit).auras[setting].numBuffs = value end),
            numDebuffs = UF:CreateRangeOption(unit, L["Number of Debuffs"], L["The number of debuffs to show."], 8, setting ~= "buffsAndDebuffs", 1, nil, 32, 1,
                                              function() return UF:UnitConfig(unit).auras[setting].numDebuffs end, function(value) UF:UnitConfig(unit).auras[setting].numDebuffs = value end),
            lineBreak1 = {type = "description", name = "", order = 10},
            showDuration = UF:CreateToggleOption(unit, L["Show Duration"], nil, 11, nil, nil, function() return UF:UnitConfig(unit).auras[setting].showDuration end,
                                                 function(value) UF:UnitConfig(unit).auras[setting].showDuration = value end),
            position = {
                type = "group",
                name = L["Position"],
                order = 13,
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function() return UF:UnitConfig(unit).auras[setting].point[1] end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function() return UF:UnitConfig(unit).auras[setting].point[2] end,
                                                                 function(value) UF:UnitConfig(unit).auras[setting].point[2] = value end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function() return UF:UnitConfig(unit).auras[setting].point[3] end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function() return UF:UnitConfig(unit).auras[setting].point[4] end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[4] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitAuraFilterOption(unit, order, name, setting, isBuff)
    return {
        type = "group",
        name = name or L["Filter"],
        order = order,
        inline = true,
        args = {
            minDuration = UF:CreateRangeOption(unit, L["Minimum Duration"], L["The minimum duration an aura needs to have to be shown. Set to 0 to disable."], 1, nil, 0, nil, 120, 1,
                                               function() return UF:UnitConfig(unit).auras[setting].minDuration end, function(value) UF:UnitConfig(unit).auras[setting].minDuration = value end),
            maxDuration = UF:CreateRangeOption(unit, L["Maximum Duration"], L["The maximum duration an aura is allowed to have to be shown. Set to 0 to disable."], 2, nil, 0, nil, 600, 1,
                                               function() return UF:UnitConfig(unit).auras[setting].maxDuration end, function(value) UF:UnitConfig(unit).auras[setting].maxDuration = value end),
            whitelist = {
                type = "group",
                name = L["Whitelist"],
                order = 3,
                inline = true,
                args = {
                    boss = UF:CreateToggleOption(unit, L["Boss"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.Boss end,
                                                 function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.Boss = value end),
                    myPet = UF:CreateToggleOption(unit, L["MyPet"], nil, 2, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.MyPet end,
                                                  function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.MyPet = value end),
                    otherPet = UF:CreateToggleOption(unit, L["OtherPet"], nil, 3, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.OtherPet end,
                                                     function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.OtherPet = value end),
                    personal = UF:CreateToggleOption(unit, L["Personal"], nil, 4, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.Personal end,
                                                     function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.Personal = value end),
                    nonPersonal = UF:CreateToggleOption(unit, L["NonPersonal"], nil, 5, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.NonPersonal end,
                                                        function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.NonPersonal = value end),
                    castByUnit = UF:CreateToggleOption(unit, L["CastByUnit"], nil, 6, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByUnit end,
                                                       function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByUnit = value end),
                    notCastByUnit = UF:CreateToggleOption(unit, L["NotCastByUnit"], nil, 7, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.NotCastByUnit end,
                                                          function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.NotCastByUnit = value end),
                    castByNPC = UF:CreateToggleOption(unit, L["CastByNPC"], nil, 8, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByNPC end,
                                                      function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByNPC = value end),
                    castByPlayers = UF:CreateToggleOption(unit, L["CastByPlayers"], nil, 9, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByPlayers end,
                                                          function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByPlayers = value end),
                    dispellable = UF:CreateToggleOption(unit, L["Dispellable"], nil, 10, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.Dispellable end,
                                                        function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.Dispellable = value end),
                    notDispellable = UF:CreateToggleOption(unit, L["NotDispellable"], nil, 11, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.NotDispellable
                    end, function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.NotDispellable = value end),
                    nameplate = UF:CreateToggleOption(unit, L["Nameplate"], nil, 12, nil, nil, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.Nameplate end,
                                                      function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.Nameplate = value end),
                    lineBreak = {type = "header", name = "", order = 13},
                    crowdControl = UF:CreateToggleOption(unit, L["Crowd Control"], nil, 15, nil, isBuff, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.CrowdControl end,
                                                         function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.CrowdControl = value end),
                    playerBuffs = UF:CreateToggleOption(unit, L["Player Buffs"], nil, 16, nil, not isBuff, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs end,
                                                        function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs = value end),
                    turtleBuffs = UF:CreateToggleOption(unit, L["Turtle Buffs"], nil, 17, nil, not isBuff, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.TurtleBuffs end,
                                                        function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.TurtleBuffs = value end),
                    raidBuffs = UF:CreateToggleOption(unit, L["Raid Buffs"], nil, 18, nil, not isBuff, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.RaidBuffs end,
                                                      function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.RaidBuffs = value end),
                    raidDebuffs = UF:CreateToggleOption(unit, L["Raid Debuffs"], nil, 19, nil, isBuff, function() return UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs end,
                                                        function(value) UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs = value end)
                }
            },
            blacklist = {
                type = "group",
                name = L["Blacklist"],
                order = 4,
                inline = true,
                args = {
                    blockNonPersonal = UF:CreateToggleOption(unit, L["BlockNonPersonal"], nil, 1, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNonPersonal
                    end, function(value) UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNonPersonal = value end),
                    blockCastByPlayers = UF:CreateToggleOption(unit, L["BlockCastByPlayers"], nil, 2, nil, nil,
                                                               function() return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockCastByPlayers end,
                                                               function(value) UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockCastByPlayers = value end),
                    blockNoDuration = UF:CreateToggleOption(unit, L["BlockNoDuration"], nil, 3, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNoDuration
                    end, function(value) UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNoDuration = value end),
                    blockDispellable = UF:CreateToggleOption(unit, L["BlockDispellable"], nil, 4, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockDispellable
                    end, function(value) UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockDispellable = value end),
                    blockNotDispellable = UF:CreateToggleOption(unit, L["BlockNotDispellable"], nil, 5, nil, nil,
                                                                function() return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNotDispellable end,
                                                                function(value) UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNotDispellable = value end)
                }
            }
        }
    }
end

function UF:CreateUnitHighlightOption(unit, order)
    local highlight = {
        type = "group",
        name = L["Highlighting"],
        order = order,
        inline = true,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function() return UF:UnitConfig(unit).highlight.enabled end, function(value)
                UF:UnitConfig(unit).highlight.enabled = value
            end),
            lineBreak1 = {type = "description", name = "", order = 2},
            colorBorder = UF:CreateToggleOption(unit, L["Color Border"], L["Whether to color unit frame borders when highlighting."], 3, nil, nil,
                                                function() return UF:UnitConfig(unit).highlight.colorBorder end, function(value) UF:UnitConfig(unit).highlight.colorBorder = value end),
            colorShadow = UF:CreateToggleOption(unit, L["Color Shadows"], L["Whether to color unit frame shadows when highlighting."], 4, nil, nil,
                                                function() return UF:UnitConfig(unit).highlight.colorShadow end, function(value) UF:UnitConfig(unit).highlight.colorShadow = value end),
            lineBreak2 = {type = "description", name = "", order = 5},
            debuffs = UF:CreateToggleOption(unit, L["Highlight Based On Debuff"], L["Whether to color unit frames based on debuff type."], 3, nil, nil,
                                            function() return UF:UnitConfig(unit).highlight.debuffs end, function(value) UF:UnitConfig(unit).highlight.debuffs = value end),
            onlyDispellableDebuffs = UF:CreateToggleOption(unit, L["Only Highlight Dispellable Debuffs"], L["Whether only highlight unit frames when player can dispel the debuff."], 3, nil, nil,
                                                           function() return UF:UnitConfig(unit).highlight.onlyDispellableDebuffs end,
                                                           function(value) UF:UnitConfig(unit).highlight.onlyDispellableDebuffs = value end),
            lineBreak3 = {type = "description", name = "", order = 8},
            threat = UF:CreateToggleOption(unit, L["Highlight Based On Threat"], L["Whether to color unit frames based on threat situation."], 9, nil, nil,
                                           function() return UF:UnitConfig(unit).highlight.threat end, function(value) UF:UnitConfig(unit).highlight.threat = value end),
            target = UF:CreateToggleOption(unit, L["Highlight Target"], L["Whether to color unit frames when targeted."], 10, nil, nil, function() return UF:UnitConfig(unit).highlight.target end,
                                           function(value) UF:UnitConfig(unit).highlight.target = value end)
        }
    }

    if UF:UnitDefaults(unit).highlight.targetArrows ~= nil then
        highlight.args.targetArrows = UF:CreateToggleOption(unit, L["Highlight Target"], L["Whether to color unit frames when targeted."], 10, nil, nil,
                                                            function() return UF:UnitConfig(unit).highlight.targetArrows end, function(value) UF:UnitConfig(unit).highlight.targetArrows = value end)
    end

    return highlight
end

R:RegisterModuleOptions(UF, {
    type = "group",
    name = L["Unit Frames"],
    childGroups = "tree",
    args = {
        header = {type = "header", name = R.title .. " > Unit Frames", order = 0},
        enabled = R:CreateModuleEnabledOption(1, nil, "UnitFrames"),
        lineBreak1 = {type = "header", name = "", order = 2},
        fonts = {
            type = "group",
            name = L["Fonts"],
            order = 5,
            inline = true,
            args = {
                font = R:CreateFontOption(L["Default Font Family"], L["The default font family for unit frame texts."], 1, nil, function() return UF.config.font end,
                                          function(value) UF.config.font = value end, UF.UpdateAll)
            }
        },
        statusbarTextures = {
            type = "group",
            name = L["Status Bar Textures"],
            order = 6,
            inline = true,
            args = {
                health = UF:CreateStatusBarTextureOption(L["Health"], L["Set the texture to use for health bars."], "health", 1),
                healthPrediction = UF:CreateStatusBarTextureOption(L["Health Prediction (Healing)"], L["Set the texture to use for health prediction bars."], "healthPrediction", 2),
                power = UF:CreateStatusBarTextureOption(L["Power"], L["Set the texture to use for power bars."], "power", 3),
                powerPrediction = UF:CreateStatusBarTextureOption(L["Power Prediction (Power Cost)"], L["Set the texture to use for power prediction bars."], "powerPrediction", 4),
                additionalPower = UF:CreateStatusBarTextureOption(L["Additional Power"], L["Set the texture to use for power bars."], "additionalPower", 5),
                additionalPowerPrediction = UF:CreateStatusBarTextureOption(L["Additional Power Prediction (Power Cost)"], L["Set the texture to use for additional power prediction bars."],
                                                                            "additionalPowerPrediction", 6),
                classPower = UF:CreateStatusBarTextureOption(L["Class Power"], L["Set the texture to use for class power bars (combo points etc)."], "classPower", 7),
                castbar = UF:CreateStatusBarTextureOption(L["Cast Bars"], L["Set the texture to use for cast bars."], "castbar", 8)
            }
        },
        statusBarColors = {
            type = "group",
            name = L["Status Bar Colors"],
            order = 7,
            inline = true,
            args = {
                health = UF:CreateStatusBarColorOption(L["Health"], "health", 1),
                mana = UF:CreateStatusBarColorOption(L["Mana"], "mana", 2),
                rage = UF:CreateStatusBarColorOption(L["Rage"], "rage", 3),
                energy = UF:CreateStatusBarColorOption(L["Energy"], "energy", 4),
                focus = UF:CreateStatusBarColorOption(L["Focus"], "focus", 5),
                comboPoints = UF:CreateStatusBarColorOption(L["Combo Points"], "comboPoints", 6),
                runicPower = UF:CreateStatusBarColorOption(L["Runic Power"], "runicPower", 7),
                castbar = UF:CreateStatusBarColorOption(L["Castbar"], "castbar", 8),
                castbar_Shielded = UF:CreateStatusBarColorOption(L["Castbar (Shielded)"], "castbar_Shielded", 9),
                lineBreak1 = {type = "header", name = "", order = 20},
                colorHealthClass = R:CreateToggleOption(L["Color Health by Class"], nil, 21, nil, nil, function() return UF.config.colors.colorHealthClass end,
                                                        function(val) UF.config.colors.colorHealthClass = val end, UF.UpdateAll),
                colorHealthSmooth = R:CreateToggleOption(L["Color Health by Value"], nil, 22, nil, nil, function() return UF.config.colors.colorHealthSmooth end,
                                                         function(val) UF.config.colors.colorHealthSmooth = val end, UF.UpdateAll),
                colorHealthDisconnected = R:CreateToggleOption(L["Color Health when Disconnected"], nil, 23, nil, nil, function() return UF.config.colors.colorHealthDisconnected end,
                                                               function(val) UF.config.colors.colorHealthDisconnected = val end, UF.UpdateAll),
                colorPowerClass = R:CreateToggleOption(L["Color Power by Class"], nil, 24, nil, nil, function() return UF.config.colors.colorPowerClass end,
                                                       function(val) UF.config.colors.colorPowerClass = val end, UF.UpdateAll),
                colorPowerSmooth = R:CreateToggleOption(L["Color Power by Value"], nil, 25, nil, nil, function() return UF.config.colors.colorPowerSmooth end,
                                                        function(val) UF.config.colors.colorPowerSmooth = val end, UF.UpdateAll),
                colorPowerDisconnected = R:CreateToggleOption(L["Color Power when Disconnected"], nil, 26, nil, nil, function() return UF.config.colors.colorPowerDisconnected end,
                                                              function(val) UF.config.colors.colorPowerDisconnected = val end, UF.UpdateAll)
            }
        },
        classcolors = {
            type = "group",
            name = L["Class Colors"],
            order = 8,
            inline = true,
            args = {
                deathKnight = UF:CreateClassColorOption("DEATHKNIGHT", R:LocalizedClassName("Death Knight"), 10),
                demonHunter = UF:CreateClassColorOption("DEMONHUNTER", R:LocalizedClassName("Demon Hunter"), 11, not R.isRetail),
                druid = UF:CreateClassColorOption("DRUID", R:LocalizedClassName("Druid"), 12),
                hunter = UF:CreateClassColorOption("HUNTER", R:LocalizedClassName("Hunter"), 13),
                mage = UF:CreateClassColorOption("MAGE", R:LocalizedClassName("Mage"), 14),
                monk = UF:CreateClassColorOption("MONK", R:LocalizedClassName("Monk"), 15, not R.isRetail),
                paladin = UF:CreateClassColorOption("PALADIN", R:LocalizedClassName("Paladin"), 16),
                priest = UF:CreateClassColorOption("PRIEST", R:LocalizedClassName("Priest"), 17),
                rogue = UF:CreateClassColorOption("ROGUE", R:LocalizedClassName("Rogue"), 18),
                shaman = UF:CreateClassColorOption("SHAMAN", R:LocalizedClassName("Shaman"), 19),
                warlock = UF:CreateClassColorOption("WARLOCK", R:LocalizedClassName("Warlock"), 20),
                warrior = UF:CreateClassColorOption("WARRIOR", R:LocalizedClassName("Warrior"), 21)
            }
        },
        player = UF:CreateUnitOptions("player", 11, L["Player"]),
        target = UF:CreateUnitOptions("target", 12, L["Target"]),
        targettarget = UF:CreateUnitOptions("targettarget", 13, L["Target's Target"]),
        pet = UF:CreateUnitOptions("pet", 14, L["Pet"]),
        focus = UF:CreateUnitOptions("focus", 15, L["Focus"]),
        focustarget = UF:CreateUnitOptions("focustarget", 16, L["Focus's Target"]),
        party = UF:CreateUnitOptions("party", 17, L["Party"]),
        raid = UF:CreateUnitOptions("raid", 18, L["Raid"]),
        tank = UF:CreateUnitOptions("tank", 19, L["Tank"]),
        assist = UF:CreateUnitOptions("assist", 19, L["Assist"]),
        boss = UF:CreateUnitOptions("boss", 20, L["Boss"], not R.isRetail),
        arena = UF:CreateUnitOptions("arena", 21, L["Arena"]),
        nameplates = {
            type = "group",
            name = L["Nameplates"],
            order = 22,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames : Nameplates", order = 0},
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "double", nil, function() return UF:UnitConfig("nameplates").enabled end, function(value) UF:UnitConfig("nameplates").enabled = value end, ReloadUI,
                                               L["Disabling nameplates requires a UI reload. Proceed?"]),
                description = {type = "description", name = L["To configure nameplates, select friendly/enemy player/NPC from the tree on the left."], order = 2},     
                friendlyPlayer = UF:CreateUnitOptions("friendlyPlayer", 3, L["Friendly Player Nameplates"], nil, true),
                enemyPlayer = UF:CreateUnitOptions("enemyPlayer", 4, L["Enemy Player Nameplates"], nil, true),
                friendlyNpc = UF:CreateUnitOptions("friendlyNpc", 5, L["Friendly NPC Nameplates"], nil, true),
                enemyNpc = UF:CreateUnitOptions("enemyNpc", 6, L["Enemy NPC Nameplates"], nil, true)
            }
        }
    }
})
