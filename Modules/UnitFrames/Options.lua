local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

R.ANCHOR_POINTS = {"TOPLEFT", "TOP", "TOPRIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT", "CENTER"}
R.ANCHORS = {
    ["UIParent"] = "UIParent",
    ["Player"] = addonName .. "Player",
    ["Target"] = addonName .. "Target",
    ["Pet"] = addonName .. "Pet"
}
R.UNIT_ANCHORS = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
R.GROUP_ANCHORS = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
R.GROUP_UNITS = {["party"] = true, ["raid"] = true, ["assist"] = true, ["tank"] = true, ["arena"] = true, ["boss"] = true}
R.JUSTIFY_H = {["LEFT"] = "LEFT", ["CENTER"] = "CENTER", ["RIGHT"] = "RIGHT"}
R.JUSTIFY_V = {["TOP"] = "TOP", ["CENTER"] = "CENTER", ["BOTTOM"] = "BOTTOM"}
R.FONT_OUTLINES = {["NONE"] = "NONE", ["OUTLINE"] = "OUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}
R.FONT_MIN_SIZE = 4
R.FONT_MAX_SIZE = 30

function UF:CreateStatusBarTextureOption(name, desc, option, order)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        dialogControl = "LSM30_Statusbar",
        values = R.Libs.SharedMedia:HashTable("statusbar"),
        get = function()
            for key, texture in pairs(R.Libs.SharedMedia:HashTable("statusbar")) do if UF.config.statusbars[option] == texture then return key end end
        end,
        set = function(_, key)
            UF.config.statusbars[option] = R.Libs.SharedMedia:Fetch("statusbar", key)
            UF:UpdateAll()
        end
    }
end

function UF:CreateStatusBarColorOption(name, option, order)
    return {
        type = "color",
        name = name,
        order = order,
        hasAlpha = false,
        get = function()
            local color = UF.config.colors[option]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = UF.config.colors[option]
            color[1] = r
            color[2] = g
            color[3] = b
            UF:UpdateAll()
        end
    }
end

function UF:CreateClassColorOption(class, name, order, hidden)
    return {
        type = "color",
        name = name,
        order = order,
        hidden = hidden,
        hasAlpha = false,
        get = function()
            local color = UF.config.colors.class[class]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = UF.config.colors.class[class]
            color[1] = r
            color[2] = g
            color[3] = b
            UF:UpdateAll()
        end
    }
end

