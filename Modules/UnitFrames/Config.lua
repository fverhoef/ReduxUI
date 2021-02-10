local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.themes = {Blizzard = "Blizzard", Blizzard_LargeHealth = "Blizzard_LargeHealth", Custom = "Custom"}
UF.themedUnits = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["focustarget"] = true,
    ["party"] = true,
    ["boss"] = true
}
UF.anchorPoints = {"TOPLEFT", "TOP", "TOPRIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT", "CENTER"}
UF.anchors = {"UIParent", "Player", "Target", "Pet"}
UF.unitAnchors = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
UF.groupAnchors = {"TOP", "BOTTOM", "LEFT", "RIGHT"}

function UF:IsBlizzardTheme()
    return UF.config.theme == UF.themes.Blizzard or UF.config.theme == UF.themes.Blizzard_LargeHealth
end

function UF:CreateStatusBarTextureOption(name, desc, option, order)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        dialogControl = "LSM30_Statusbar",
        values = R.Libs.SharedMedia:HashTable("statusbar"),
        get = function()
            for key, texture in pairs(R.Libs.SharedMedia:HashTable("statusbar")) do
                if UF.config.statusbars[option] == texture then
                    return key
                end
            end
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

function UF:CreateUnitEnabledOption(unit, order)
    return {
        type = "toggle",
        name = "Enabled",
        order = order,
        confirm = function()
            return "Disabling this unit requires a UI reload. Proceed?"
        end,
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
        name = name or "Position",
        order = order,
        inline = inline,
        args = {
            point = {
                type = "select",
                name = "Point",
                desc = "The point on the frame to attach to the anchor.",
                order = 1,
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            anchor = {
                type = "select",
                name = "Anchor",
                desc = "The frame to attach to.",
                order = 2,
                values = UF.anchors,
                get = function()
                    for key, value in ipairs(UF.anchors) do
                        if value == UF.config[unit].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[2] = UF.anchors[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the anchor frame to attach to.",
                order = 3,
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].point[3] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].point[3] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 4,
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
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 5,
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
        name = name or "Size",
        order = order,
        inline = inline,
        args = {
            width = {
                type = "range",
                name = "Width",
                order = 1,
                min = 10,
                softMax = 400,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                name = "Height",
                order = 2,
                min = 10,
                softMax = 400,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                name = "Scale",
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
        name = name or "Health",
        order = order,
        inline = inline,
        args = {
            desc = {
                order = 1,
                type = "description",
                name = "NOTE: The size of the health bar for a unit always matches the frame size; to resize it, adjust the size of the frame."
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the health bar to attach value text to.",
                order = 11,
                values = UF.anchorPoints,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].health.value.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].health.value.point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 12,
                min = -50,
                softMax = 50,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].health.value.point[2]
                end,
                set = function(_, val)
                    UF.config[unit].health.value.point[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 13,
                min = -50,
                softMax = 50,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].health.value.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].health.value.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "", order = 20},
            font = {
                name = "Font Family",
                type = "select",
                desc = "The font family for health text.",
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
                name = "Font Size",
                type = "range",
                desc = "The size of health text.",
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
                name = "Font Outline",
                type = "select",
                desc = "The outline style of health text.",
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
                name = "Font Shadows",
                type = "toggle",
                desc = "Whether to show shadow for health text.",
                order = 24,
                get = function()
                    return UF.config[unit].health.value.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].health.value.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakTag = {type = "header", name = "", order = 30},
            tag = {
                name = "Tag",
                type = "input",
                desc = "The tag determines what is displayed in the health value string.",
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

function UF:CreateUnitPowerOption(unit, order, inline, name)
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
                    return UF.config[unit].power.enabled
                end,
                set = function(_, val)
                    UF.config[unit].power.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "header", name = "", order = 2},
            detached = {
                type = "toggle",
                name = "Detached",
                desc = "Whether the power bar is detached from the health bar.",
                order = 10,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].power.detached
                end,
                set = function(_, val)
                    UF.config[unit].power.detached = val
                    UF:UpdateUnit(unit)
                end
            },
            width = {
                type = "range",
                name = "Detached Width",
                desc = "The width of the power bar when detached.",
                order = 11,
                min = 0,
                softMax = 500,
                step = 1,
                disabled = function()
                    return not UF.config[unit].power.detached or UF.themedUnits[unit] and UF:IsBlizzardTheme()
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
                name = "Height",
                desc = "The height of the power bar.",
                order = 12,
                min = 0,
                softMax = 100,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].power.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].power.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            value = {
                type = "group",
                name = "Value",
                inline = true,
                order = 20,
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
                    lineBreakPoint = {type = "header", name = "", order = 2},
                    relativePoint = {
                        type = "select",
                        name = "Relative Point",
                        desc = "The point on the power bar to attach to.",
                        order = 11,
                        values = UF.anchorPoints,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].power.value.point[1] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].power.point[1] = UF.anchorPoints[key]
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetX = {
                        type = "range",
                        name = "Offset (X)",
                        desc = "The horizontal offset from the anchor point.",
                        order = 12,
                        min = -50,
                        softMax = 50,
                        step = 1,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                        get = function()
                            return UF.config[unit].power.value.point[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.value.point[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetY = {
                        type = "range",
                        name = "Offset (Y)",
                        desc = "The vertical offset from the anchor point.",
                        order = 13,
                        min = -50,
                        softMax = 50,
                        step = 1,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                        get = function()
                            return UF.config[unit].power.value.point[3]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.value.point[3] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    lineBreakFont = {type = "header", name = "", order = 20},
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
                    lineBreakTag = {type = "header", name = "", order = 30},
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
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the name text.",
                order = 11,
                min = 0,
                softMax = 400,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].name.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].name.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "", order = 15},
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 16,
                values = UF.anchorPoints,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].name.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].name.point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 17,
                min = -500,
                softMax = 500,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].name.point[2]
                end,
                set = function(_, val)
                    UF.config[unit].name.point[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 18,
                min = -500,
                softMax = 500,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].name.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].name.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "", order = 20},
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
            lineBreakTag = {type = "header", name = "", order = 30},
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
            width = {
                type = "range",
                name = "Width",
                desc = "The width of the level text.",
                order = 11,
                min = 0,
                softMax = 50,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].level.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].level.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "", order = 15},
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 16,
                values = UF.anchorPoints,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].level.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].level.point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            offsetX = {
                type = "range",
                name = "Offset (X)",
                desc = "The horizontal offset from the anchor point.",
                order = 17,
                min = -500,
                softMax = 500,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].level.point[2]
                end,
                set = function(_, val)
                    UF.config[unit].level.point[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            offsetY = {
                type = "range",
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
                order = 18,
                min = -500,
                softMax = 500,
                step = 1,
                disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                get = function()
                    return UF.config[unit].level.point[3]
                end,
                set = function(_, val)
                    UF.config[unit].level.point[3] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "", order = 20},
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
            lineBreakTag = {type = "header", name = "", order = 30},
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
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                        disabled = not canDetach,
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
                        name = "Relative Point",
                        desc = "The point on the unit frame to attach to.",
                        order = 21,
                        values = UF.anchorPoints,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].castbar.point[1] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.point[1] = UF.anchorPoints[key]
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetX = {
                        type = "range",
                        name = "Offset (X)",
                        desc = "The horizontal offset from the anchor point.",
                        order = 22,
                        min = -500,
                        softMax = 500,
                        step = 1,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            return UF.config[unit].castbar.point[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].castbar.point[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    offsetY = {
                        type = "range",
                        name = "Offset (Y)",
                        desc = "The vertical offset from the anchor point.",
                        order = 23,
                        min = -500,
                        softMax = 500,
                        step = 1,
                        disabled = UF.themedUnits[unit] and UF.IsBlizzardTheme or nil,
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
                    justifyH = {
                        name = "Horizontal Justification",
                        type = "select",
                        order = 4,
                        values = R.JUSTIFY_H,
                        get = function()
                            return UF.config[unit].castbar.justifyH
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.justifyH = key
                            UF:UpdateUnit(unit)
                        end
                    },
                    fontShadow = {
                        name = "Font Shadows",
                        type = "toggle",
                        desc = "Whether to show shadow for castbar text.",
                        order = 5,
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

R:RegisterModuleConfig(UF, {
    enabled = true,
    font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbars = {
        health = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        healthPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        power = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        powerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPowerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        castbar = R.Libs.SharedMedia:Fetch("statusbar", "Redux")
    },
    theme = UF.themes.Blizzard_LargeHealth,
    colors = {
        health = {49 / 255, 207 / 255, 37 / 255},
        mana = {0 / 255, 140 / 255, 255 / 255},
        rage = oUF.colors.power["RAGE"],
        energy = oUF.colors.power["ENERGY"],
        focus = oUF.colors.power["FOCUS"],
        comboPoints = oUF.colors.power["COMBO_POINTS"],
        castbar = {255 / 255, 175 / 255, 0 / 255},
        castbar_Shielded = {175 / 255, 175 / 255, 175 / 255},
        class = {
            ["DEATHKNIGHT"] = oUF.colors.class["DEATHKNIGHT"],
            ["DEMONHUNTER"] = oUF.colors.class["DEMONHUNTER"],
            ["DRUID"] = oUF.colors.class["DRUID"],
            ["HUNTER"] = oUF.colors.class["HUNTER"],
            ["MAGE"] = oUF.colors.class["MAGE"],
            ["MONK"] = oUF.colors.class["MONK"],
            ["PALADIN"] = oUF.colors.class["PALADIN"],
            ["PRIEST"] = oUF.colors.class["PRIEST"],
            ["ROGUE"] = oUF.colors.class["ROGUE"],
            ["SHAMAN"] = {0.0, 0.44, 0.87},
            ["WARLOCK"] = oUF.colors.class["WARLOCK"],
            ["WARRIOR"] = oUF.colors.class["WARRIOR"]
        },
        auraHighlight = {
            Magic = {0.2, 0.6, 1, 0.45},
            Curse = {0.6, 0, 1, 0.45},
            Disease = {0.6, 0.4, 0, 0.45},
            Poison = {0, 0.6, 0, 0.45},
            blendMode = "ADD"
        },
        colorHealthClass = true,
        colorHealthSmooth = false,
        colorHealthDisconnected = true,
        colorPowerClass = false,
        colorPowerSmooth = false,
        colorPowerDisconnected = true
    },
    player = {
        enabled = true,
        size = {180, 42},
        scale = 1,
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPLEFT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = true, detached = false, attachedPoint = "LEFT", size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {250, 25},
            point = {"CENTER", "UIParent", "BOTTOM", 0, 160},
            detached = true,
            showIcon = true,
            showIconOutside = false,
            showSafeZone = true,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 12,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    target = {
        enabled = true,
        size = {180, 42},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPRIGHT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPLEFT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = true, detached = false, attachedPoint = "RIGHT", size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {180, 20},
            point = {"BOTTOM", 0, -22},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    targettarget = {
        enabled = true,
        size = {95, 45},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Target", "BOTTOMRIGHT", 15, 0},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {75, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, attachedPoint = "LEFT", size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"BOTTOM", 0, 20},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    pet = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Player", "BOTTOMRIGHT", 34, 5},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = false,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {89, 15},
            point = {"BOTTOM", 0, 20},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focus = {
        enabled = R.isRetail,
        size = {90, 45},
        scale = 1,
        point = {"TOP", "UIParent", "TOP", 0, 300},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {70, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {113, 15},
            point = {"BOTTOM", 0, 20},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focustarget = {
        enabled = R.isRetail,
        size = {90, 30},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = false,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {70, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"BOTTOM", 0, 20},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {105, 30},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -20},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {85, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            iconSize = 16,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {89, 15},
            point = {"RIGHT", 20, 0},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            fontSize = 14,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1},

        unitAnchorPoint = "TOP",
        unitSpacing = 50,
        sortMethod = "INDEX", -- NAME, INDEX
        sortDir = "ASC", -- ASC, DESC
        showPlayer = false,
        showSolo = false,
        showParty = true,
        showRaid = false
    },
    raid = {
        enabled = true,
        size = {90, 36},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -20},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"TOP", 0, -20},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 8},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {70, 10},
            point = {"TOPLEFT", 0, -8},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 12,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 16,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true,
            iconSize = 16
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"BOTTOM", 0, 20},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 14,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,

        raidWideSorting = false,
        unitAnchorPoint = "LEFT",
        unitSpacing = 5,
        groupAnchorPoint = "TOP",
        groupSpacing = 5,
        groupBy = "GROUP", -- GROUP, CLASS, ROLE
        groupingOrder = "1,2,3,4,5,6,7,8",
        sortMethod = "INDEX", -- NAME, INDEX
        sortDir = "ASC", -- ASC, DESC
        showPlayer = false,
        showSolo = false,
        showParty = false,
        showRaid = true

        -- visibility = "[group:raid] show"
    },
    boss = {
        enabled = R.isRetail,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"LEFT", 20, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    tank = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 12,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"RIGHT", 20, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    assist = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = true,
            detached = false,
            size = {150, 12},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"TOPLEFT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 12,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = false,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            point = {"RIGHT", 20, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    nameplates = {
        enabled = true,
        size = {150, 16},
        scale = 1,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curhp_status] ([perhp]%)"
            }
        },
        power = {
            enabled = false,
            detached = false,
            size = {150, 4},
            border = {enabled = true, size = 12},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            }
        },
        name = {
            enabled = true,
            size = {130, 10},
            point = {"TOPLEFT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"TOPRIGHT", 0, 12},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            iconSize = 25,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = true,
            size = {150, 12},
            point = {"TOP", 0, -20},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            fontSize = 19,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = false, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,

        showComboPoints = false,
        targetGlow = true,
        targetArrows = true,
        cvars = {
            nameplateMinScale = 1,
            nameplateMaxScale = 1,
            nameplateMinScaleDistance = 0,
            nameplateMaxScaleDistance = 80,
            nameplateGlobalScale = 1,
            NamePlateHorizontalScale = 1,
            NamePlateVerticalScale = 1,
            nameplateSelfScale = 1,
            nameplateSelectedScale = 1.2,
            nameplateLargerScale = 1.2,
            nameplateMinAlpha = 0.5,
            nameplateMaxAlpha = 0.8,
            nameplateMinAlphaDistance = 0,
            nameplateMaxAlphaDistance = 80,
            nameplateSelectedAlpha = 1,
            nameplateShowAll = 1,
            nameplateShowEnemyMinions = 0,
            nameplateShowEnemyGuardians = 0,
            nameplateShowEnemyMinus = 0,
            nameplateShowEnemyPets = 0,
            nameplateShowFriendlyMinions = 0,
            nameplateShowFriendlyGuardians = 0,
            nameplateShowFriendlyNPCs = 1,
            nameplateShowFriendlyPets = 0,
            nameplateShowFriendlyTotems = 0
        }
    }
})

R:RegisterModuleOptions(UF, {
    type = "group",
    name = "Unit Frames",
    args = {
        header = {type = "header", name = R.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if UF.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
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
        theme = {
            type = "group",
            name = "Theme",
            order = 3,
            inline = true,
            args = {
                desc = {
                    order = 1,
                    type = "description",
                    name = "The theme determines the general look and feel of the unit frames. Setting the theme to 'Custom' will allow you to customize every element of every frame, while using a non-custom theme will lock certain most elements in place."
                },
                theme = {
                    type = "select",
                    name = "Theme",
                    desc = "Select the unit frame theme.",
                    order = 2,
                    values = UF.themes,
                    get = function()
                        return UF.themes[UF.config.theme]
                    end,
                    set = function(_, key)
                        UF.config.theme = UF.themes[key]
                        UF:UpdateAll()
                    end
                }
            }
        },
        lineBreak2 = {type = "header", name = "", order = 4},
        fonts = {type = "group", name = "Fonts", order = 6, inline = true, args = {}},
        statusbarTextures = {
            type = "group",
            name = "Status Bar Textures",
            order = 6,
            inline = true,
            args = {
                health = UF:CreateStatusBarTextureOption("Health", "Set the texture to use for health bars.", "health", 1),
                healthPrediction = UF:CreateStatusBarTextureOption("Health Prediction (Healing)",
                                                                   "Set the texture to use for health prediction bars.",
                                                                   "healthPrediction", 2),
                power = UF:CreateStatusBarTextureOption("Power", "Set the texture to use for power bars.", "power", 11),
                powerPrediction = UF:CreateStatusBarTextureOption("Power Prediction (Power Cost)",
                                                                  "Set the texture to use for power prediction bars.",
                                                                  "powerPrediction", 12),
                additionalPower = UF:CreateStatusBarTextureOption("Additional Power", "Set the texture to use for power bars.",
                                                                  "additionalPower", 21),
                additionalPowerPrediction = UF:CreateStatusBarTextureOption("Additional Power Prediction (Power Cost)",
                                                                            "Set the texture to use for additional power prediction bars.",
                                                                            "additionalPowerPrediction", 22),
                castbar = UF:CreateStatusBarTextureOption("Cast Bars", "Set the texture to use for cast bars.", "castbar", 31)
            }
        },
        statusBarColors = {
            type = "group",
            name = "Status Bar Colors",
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
        player = {
            type = "group",
            childGroups = "tab",
            name = "Player",
            order = 12,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Player", order = 0},
                enabled = UF:CreateUnitEnabledOption("player", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("player", 1, true),
                        position = UF:CreateUnitPositionOption("player", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("player", 11),
                power = UF:CreateUnitPowerOption("player", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("player", 1), level = UF:CreateUnitLevelOption("player", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("player", 14, false, true)
            }
        },
        target = {
            type = "group",
            childGroups = "tab",
            name = "Target",
            order = 13,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("target", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("target", 1, true),
                        position = UF:CreateUnitPositionOption("target", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("target", 11),
                power = UF:CreateUnitPowerOption("target", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("target", 1), level = UF:CreateUnitLevelOption("target", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("target", 14)
            }
        },
        targettarget = {
            type = "group",
            childGroups = "tab",
            name = "Target's Target",
            order = 14,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Target's Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("targettarget", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("targettarget", 1, true),
                        position = UF:CreateUnitPositionOption("targettarget", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("targettarget", 11),
                power = UF:CreateUnitPowerOption("targettarget", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("targettarget", 1),
                        level = UF:CreateUnitLevelOption("targettarget", 2)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("targettarget", 14)
            }
        },
        pet = {
            type = "group",
            childGroups = "tab",
            name = "Pet",
            order = 15,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Pet", order = 0},
                enabled = UF:CreateUnitEnabledOption("pet", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("pet", 1, true),
                        position = UF:CreateUnitPositionOption("pet", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("pet", 11),
                power = UF:CreateUnitPowerOption("pet", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("pet", 1), level = UF:CreateUnitLevelOption("pet", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("pet", 14)
            }
        },
        focus = {
            type = "group",
            childGroups = "tab",
            name = "Focus Target",
            order = 16,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Focus Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("focus", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("focus", 1, true),
                        position = UF:CreateUnitPositionOption("focus", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("focus", 11),
                power = UF:CreateUnitPowerOption("focus", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("focus", 1), level = UF:CreateUnitLevelOption("focus", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("focus", 14)
            }
        },
        focustarget = {
            type = "group",
            childGroups = "tab",
            name = "Focus Target's Target",
            order = 17,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Focus Target's Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("focustarget", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("focustarget", 1, true),
                        position = UF:CreateUnitPositionOption("focustarget", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("focustarget", 11),
                power = UF:CreateUnitPowerOption("focustarget", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("focustarget", 1), level = UF:CreateUnitLevelOption("focustarget", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("focustarget", 14)
            }
        },
        party = {
            type = "group",
            childGroups = "tab",
            name = "Party",
            order = 18,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Party", order = 0},
                enabled = UF:CreateUnitEnabledOption("party", 1),
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowParty and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the party frames.",
                    func = function()
                        if not UF.forceShowParty then
                            UF:ForceShowParty()
                        else
                            UF:UnforceShowParty()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("party", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 3,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.party.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.party.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("party")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.party.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.party.unitSpacing = val
                                UF:UpdateUnit("party")
                            end
                        },
                        showPlayer = {
                            type = "toggle",
                            name = "Show Player",
                            order = 5,
                            get = function()
                                return UF.config.party.showPlayer
                            end,
                            set = function(_, val)
                                UF.config.party.showPlayer = val
                                UF:UpdateUnit("party")
                            end
                        },
                        showRaid = {
                            type = "toggle",
                            name = "Show in Raid",
                            order = 6,
                            get = function()
                                return UF.config.party.showRaid
                            end,
                            set = function(_, val)
                                UF.config.party.showRaid = val
                                UF:UpdateUnit("party")
                            end
                        },
                        showSolo = {
                            type = "toggle",
                            name = "Show when Solo",
                            order = 7,
                            get = function()
                                return UF.config.party.showSolo
                            end,
                            set = function(_, val)
                                UF.config.party.showSolo = val
                                UF:UpdateUnit("party")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("party", 11),
                power = UF:CreateUnitPowerOption("party", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("party", 1), level = UF:CreateUnitLevelOption("party", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("party", 14)
            }
        },
        raid = {
            type = "group",
            childGroups = "tab",
            name = "Raid",
            order = 19,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Raid", order = 0},
                enabled = UF:CreateUnitEnabledOption("raid", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowRaid and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the raid frames.",
                    func = function()
                        if not UF.forceShowRaid then
                            UF:ForceShowRaid()
                        else
                            UF:UnforceShowRaid()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("raid", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 1,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.raid.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.raid.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("raid")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 2,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.raid.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.raid.unitSpacing = val
                                UF:UpdateUnit("raid")
                            end
                        },
                        groupAnchorPoint = {
                            type = "select",
                            name = "Group Anchor Point",
                            order = 3,
                            values = UF.groupAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.groupAnchors) do
                                    if UF.config.raid.groupAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.raid.groupAnchorPoint = UF.groupAnchors[key]
                                UF:UpdateUnit("raid")
                            end
                        },
                        groupSpacing = {
                            type = "range",
                            name = "Group Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.raid.groupSpacing
                            end,
                            set = function(_, val)
                                UF.config.raid.groupSpacing = val
                                UF:UpdateUnit("raid")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("raid", 11),
                power = UF:CreateUnitPowerOption("raid", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("raid", 1), level = UF:CreateUnitLevelOption("raid", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("raid", 14)
            }
        },
        tank = {
            type = "group",
            childGroups = "tab",
            name = "Tanks",
            order = 20,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Tanks", order = 0},
                enabled = UF:CreateUnitEnabledOption("tank", 1),
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowTanks and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the tank frames.",
                    func = function()
                        if not UF.forceShowTanks then
                            UF:ForceShowTanks()
                        else
                            UF:UnforceShowTanks()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("tank", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 3,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.tank.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.tank.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("tank")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.tank.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.tank.unitSpacing = val
                                UF:UpdateUnit("tank")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("tank", 11),
                power = UF:CreateUnitPowerOption("tank", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("tank", 1), level = UF:CreateUnitLevelOption("tank", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("tank", 14)
            }
        },
        assist = {
            type = "group",
            childGroups = "tab",
            name = "Assist",
            order = 21,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Assist", order = 0},
                enabled = UF:CreateUnitEnabledOption("assist", 1),
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowAssist and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the assist frames.",
                    func = function()
                        if not UF.forceShowAssist then
                            UF:ForceShowAssist()
                        else
                            UF:UnforceShowAssist()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("assist", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 3,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.assist.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.assist.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("assist")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.assist.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.assist.unitSpacing = val
                                UF:UpdateUnit("assist")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("assist", 11),
                power = UF:CreateUnitPowerOption("assist", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("assist", 1), level = UF:CreateUnitLevelOption("assist", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("assist", 14)
            }
        },
        boss = {
            type = "group",
            childGroups = "tab",
            name = "Boss",
            order = 22,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Boss", order = 0},
                enabled = UF:CreateUnitEnabledOption("boss", 1),
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowBoss and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the boss frames.",
                    func = function()
                        if not UF.forceShowBoss then
                            UF:ForceShowBoss()
                        else
                            UF:UnforceShowBoss()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("boss", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 3,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.boss.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.boss.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("boss")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.boss.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.boss.unitSpacing = val
                                UF:UpdateUnit("boss")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("boss", 11),
                power = UF:CreateUnitPowerOption("boss", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("boss", 1), level = UF:CreateUnitLevelOption("boss", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("boss", 14)
            }
        },
        arena = {
            type = "group",
            childGroups = "tab",
            name = "Arena",
            order = 23,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Arena", order = 0},
                enabled = UF:CreateUnitEnabledOption("arena", 1),
                forceShow = {
                    order = 3,
                    type = "execute",
                    name = function()
                        return UF.forceShowArena and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the arena frames.",
                    func = function()
                        if not UF.forceShowArena then
                            UF:ForceShowArena()
                        else
                            UF:UnforceShowArena()
                        end
                    end
                },
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("arena", 1, true),
                        lineBreak1 = {type = "header", name = "", order = 2},
                        unitAnchorPoint = {
                            type = "select",
                            name = "Unit Anchor Point",
                            order = 3,
                            values = UF.unitAnchors,
                            get = function()
                                for key, anchor in ipairs(UF.unitAnchors) do
                                    if UF.config.arena.unitAnchorPoint == anchor then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                UF.config.arena.unitAnchorPoint = UF.unitAnchors[key]
                                UF:UpdateUnit("arena")
                            end
                        },
                        unitSpacing = {
                            type = "range",
                            name = "Unit Spacing",
                            order = 4,
                            min = 0,
                            softMax = 50,
                            step = 1,
                            get = function()
                                return UF.config.arena.unitSpacing
                            end,
                            set = function(_, val)
                                UF.config.arena.unitSpacing = val
                                UF:UpdateUnit("arena")
                            end
                        }
                    }
                },
                health = UF:CreateUnitHealthOption("arena", 11),
                power = UF:CreateUnitPowerOption("arena", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("arena", 1), level = UF:CreateUnitLevelOption("arena", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("arena", 14)
            }
        },
        nameplates = {
            type = "group",
            childGroups = "tab",
            name = "Nameplates",
            order = 24,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Nameplates", order = 0},
                enabled = UF:CreateUnitEnabledOption("nameplates", 1),
                layout = {
                    type = "group",
                    name = "Layout",
                    order = 10,
                    args = {size = UF:CreateUnitSizeOption("nameplates", 1, true)}
                },
                health = UF:CreateUnitHealthOption("nameplates", 11),
                power = UF:CreateUnitPowerOption("nameplates", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {name = UF:CreateUnitNameOption("nameplates", 1), level = UF:CreateUnitLevelOption("nameplates", 2)}
                },
                castbar = UF:CreateUnitCastbarOption("nameplates", 14)
            }
        }
    }
})