function UF:CreateUnitOptions(unit, order, inline, name, hidden)
    local defaults = UF.defaults[unit]
    local options = {
        type = "group",
        childGroups = "tab",
        name = name or unit,
        order = order,
        inline = inline,
        hidden = hidden,
        args = {
            header = {type = "header", name = R.title .. " > Unit Frames: " .. name, order = 0},
            enabled = UF:CreateUnitEnabledOption(unit, 1, "double"),
            general = {
                type = "group",
                name = L["General"],
                order = 4,
                args = {
                    size = UF:CreateUnitSizeOption(unit, 1, true),
                    position = UF:CreateUnitPositionOption(unit, 2, true),
                    highlight = UF:CreateUnitHighlightOption(unit, 3, true)
                }
            },
            elements = {
                type = "group",
                name = L["Elements"],
                order = 5,
                args = {
                    health = UF:CreateUnitHealthOption(unit, 1),
                    power = UF:CreateUnitPowerOption(unit, 2),
                    castbar = UF:CreateUnitCastbarOption(unit, 3, false, unit == "player"),
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
            indicators = UF:CreateUnitIndicatorsOption(unit, 16),
            auras = UF:CreateUnitAurasOptions(unit, 17)
        }
    }

    if R.GROUP_UNITS[unit] then
        options.args.forceShow = {
            order = 2,
            type = "execute",
            name = function()
                return UF.headers[unit].isForced and L["Hide Frames"] or L["Show Frames"]
            end,
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
                desc = {
                    type = "description",
                    name = L["These options control how each unit is positioned within the group."],
                    order = 0
                },
                unitAnchorPoint = {
                    type = "select",
                    name = L["Unit Anchor Point"],
                    order = 1,
                    values = R.UNIT_ANCHORS,
                    get = function()
                        for key, anchor in ipairs(R.UNIT_ANCHORS) do
                            if UF.config[unit].unitAnchorPoint == anchor then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config[unit].unitAnchorPoint = R.UNIT_ANCHORS[key]
                        UF:UpdateUnit(unit)
                    end
                },
                unitSpacing = {
                    type = "range",
                    name = L["Unit Spacing"],
                    order = 2,
                    min = 0,
                    softMax = 50,
                    step = 1,
                    get = function()
                        return UF.config[unit].unitSpacing
                    end,
                    set = function(_, val)
                        UF.config[unit].unitSpacing = val
                        UF:UpdateUnit(unit)
                    end
                },
                lineBreak1 = {type = "description", name = "", order = 3},
                groupAnchorPoint = {
                    type = "select",
                    name = L["Group Anchor Point"],
                    order = 4,
                    hidden = unit ~= "raid",
                    values = R.GROUP_ANCHORS,
                    get = function()
                        for key, anchor in ipairs(R.GROUP_ANCHORS) do
                            if UF.config[unit].groupAnchorPoint == anchor then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config[unit].groupAnchorPoint = R.GROUP_ANCHORS[key]
                        UF:UpdateUnit(unit)
                    end
                },
                groupSpacing = {
                    type = "range",
                    name = L["Group Spacing"],
                    order = 5,
                    hidden = unit ~= "raid",
                    min = 0,
                    softMax = 50,
                    step = 1,
                    get = function()
                        return UF.config[unit].groupSpacing
                    end,
                    set = function(_, val)
                        UF.config[unit].groupSpacing = val
                        UF:UpdateUnit("raid")
                    end
                },
                lineBreak2 = {type = "description", name = "", order = 10},
                showPlayer = {
                    type = "toggle",
                    name = L["Show Player"],
                    order = 11,
                    hidden = unit ~= "party",
                    get = function()
                        return UF.config[unit].showPlayer
                    end,
                    set = function(_, val)
                        UF.config[unit].showPlayer = val
                        UF:UpdateUnit(unit)
                    end
                },
                showRaid = {
                    type = "toggle",
                    name = L["Show in Raid"],
                    order = 12,
                    hidden = unit ~= "party",
                    get = function()
                        return UF.config[unit].showRaid
                    end,
                    set = function(_, val)
                        UF.config[unit].showRaid = val
                        UF:UpdateUnit(unit)
                    end
                },
                showSolo = {
                    type = "toggle",
                    name = L["Show when Solo"],
                    order = 13,
                    hidden = unit ~= "party",
                    get = function()
                        return UF.config[unit].showSolo
                    end,
                    set = function(_, val)
                        UF.config[unit].showSolo = val
                        UF:UpdateUnit(unit)
                    end
                }
            }
        }
    end

    return options
end

function UF:CreateUnitEnabledOption(unit, order, width)
    return {
        type = "toggle",
        name = L["Enabled"],
        order = order,
        width = width,
        confirm = L["Disabling this unit requires a UI reload. Proceed?"],
        get = function()
            return UF.config[unit].enabled
        end,
        set = function(_, val)
            UF.config[unit].enabled = val
            ReloadUI()
        end
    }
end

function UF:CreateUnitPositionOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Position"],
        order = order,
        inline = inline,
        args = {
            desc = {
                type = "description",
                name = L["Frame and header positions can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand."],
                order = 1
            },
            point = {
                type = "select",
                name = "Point",
                desc = L["The point on the frame to attach to the anchor."],
                order = 11,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            anchor = {
                type = "select",
                name = "Anchor",
                desc = L["The frame to attach to."],
                order = 12,
                values = R.ANCHORS,
                hidden = true,
                get = function()
                    for key, value in ipairs(R.ANCHORS) do
                        if value == UF.config[unit].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[2] = R.ANCHORS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = L["Relative Point"],
                desc = L["The point on the anchor frame to attach to."],
                order = 13,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].point[3] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[3] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = L["Offset (X)"],
                desc = L["The horizontal offset from the anchor point."],
                order = 14,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].point[4]
                end,
                set = function(_, val)
                    UF.config[unit].point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = L["Offset (Y)"],
                desc = L["The vertical offset from the anchor point."],
                order = 15,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].point[5]
                end,
                set = function(_, val)
                    UF.config[unit].point[5] = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitSizeOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Size"],
        order = order,
        inline = inline,
        args = {
            width = {
                type = "range",
                name = L["Width"],
                order = 1,
                min = 10,
                softMax = 400,
                step = 1,
                get = function()
                    return UF.config[unit].size[1]
                end,
                set = function(_, val)
                    UF.config[unit].size[1] = val
                    UF:UpdateUnit(unit)
                end
            },
            height = {
                type = "range",
                name = L["Height"],
                order = 2,
                min = 10,
                softMax = 400,
                step = 1,
                get = function()
                    return UF.config[unit].size[2]
                end,
                set = function(_, val)
                    UF.config[unit].size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            scale = {
                type = "range",
                name = L["Scale"],
                order = 3,
                min = 0.1,
                softMax = 3,
                step = 0.1,
                get = function()
                    return UF.config[unit].scale
                end,
                set = function(_, val)
                    UF.config[unit].scale = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitHealthOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Health Bar"],
        order = order,
        inline = inline,
        args = {
            desc = {
                order = 1,
                type = "description",
                name = L["NOTE: The size of the health bar for a unit always matches the frame size; to resize it, adjust the size of the frame."]
            }
        }
    }
end

function UF:CreateUnitHealthValueOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Health"],
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = L["Enabled"],
                order = 1,
                get = function()
                    return UF.config[unit].health.value.enabled
                end,
                set = function(_, val)
                    UF.config[unit].health.value.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = L["Position"], order = 2},
            point = {
                type = "select",
                name = L["Point"],
                desc = L["The anchor point on the text to attach."],
                order = 11,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].health.value.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.value.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = L["Relative Point"],
                desc = L["The point on the health bar to attach value text to."],
                order = 12,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].health.value.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.value.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = L["Offset (X)"],
                desc = L["The horizontal offset from the anchor point."],
                order = 13,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].health.value.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].health.value.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = L["Offset (Y)"],
                desc = L["The vertical offset from the anchor point."],
                order = 14,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].health.value.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].health.value.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = L["Font"], order = 20},
            font = {
                type = "select",
                name = L["Font Family"],
                desc = L["The font family for health text."],
                order = 21,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].health.value.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.value.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                type = "range",
                name = L["Font Size"],
                desc = L["The size of health text."],
                order = 22,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].health.value.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].health.value.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                type = "select",
                name = L["Font Outline"],
                desc = L["The outline style of health text."],
                order = 23,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].health.value.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].health.value.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                type = "toggle",
                name = L["Font Shadows"],
                desc = L["Whether to show shadow for health text."],
                order = 24,
                get = function()
                    return UF.config[unit].health.value.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].health.value.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name =  L["Tag"], order = 30},
            tag = {
                type = "input",
                name = L["Tag"],
                desc = L["The tag determines what is displayed in the health value string."],
                order = 31,
                get = function()
                    return UF.config[unit].health.value.tag
                end,
                set = function(_, val)
                    UF.config[unit].health.value.tag = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitHealthPercentOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Health (Percentage)"],
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = L["Enabled"],
                order = 1,
                get = function()
                    return UF.config[unit].health.percent.enabled
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = L["Position"], order = 2},
            point = {
                type = "select",
                name = L["Point"],
                desc = L["The anchor point on the text to attach."],
                order = 11,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].health.percent.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.percent.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = L["Relative Point"],
                desc = L["The point on the health bar to attach value text to."],
                order = 12,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].health.percent.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.percent.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = L["Offset (X)"],
                desc = L["The horizontal offset from the anchor point."],
                order = 13,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].health.percent.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = L["Offset (Y)"],
                desc = L["The vertical offset from the anchor point."],
                order = 14,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].health.percent.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = {
                type = "select",
                name = L["Font Family"],
                desc = L["The font family for health text."],
                order = 21,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].health.percent.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.percent.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                type = "range",
                name = L["Font Size"],
                desc = L["The size of health text."],
                order = 22,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].health.percent.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                type = "select",
                name = L["Font Outline"],
                desc = L["The outline style of health text."],
                order = 23,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].health.percent.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].health.percent.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                type = "toggle",
                name = L["Font Shadows"],
                desc = L["Whether to show shadow for health text."],
                order = 24,
                get = function()
                    return UF.config[unit].health.percent.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = {
                type = "input",
                name = L["Tag"],
                desc = L["The tag determines what is displayed in the health value string."],
                order = 31,
                get = function()
                    return UF.config[unit].health.percent.tag
                end,
                set = function(_, val)
                    UF.config[unit].health.percent.tag = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitPowerOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or L["Power Bar"],
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = L["Enabled"],
                order = 1,
                get = function()
                    return UF.config[unit].power.enabled
                end,
                set = function(_, val)
                    UF.config[unit].power.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakLayout = {type = "description", name = "", order = 2},
            layout = {
                type = "group",
                name = L["Layout"],
                order = 3,
                inline = true,
                args = {
                    width = {
                        type = "range",
                        name = L["Width"],
                        desc = L["The width of the power bar. Only applicable when the power bar is detached or inset."],
                        order = 1,
                        min = 0,
                        softMax = 500,
                        step = 1,
                        disabled = function()
                            return not UF.config[unit].power.detached and not UF.config[unit].power.inset
                        end,
                        get = function()
                            return UF.config[unit].power.size[1]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.size[1] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    height = {
                        type = "range",
                        name = L["Height"],
                        desc = L["The height of the power bar."],
                        order = 2,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        get = function()
                            return UF.config[unit].power.size[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.size[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    lineBreakSize = {type = "description", name = "", order = 3},
                    detached = {
                        type = "toggle",
                        name = L["Detached"],
                        desc = L["Whether the power bar is detached from the health bar."],
                        order = 10,
                        disabled = unit ~= "player",
                        get = function()
                            return UF.config[unit].power.detached
                        end,
                        set = function(_, val)
                            UF.config[unit].power.inset = false
                            UF.config[unit].power.detached = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    inset = {
                        type = "toggle",
                        name = L["Inset"],
                        desc = L["Whether the power bar is displayed as an inset."],
                        order = 4,
                        get = function()
                            return UF.config[unit].power.inset
                        end,
                        set = function(_, val)
                            UF.config[unit].power.detached = false
                            UF.config[unit].power.inset = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    insetPoint = {
                        type = "group",
                        name = L["Inset Point"],
                        order = 5,
                        inline = true,
                        hidden = function()
                            return not UF.config[unit].power.inset
                        end,
                        args = {
                            point = {
                                type = "select",
                                name = L["Point"],
                                desc = L["The anchor point on the power bar to attach."],
                                order = 1,
                                values = R.ANCHOR_POINTS,
                                get = function()
                                    for key, value in ipairs(R.ANCHOR_POINTS) do
                                        if value == UF.config[unit].power.insetPoint[1] then
                                            return key
                                        end
                                    end
                                end,
                                set = function(_, key)
                                    UF.config[unit].power.insetPoint[1] = R.ANCHOR_POINTS[key]
                                    UF:UpdateUnit(unit)
                                end
                            },
                            relativePoint = {
                                type = "select",
                                name = L["Relative Point"],
                                desc = L["The point on the frame to attach value text to."],
                                order = 2,
                                values = R.ANCHOR_POINTS,
                                get = function()
                                    for key, value in ipairs(R.ANCHOR_POINTS) do
                                        if value == UF.config[unit].power.insetPoint[2] then
                                            return key
                                        end
                                    end
                                end,
                                set = function(_, key)
                                    UF.config[unit].power.insetPoint[2] = R.ANCHOR_POINTS[key]
                                    UF:UpdateUnit(unit)
                                end
                            },
                            offsetX = {
                                type = "range",
                                name = L["Offset (X)"],
                                desc = L["The horizontal offset from the anchor point."],
                                order = 3,
                                min = -50,
                                softMax = 50,
                                step = 1,
                                get = function()
                                    return UF.config[unit].power.insetPoint[3]
                                end,
                                set = function(_, val)
                                    UF.config[unit].power.insetPoint[3] = val
                                    UF:UpdateUnit(unit)
                                end
                            },
                            offsetY = {
                                type = "range",
                                name = L["Offset (Y)"],
                                desc = L["The vertical offset from the anchor point."],
                                order = 4,
                                min = -50,
                                softMax = 50,
                                step = 1,
                                get = function()
                                    return UF.config[unit].power.insetPoint[4]
                                end,
                                set = function(_, val)
                                    UF.config[unit].power.insetPoint[4] = val
                                    UF:UpdateUnit(unit)
                                end
                            }
                        }
                    }
                }
            },
            lineBreak2 = {type = "description", name = "", order = 6},
            powerPrediction = {
                type = "toggle",
                name = L["Power Prediction"],
                desc = L["Whether power prediction is enabled for the player's power bar."],
                order = 7,
                hidden = unit ~= "player",
                get = function()
                    return UF.config[unit].power.powerPrediction
                end,
                set = function(_, val)
                    UF.config[unit].power.powerPrediction = val
                    UF:UpdateUnit(unit)
                end
            },
            energyManaRegen = {
                type = "toggle",
                name = L["Energy/Mana Regen Tick"],
                desc = L["Whether the energy/mana regen tick is enabled for the player's power bar."],
                order = 8,
                hidden = unit ~= "player",
                get = function()
                    return UF.config[unit].power.energyManaRegen
                end,
                set = function(_, val)
                    UF.config[unit].power.energyManaRegen = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitPowerValueOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Power",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].power.value.enabled
                end,
                set = function(_, val)
                    UF.config[unit].power.value.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "Position", order = 2},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the text string.",
                order = 11,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].power.value.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].power.value.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the power bar to attach to.",
                order = 12,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].power.value.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].power.value.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 13,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].power.value.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].power.value.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 14,
                min = -50,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].power.value.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].power.value.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = {
                name = "Font Family",
                type = "select",
                desc = "The font family for power text.",
                order = 21,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].power.value.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].power.value.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                name = "Font Size",
                type = "range",
                desc = "The size of power text.",
                order = 22,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].power.value.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].power.value.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                name = "Font Outline",
                type = "select",
                desc = "The outline style of health text.",
                order = 23,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].power.value.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].power.value.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                name = "Font Shadows",
                type = "toggle",
                desc = "Whether to show shadow for power text.",
                order = 24,
                get = function()
                    return UF.config[unit].power.value.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].power.value.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = {
                name = "Tag",
                type = "input",
                desc = "The tag determines what is displayed in the power value string.",
                order = 31,
                get = function()
                    return UF.config[unit].power.value.tag
                end,
                set = function(_, val)
                    UF.config[unit].power.value.tag = val
                    UF:UpdateUnit(unit)
                end
            }

        }
    }
end

function UF:CreateUnitNameOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Name",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].name.enabled
                end,
                set = function(_, val)
                    UF.config[unit].name.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakSize = {type = "header", name = "Size", order = 2},
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the name text.",
                order = 11,
                min = 0,
                softMax = 400,
                step = 1,
                get = function()
                    return UF.config[unit].name.size[1]
                end,
                set = function(_, val)
                    UF.config[unit].name.size[1] = val
                    UF:UpdateUnit(unit)
                end
            },
            height = {
                type = "range",
                name = "Height",
                desc = "The height of the name text.",
                order = 12,
                min = 0,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].name.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].name.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "Position", order = 15},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the name text.",
                order = 16,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].name.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].name.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 17,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].name.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].name.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 18,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].name.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].name.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 19,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].name.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].name.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = {
                name = "Font Family",
                type = "select",
                desc = "The font family for name text.",
                order = 21,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].name.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].name.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                name = "Font Size",
                type = "range",
                desc = "The size of name text.",
                order = 22,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].name.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].name.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                name = "Font Outline",
                type = "select",
                desc = "The outline style of name text.",
                order = 23,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].name.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].name.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            justifyH = {
                name = "Horizontal Justification",
                type = "select",
                order = 24,
                values = R.JUSTIFY_H,
                get = function()
                    return UF.config[unit].name.justifyH
                end,
                set = function(_, key)
                    UF.config[unit].name.justifyH = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                name = "Font Shadows",
                type = "toggle",
                desc = "Whether to show shadow for name text.",
                order = 25,
                get = function()
                    return UF.config[unit].name.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].name.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = {
                name = "Tag",
                type = "input",
                desc = "The tag determines what is displayed in the unit name text.",
                order = 31,
                get = function()
                    return UF.config[unit].name.tag
                end,
                set = function(_, val)
                    UF.config[unit].name.tag = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitLevelOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Level",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].level.enabled
                end,
                set = function(_, val)
                    UF.config[unit].level.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakSize = {type = "header", name = "Size", order = 2},
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the level text.",
                order = 11,
                min = 0,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].level.size[1]
                end,
                set = function(_, val)
                    UF.config[unit].level.size[1] = val
                    UF:UpdateUnit(unit)
                end
            },
            height = {
                type = "range",
                name = "Height",
                desc = "The height of the level text.",
                order = 12,
                min = 0,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].level.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].level.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "Position", order = 15},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the level text.",
                order = 16,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].level.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].level.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 17,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].level.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].level.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 18,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].level.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].level.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 19,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].level.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].level.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "Font", order = 20},
            font = {
                name = "Font Family",
                type = "select",
                desc = "The font family for level text.",
                order = 21,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].level.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].level.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                name = "Font Size",
                type = "range",
                desc = "The size of level text.",
                order = 22,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].level.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].level.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                name = "Font Outline",
                type = "select",
                desc = "The outline style of level text.",
                order = 23,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].level.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].level.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            justifyH = {
                name = "Horizontal Justification",
                type = "select",
                order = 24,
                values = R.JUSTIFY_H,
                get = function()
                    return UF.config[unit].level.justifyH
                end,
                set = function(_, key)
                    UF.config[unit].level.justifyH = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                name = "Font Shadows",
                type = "toggle",
                desc = "Whether to show shadow for level text.",
                order = 25,
                get = function()
                    return UF.config[unit].level.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].level.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name = "Tag", order = 30},
            tag = {
                name = "Tag",
                type = "input",
                desc = "The tag determines what is displayed in the unit level text.",
                order = 31,
                get = function()
                    return UF.config[unit].level.tag
                end,
                set = function(_, val)
                    UF.config[unit].level.tag = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitPortraitOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Portrait",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].portrait.enabled
                end,
                set = function(_, val)
                    UF.config[unit].portrait.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak0 = {type = "description", name = "", order = 2},
            class = {
                type = "toggle",
                name = "Use Class Icons",
                desc = "Whether to use class icons for the portrait texture.",
                order = 3,
                get = function()
                    return UF.config[unit].portrait.class
                end,
                set = function(_, val)
                    UF.config[unit].portrait.model = false
                    UF.config[unit].portrait.class = val
                    UF:UpdateUnit(unit)
                end
            },
            model = {
                type = "toggle",
                name = "Use 3D Portrait",
                desc = "Whether to use class 3D portraits.",
                order = 4,
                get = function()
                    return UF.config[unit].portrait.model
                end,
                set = function(_, val)
                    UF.config[unit].portrait.class = false
                    UF.config[unit].portrait.model = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "description", name = "", order = 5},
            detached = {
                type = "toggle",
                name = "Detached",
                desc = "Whether the portrait is detached from the health bar.",
                order = 10,
                get = function()
                    return UF.config[unit].portrait.detached
                end,
                set = function(_, val)
                    UF.config[unit].portrait.detached = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak2 = {type = "description", name = "", order = 11},
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the portrait.",
                order = 12,
                min = 0,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].portrait.size[1]
                end,
                set = function(_, val)
                    UF.config[unit].portrait.size[1] = val
                    UF:UpdateUnit(unit)
                end
            },
            height = {
                type = "range",
                name = "Height",
                desc = "The height of the portrait when detached. Portrait height will match frame height when not detached.",
                order = 13,
                min = 0,
                softMax = 100,
                step = 1,
                disabled = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    return UF.config[unit].portrait.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].portrait.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak3 = {type = "description", name = "", order = 20},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the castbar.",
                order = 21,
                values = R.ANCHOR_POINTS,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].portrait.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].portrait.point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 22,
                values = R.ANCHOR_POINTS,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].portrait.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].portrait.point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 23,
                softMin = -50,
                softMax = 50,
                step = 1,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    return UF.config[unit].portrait.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].portrait.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 24,
                softMin = -50,
                softMax = 50,
                step = 1,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    return UF.config[unit].portrait.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].portrait.point[4] = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitCastbarOption(unit, order, inline, canDetach, name)
    return {
        type = "group",
        name = name or "Castbar",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].castbar.enabled
                end,
                set = function(_, val)
                    UF.config[unit].castbar.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "header", name = "", order = 2},
            showIcon = {
                type = "toggle",
                name = "Show Icon",
                desc = "Whether to show an icon in the castbar.",
                order = 3,
                disabled = not canDetach,
                get = function()
                    return UF.config[unit].castbar.showIcon
                end,
                set = function(_, val)
                    UF.config[unit].castbar.showIcon = val
                    UF:UpdateUnit(unit)
                end
            },
            showIconOutside = {
                type = "toggle",
                name = "Show Icon Outside",
                desc = "Whether to show the icon outside the castbar.",
                order = 4,
                disabled = function()
                    return not UF.config[unit].castbar.showIcon
                end,
                get = function()
                    return UF.config[unit].castbar.showIconOutside
                end,
                set = function(_, val)
                    UF.config[unit].castbar.showIconOutside = val
                    UF:UpdateUnit(unit)
                end
            },
            showSafeZone = {
                type = "toggle",
                name = "Show Latency",
                desc = "Whether to show a latency indicator.",
                order = 5,
                hidden = (unit ~= "player"),
                get = function()
                    return UF.config[unit].castbar.showSafeZone
                end,
                set = function(_, val)
                    UF.config[unit].castbar.showSafeZone = val
                    UF:UpdateUnit(unit)
                end
            },
            showSpark = {
                type = "toggle",
                name = "Show Spark",
                desc = "Whether to show the spark at the end of the castbar.",
                order = 6,
                hidden = UF.defaults[unit].castbar.showSpark == nil,
                get = function()
                    return UF.config[unit].castbar.showSpark
                end,
                set = function(_, val)
                    UF.config[unit].castbar.showSpark = val
                    UF:UpdateUnit(unit)
                end
            },
            layout = {
                type = "group",
                name = "Layout",
                inline = true,
                order = 10,
                args = {
                    width = {
                        type = "range",
                        name = "Width",
                        order = 1,
                        min = 10,
                        softMax = 400,
                        step = 1,
                        get = function()
                            return UF.config[unit].castbar.size[1]
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.size[1] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    height = {
                        type = "range",
                        name = "Height",
                        order = 2,
                        min = 8,
                        softMax = 400,
                        step = 1,
                        get = function()
                            return UF.config[unit].castbar.size[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.size[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    lineBreak1 = {type = "description", name = "", order = 20},
                    detached = {
                        type = "toggle",
                        name = "Detached",
                        desc = "Whether the cast bar is detached from the frame.",
                        order = 10,
                        hidden = not canDetach,
                        get = function()
                            return UF.config[unit].castbar.detached
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.detached = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    lineBreak2 = {type = "description", name = "", order = 20},
                    point = {
                        type = "select",
                        name = "Point",
                        desc = "The anchor point on the castbar.",
                        order = 21,
                        values = R.ANCHOR_POINTS,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            for key, value in ipairs(R.ANCHOR_POINTS) do
                                if value == UF.config[unit].castbar.point[1] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.point[1] = R.ANCHOR_POINTS[key]
                            UF:UpdateUnit(unit)
                        end
                    },
                    relativePoint = {
                        type = "select",
                        name = "Relative Point",
                        desc = "The point on the unit frame to attach to.",
                        order = 22,
                        values = R.ANCHOR_POINTS,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            for key, value in ipairs(R.ANCHOR_POINTS) do
                                if value == UF.config[unit].castbar.point[2] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.point[2] = R.ANCHOR_POINTS[key]
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetX = {
                        type = "range",
                        name = "Offset (X)",
                        desc = "The horizontal offset from the anchor point.",
                        order = 23,
                        min = -500,
                        softMax = 500,
                        step = 1,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            return UF.config[unit].castbar.point[3]
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.point[3] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetY = {
                        type = "range",
                        name = "Offset (Y)",
                        desc = "The vertical offset from the anchor point.",
                        order = 24,
                        min = -500,
                        softMax = 500,
                        step = 1,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            return UF.config[unit].castbar.point[4]
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.point[4] = val
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            },
            font = {
                type = "group",
                name = "Font",
                inline = true,
                order = 11,
                args = {
                    font = {
                        name = "Font Family",
                        type = "select",
                        desc = "The font family for castbar text.",
                        order = 1,
                        dialogControl = "LSM30_Font",
                        values = R.Libs.SharedMedia:HashTable("font"),
                        get = function()
                            for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                if UF.config[unit].castbar.font == font then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.font = R.Libs.SharedMedia:Fetch("font", key)
                            UF:UpdateUnit(unit)
                        end
                    },
                    fontSize = {
                        name = "Font Size",
                        type = "range",
                        desc = "The size of castbar text.",
                        order = 2,
                        min = R.FONT_MIN_SIZE,
                        max = R.FONT_MAX_SIZE,
                        step = 1,
                        get = function()
                            return UF.config[unit].castbar.fontSize
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.fontSize = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    fontOutline = {
                        name = "Font Outline",
                        type = "select",
                        desc = "The outline style of castbar text.",
                        order = 3,
                        values = R.FONT_OUTLINES,
                        get = function()
                            return UF.config[unit].castbar.fontOutline
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.fontOutline = key
                            UF:UpdateUnit(unit)
                        end
                    },
                    fontShadow = {
                        name = "Font Shadows",
                        type = "toggle",
                        desc = "Whether to show shadow for castbar text.",
                        order = 4,
                        get = function()
                            return UF.config[unit].castbar.fontShadow
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.fontShadow = val
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            }
        }
    }
end

function UF:CreateUnitIndicatorOption(unit, indicatorName, order, title)
    return {
        type = "group",
        name = title,
        order = order,
        args = {
            enabled = UF:CreateUnitIndicatorEnabledOption(unit, indicatorName, 1),
            point = UF:CreateUnitIndicatorPointOption(unit, indicatorName, 2),
            size = UF:CreateUnitIndicatorSizeOption(unit, indicatorName, 3)
        }
    }
end

function UF:CreateUnitIndicatorEnabledOption(unit, indicatorName, order)
    return {
        type = "toggle",
        name = "Enabled",
        order = order,
        get = function()
            return UF.config[unit][indicatorName].enabled
        end,
        set = function(_, val)
            UF.config[unit][indicatorName].enabled = val
            UF:UpdateUnit(unit)
        end
    }
end

function UF:CreateUnitIndicatorPointOption(unit, indicatorName, order)
    return {
        type = "group",
        name = "Position",
        order = order,
        inline = true,
        args = {
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the indicator.",
                order = 1,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit][indicatorName].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit][indicatorName].point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 2,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit][indicatorName].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit][indicatorName].point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 3,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit][indicatorName].point[3]
                end,
                set = function(_, val)
                    UF.config[unit][indicatorName].point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 4,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit][indicatorName].point[4]
                end,
                set = function(_, val)
                    UF.config[unit][indicatorName].point[4] = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitIndicatorSizeOption(unit, indicatorName, order)
    return {
        type = "group",
        name = "Size",
        order = order,
        inline = true,
        args = {
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the indicator.",
                order = 1,
                min = 0,
                softMax = 100,
                step = 1,
                get = function()
                    return UF.config[unit][indicatorName].size[1]
                end,
                set = function(_, val)
                    UF.config[unit][indicatorName].size[1] = val
                    UF:UpdateUnit(unit)
                end
            },
            height = {
                type = "range",
                name = "Offset (Y)",
                desc = "The height of the indicator.",
                order = 2,
                min = 0,
                softMax = 100,
                step = 1,
                get = function()
                    return UF.config[unit][indicatorName].size[2]
                end,
                set = function(_, val)
                    UF.config[unit][indicatorName].size[2] = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitIndicatorsOption(unit, order, inline, name)
    local indicators = {type = "group", name = name or "Indicators", order = order, inline = inline, args = {}}

    if not UF.defaults[unit] then
        return
    end

    local args = indicators.args

    if UF.defaults[unit].combatIndicator then
        args.combatIndicator = UF:CreateUnitIndicatorOption(unit, "combatIndicator", #args, "Combat")
    end
    if UF.defaults[unit].restingIndicator then
        args.restingIndicator = UF:CreateUnitIndicatorOption(unit, "restingIndicator", #args, "Resting")
    end
    if UF.defaults[unit].pvpIndicator then
        args.pvpIndicator = UF:CreateUnitIndicatorOption(unit, "pvpIndicator", #args, "PvP Status")
    end
    if R.isRetail and UF.defaults[unit].pvpClassificationIndicator then
        args.pvpClassificationIndicator = UF:CreateUnitIndicatorOption(unit, "pvpClassificationIndicator", #args,
                                                                       "PvP Classification")
    end
    if not R.isRetail and UF.defaults[unit].masterLooterIndicator then
        args.masterLooterIndicator = UF:CreateUnitIndicatorOption(unit, "masterLooterIndicator", #args, "Master Looter")
    end
    if UF.defaults[unit].leaderIndicator then
        args.leaderIndicator = UF:CreateUnitIndicatorOption(unit, "leaderIndicator", #args, "Raid Leader")
    end
    if UF.defaults[unit].assistantIndicator then
        args.assistantIndicator = UF:CreateUnitIndicatorOption(unit, "assistantIndicator", #args, "Raid Assistant")
    end
    if UF.defaults[unit].raidRoleIndicator then
        args.raidRoleIndicator = UF:CreateUnitIndicatorOption(unit, "raidRoleIndicator", #args, "Raid Role")
    end
    if R.isRetail and UF.defaults[unit].groupRoleIndicator then
        args.groupRoleIndicator = UF:CreateUnitIndicatorOption(unit, "groupRoleIndicator", #args, "Group Role")
    end
    if UF.defaults[unit].raidTargetIndicator then
        args.raidTargetIndicator = UF:CreateUnitIndicatorOption(unit, "raidTargetIndicator", #args, "Raid Target Icon")
    end
    if UF.defaults[unit].readyCheckIndicator then
        args.readyCheckIndicator = UF:CreateUnitIndicatorOption(unit, "readyCheckIndicator", #args, "Ready Check")
    end
    if UF.defaults[unit].phaseIndicator then
        args.restingIndicator = UF:CreateUnitIndicatorOption(unit, "phaseIndicator", #args, "Phase")
    end
    if UF.defaults[unit].resurrectIndicator then
        args.resurrectIndicator = UF:CreateUnitIndicatorOption(unit, "resurrectIndicator", #args, "Resurrect")
    end
    if not R.isClassic and UF.defaults[unit].summonIndicator then
        args.summonIndicator = UF:CreateUnitIndicatorOption(unit, "summonIndicator", #args, "Summon")
    end
    if not R.isClassic and UF.defaults[unit].questIndicator then
        args.questIndicator = UF:CreateUnitIndicatorOption(unit, "questIndicator", #args, "Quest")
    end

    return indicators
end

function UF:CreateUnitAurasOptions(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Auras",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].auras.enabled
                end,
                set = function(_, val)
                    UF.config[unit].auras.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            buffs = UF:CreateUnitAurasOption(unit, 2, true, "Buffs", "buffs"),
            debuffs = UF:CreateUnitAurasOption(unit, 3, true, "Debuffs", "debuffs")
        }
    }
end

function UF:CreateUnitAurasOption(unit, order, inline, name, setting)
    return {
        type = "group",
        name = name,
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].auras[setting].enabled
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak = {type = "description", name = "", order = 2},
            iconSize = {
                type = "range",
                name = "Icon Size",
                desc = "The size of the aura icons.",
                order = 3,
                min = 10,
                softMax = 50,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].iconSize
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].iconSize = val
                    UF:UpdateUnit(unit)
                end
            },
            spacing = {
                type = "range",
                name = "Spacing",
                desc = "The spacing between auras.",
                order = 4,
                min = 0,
                softMax = 30,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].spacing
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].spacing = val
                    UF:UpdateUnit(unit)
                end
            },
            numColumns = {
                type = "range",
                name = "Number of Columns",
                desc = "The number of columns.",
                order = 5,
                min = 1,
                softMax = 32,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].numColumns
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].numColumns = val
                    UF:UpdateUnit(unit)
                end
            },
            num = {
                type = "range",
                name = "Number of " .. name,
                desc = "The number of auras to show.",
                order = 6,
                min = 1,
                softMax = R.isRetail and 32 or 16,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].num
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].num = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "description", name = "", order = 10},
            showDuration = {
                type = "toggle",
                name = "Show Duration",
                desc = "Whether to show duration numbers on auras.",
                order = 11,
                get = function()
                    return UF.config[unit].auras[setting].showDuration
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].showDuration = val
                    UF:UpdateUnit(unit)
                end
            },
            onlyShowPlayer = {
                type = "toggle",
                name = "Only Show Player",
                desc = "Whether to only show auras cast by the player.",
                order = 12,
                get = function()
                    return UF.config[unit].auras[setting].onlyShowPlayer
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].onlyShowPlayer = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak2 = {type = "header", name = "Position", order = 20},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the " .. setting .. " frame.",
                order = 21,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].auras[setting].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].auras[setting].point[1] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 22,
                values = R.ANCHOR_POINTS,
                get = function()
                    for key, value in ipairs(R.ANCHOR_POINTS) do
                        if value == UF.config[unit].auras[setting].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].auras[setting].point[2] = R.ANCHOR_POINTS[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 23,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].point[3]
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 24,
                min = -500,
                softMax = 500,
                step = 1,
                get = function()
                    return UF.config[unit].auras[setting].point[4]
                end,
                set = function(_, val)
                    UF.config[unit].auras[setting].point[4] = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }
end

function UF:CreateUnitHighlightOption(unit, order, inline, name)
    local highlight = {
        type = "group",
        name = name or "Highlighting",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].highlight.enabled
                end,
                set = function(_, val)
                    UF.config[unit].highlight.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "description", name = "", order = 2},
            colorBorder = {
                type = "toggle",
                name = "Color Border",
                desc = "Whether to color unit frame borders when highlighting.",
                order = 10,
                get = function()
                    return UF.config[unit].highlight.colorBorder
                end,
                set = function(_, val)
                    UF.config[unit].highlight.colorBorder = val
                    UF:UpdateUnit(unit)
                end
            },
            colorShadow = {
                type = "toggle",
                name = "Color Shadows",
                desc = "Whether to color unit frame shadows when highlighting.",
                order = 11,
                get = function()
                    return UF.config[unit].highlight.colorShadow
                end,
                set = function(_, val)
                    UF.config[unit].highlight.colorShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak2 = {type = "description", name = "", order = 20},
            debuffs = {
                type = "toggle",
                name = "Highlight Based On Debuff",
                desc = "Whether to color unit frames based on debuff type.",
                order = 21,
                get = function()
                    return UF.config[unit].highlight.debuffs
                end,
                set = function(_, val)
                    UF.config[unit].highlight.debuffs = val
                    UF:UpdateUnit(unit)
                end
            },
            onlyDispellableDebuffs = {
                type = "toggle",
                name = "Only Highlight Dispellable Debuffs",
                desc = "Whether only highlight unit frames when player can dispel the debuff.",
                order = 22,
                get = function()
                    return UF.config[unit].highlight.onlyDispellableDebuffs
                end,
                set = function(_, val)
                    UF.config[unit].highlight.onlyDispellableDebuffs = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak3 = {type = "description", name = "", order = 30},
            threat = {
                type = "toggle",
                name = "Highlight Based On Threat",
                desc = "Whether to color unit frames based on debuff type.",
                order = 31,
                get = function()
                    return UF.config[unit].highlight.threat
                end,
                set = function(_, val)
                    UF.config[unit].highlight.threat = val
                    UF:UpdateUnit(unit)
                end
            },
            target = {
                type = "toggle",
                name = "Highlight Target",
                desc = "Whether to color unit frames when targeted.",
                order = 32,
                get = function()
                    return UF.config[unit].highlight.target
                end,
                set = function(_, val)
                    UF.config[unit].highlight.target = val
                    UF:UpdateUnit(unit)
                end
            }
        }
    }

    if UF.defaults[unit].highlight.targetArrows ~= nil then
        highlight.args.targetArrows = {
            type = "toggle",
            name = "Show Target Arrows",
            desc = "Whether to show arrows next to the frame when targeted.",
            order = 33,
            get = function()
                return UF.config[unit].highlight.targetArrows
            end,
            set = function(_, val)
                UF.config[unit].highlight.targetArrows = val
                UF:UpdateUnit(unit)
            end
        }
    end

    return highlight
end

R:RegisterModuleOptions(UF, {
    type = "group",
    name = L["Unit Frames"],
    childGroups = "tree",
    args = {
        header = {type = "header", name = R.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = L["Enabled"],
            order = 1,
            confirm = function()
                if UF.config.enabled then
                    return L["Disabling this module requires a UI reload. Proceed?"]
                else
                    return false
                end
            end,
            get = function()
                return UF.config.enabled
            end,
            set = function(_, val)
                UF.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    UF:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2},
        fonts = {
            type = "group",
            name = L["Fonts"],
            order = 5,
            inline = true,
            args = {
                font = {
                    name = L["Default Font Family"],
                    desc = L["The default font family for unit frame texts."],
                    type = "select",
                    order = 1,
                    dialogControl = "LSM30_Font",
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if UF.config.font == font then return key end end
                    end,
                    set = function(_, key)
                        UF.config.font = R.Libs.SharedMedia:Fetch("font", key)
                        UF:UpdateAll()
                    end
                }
            }
        },
        statusbarTextures = {
            type = "group",
            name = L["Status Bar Textures"],
            order = 6,
            inline = true,
            args = {
                health = UF:CreateStatusBarTextureOption("Health", "Set the texture to use for health bars.", "health", 1),
                healthPrediction = UF:CreateStatusBarTextureOption("Health Prediction (Healing)", "Set the texture to use for health prediction bars.", "healthPrediction", 2),
                power = UF:CreateStatusBarTextureOption("Power", "Set the texture to use for power bars.", "power", 11),
                powerPrediction = UF:CreateStatusBarTextureOption("Power Prediction (Power Cost)", "Set the texture to use for power prediction bars.", "powerPrediction", 12),
                additionalPower = UF:CreateStatusBarTextureOption("Additional Power", "Set the texture to use for power bars.", "additionalPower", 21),
                additionalPowerPrediction = UF:CreateStatusBarTextureOption("Additional Power Prediction (Power Cost)", "Set the texture to use for additional power prediction bars.",
                                                                            "additionalPowerPrediction", 22),
                classPower = UF:CreateStatusBarTextureOption("Class Power", "Set the texture to use for class power bars (combo points etc).", "classPower", 25),
                castbar = UF:CreateStatusBarTextureOption("Cast Bars", "Set the texture to use for cast bars.", "castbar", 31)
            }
        },
        statusBarColors = {
            type = "group",
            name = L["Status Bar Colors"],
            order = 7,
            inline = true,
            args = {
                health = UF:CreateStatusBarColorOption("Health", "health", 2),
                mana = UF:CreateStatusBarColorOption("Mana", "mana", 3),
                rage = UF:CreateStatusBarColorOption("Rage", "rage", 4),
                energy = UF:CreateStatusBarColorOption("Energy", "energy", 5),
                focus = UF:CreateStatusBarColorOption("Focus", "focus", 6),
                comboPoints = UF:CreateStatusBarColorOption("Combo Points", "comboPoints", 7),
                castbar = UF:CreateStatusBarColorOption("Castbar", "castbar", 8),
                castbar_Shielded = UF:CreateStatusBarColorOption("Castbar (Shielded)", "castbar_Shielded", 9),
                lineBreak1 = {type = "header", name = "", order = 15},
                colorHealthClass = {
                    type = "toggle",
                    name = "Color Health by Class",
                    order = 20,
                    get = function()
                        return UF.config.colors.colorHealthClass
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthClass = val
                        UF:UpdateAll()
                    end
                },
                colorHealthSmooth = {
                    type = "toggle",
                    name = "Color Health by Value",
                    order = 21,
                    get = function()
                        return UF.config.colors.colorHealthSmooth
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorHealthDisconnected = {
                    type = "toggle",
                    name = "Color Health when Disconnected",
                    order = 22,
                    get = function()
                        return UF.config.colors.colorHealthDisconnected
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthDisconnected = val
                        UF:UpdateAll()
                    end
                },
                colorPowerClass = {
                    type = "toggle",
                    name = "Color Power by Class",
                    order = 30,
                    get = function()
                        return UF.config.colors.colorPowerClass
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerClass = val
                        UF:UpdateAll()
                    end
                },
                colorPowerSmooth = {
                    type = "toggle",
                    name = "Color Power by Value",
                    order = 31,
                    get = function()
                        return UF.config.colors.colorPowerSmooth
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorPowerDisconnected = {
                    type = "toggle",
                    name = "Color Power when Disconnected",
                    order = 32,
                    get = function()
                        return UF.config.colors.colorPowerDisconnected
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerDisconnected = val
                        UF:UpdateAll()
                    end
                }
            }
        },
        classcolors = {
            type = "group",
            name = "Class Colors",
            order = 8,
            inline = true,
            args = {
                deathKnight = UF:CreateClassColorOption("DEATHKNIGHT", R:LocalizedClassName("Death Knight"), 10, R.isClassic),
                demonHunter = UF:CreateClassColorOption("DEMONHUNTER", R:LocalizedClassName("Demon Hunter"), 11, R.isClassic),
                druid = UF:CreateClassColorOption("DRUID", R:LocalizedClassName("Druid"), 12),
                hunter = UF:CreateClassColorOption("HUNTER", R:LocalizedClassName("Hunter"), 13),
                mage = UF:CreateClassColorOption("MAGE", R:LocalizedClassName("Mage"), 14),
                monk = UF:CreateClassColorOption("MONK", R:LocalizedClassName("Monk"), 15, R.isClassic),
                paladin = UF:CreateClassColorOption("PALADIN", R:LocalizedClassName("Paladin"), 16),
                priest = UF:CreateClassColorOption("PRIEST", R:LocalizedClassName("Priest"), 17),
                rogue = UF:CreateClassColorOption("ROGUE", R:LocalizedClassName("Rogue"), 18),
                shaman = UF:CreateClassColorOption("SHAMAN", R:LocalizedClassName("Shaman"), 19),
                warlock = UF:CreateClassColorOption("WARLOCK", R:LocalizedClassName("Warlock"), 20),
                warrior = UF:CreateClassColorOption("WARRIOR", R:LocalizedClassName("Warrior"), 21)
            }
        },
        player = UF:CreateUnitOptions("player", 11, false, "Player"),
        target = UF:CreateUnitOptions("target", 12, false, "Target"),
        targettarget = UF:CreateUnitOptions("targettarget", 13, false, "Target's Target"),
        pet = UF:CreateUnitOptions("pet", 14, false, "Pet"),
        focus = UF:CreateUnitOptions("focus", 15, false, "Focus", R.isClassic),
        focustarget = UF:CreateUnitOptions("focustarget", 16, false, "Focus's Target", R.isClassic),
        party = UF:CreateUnitOptions("party", 17, false, "Party"),
        raid = UF:CreateUnitOptions("raid", 18, false, "Raid"),
        tank = UF:CreateUnitOptions("tank", 19, false, "Tank"),
        assist = UF:CreateUnitOptions("assist", 19, false, "Assist"),
        boss = UF:CreateUnitOptions("boss", 20, false, "Boss", not R.isRetail),
        arena = UF:CreateUnitOptions("arena", 21, false, "Arena", R.isClassic),
        nameplates = UF:CreateUnitOptions("nameplates", 22, false, "Nameplates")
    }
})
