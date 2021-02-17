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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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

function UF:CreateUnitBorderOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Border",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].border.enabled
                end,
                set = function(_, val)
                    UF.config[unit].border.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            size = {
                type = "range",
                name = "Size",
                order = 2,
                min = 1,
                softMax = 20,
                step = 1,
                get = function()
                    return UF.config[unit].border.size
                end,
                set = function(_, val)
                    UF.config[unit].border.size = val
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
            value = {
                type = "group",
                name = "Value",
                inline = true,
                order = 10,
                args = {
                    point = {
                        type = "select",
                        name = "Point",
                        desc = "The anchor point on the text to attach.",
                        order = 11,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                    relativePoint = {
                        type = "select",
                        name = "Relative Point",
                        desc = "The point on the health bar to attach value text to.",
                        order = 12,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].health.value.point[2] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].health.value.point[2] = UF.anchorPoints[key]
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                        name = "Offset (Y)",
                        desc = "The vertical offset from the anchor point.",
                        order = 14,
                        min = -50,
                        softMax = 50,
                        step = 1,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        get = function()
                            return UF.config[unit].health.value.point[4]
                        end,
                        set = function(_, val)
                            UF.config[unit].health.value.point[4] = val
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].power.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].power.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            powerPrediction = {
                type = "toggle",
                name = "Power Prediction",
                desc = "Whether the power prediction is enabled for the player's power bar.",
                order = 13,
                hidden = unit ~= "player",
                get = function()
                    return UF.config[unit].power.powerPrediction
                end,
                set = function(_, val)
                    UF.config[unit].power.powerPrediction = val
                    UF:UpdateUnit(unit)
                end
            },
            powerPrediction = {
                type = "toggle",
                name = "Energy/Mana Regen Tick",
                desc = "Whether the energy/mana regen tick is enabled for the player's power bar.",
                order = 14,
                hidden = unit ~= "player",
                get = function()
                    return UF.config[unit].power.energyManaRegen
                end,
                set = function(_, val)
                    UF.config[unit].power.energyManaRegen = val
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
                    point = {
                        type = "select",
                        name = "Point",
                        desc = "The anchor point on the text string.",
                        order = 11,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].power.value.point[1] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].power.value.point[1] = UF.anchorPoints[key]
                            UF:UpdateUnit(unit)
                        end
                    },
                    relativePoint = {
                        type = "select",
                        name = "Relative Point",
                        desc = "The point on the power bar to attach to.",
                        order = 12,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].power.value.point[2] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].power.value.point[2] = UF.anchorPoints[key]
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        get = function()
                            return UF.config[unit].power.value.point[4]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.value.point[4] = val
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].name.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].name.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "", order = 15},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the name text.",
                order = 16,
                values = UF.anchorPoints,
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 17,
                values = UF.anchorPoints,
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].name.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].name.point[2] = UF.anchorPoints[key]
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].name.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].name.point[4] = val
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].level.size[2]
                end,
                set = function(_, val)
                    UF.config[unit].level.size[2] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "", order = 15},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the level text.",
                order = 16,
                values = UF.anchorPoints,
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 17,
                values = UF.anchorPoints,
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].level.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].level.point[2] = UF.anchorPoints[key]
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
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
                disabled = function()
                    return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                end,
                get = function()
                    return UF.config[unit].level.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].level.point[4] = val
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

function UF:CreateUnitCombatFeedbackOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Combat Feedback",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].combatfeedback.enabled
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "header", name = "", order = 2},
            font = {
                name = "Font Family",
                type = "select",
                desc = "The font family for combat feedback text.",
                order = 3,
                dialogControl = "LSM30_Font",
                values = R.Libs.SharedMedia:HashTable("font"),
                get = function()
                    for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                        if UF.config[unit].combatfeedback.font == font then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].combatfeedback.font = R.Libs.SharedMedia:Fetch("font", key)
                    UF:UpdateUnit(unit)
                end
            },
            fontSize = {
                name = "Font Size",
                type = "range",
                desc = "The size of combat feedback text.",
                order = 4,
                min = R.FONT_MIN_SIZE,
                max = R.FONT_MAX_SIZE,
                step = 1,
                get = function()
                    return UF.config[unit].combatfeedback.fontSize
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.fontSize = val
                    UF:UpdateUnit(unit)
                end
            },
            fontOutline = {
                name = "Font Outline",
                type = "select",
                desc = "The outline style of combat feedback text.",
                order = 5,
                values = R.FONT_OUTLINES,
                get = function()
                    return UF.config[unit].combatfeedback.fontOutline
                end,
                set = function(_, key)
                    UF.config[unit].combatfeedback.fontOutline = key
                    UF:UpdateUnit(unit)
                end
            },
            fontShadow = {
                name = "Font Shadows",
                type = "toggle",
                desc = "Whether to show shadow for combat feedback text.",
                order = 6,
                get = function()
                    return UF.config[unit].combatfeedback.fontShadow
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.fontShadow = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak2 = {type = "header", name = "", order = 9},
            ignoreImmune = {
                type = "toggle",
                name = "Ignore Immune",
                order = 10,
                get = function()
                    return UF.config[unit].combatfeedback.ignoreImmune
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.ignoreImmune = val
                    UF:UpdateUnit(unit)
                end
            },
            ignoreDamage = {
                type = "toggle",
                name = "Ignore Damage",
                order = 11,
                get = function()
                    return UF.config[unit].combatfeedback.ignoreDamage
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.ignoreDamage = val
                    UF:UpdateUnit(unit)
                end
            },
            ignoreHeal = {
                type = "toggle",
                name = "Ignore Healing",
                order = 12,
                get = function()
                    return UF.config[unit].combatfeedback.ignoreHeal
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.ignoreHeal = val
                    UF:UpdateUnit(unit)
                end
            },
            ignoreEnergize = {
                type = "toggle",
                name = "Ignore Energize",
                order = 13,
                get = function()
                    return UF.config[unit].combatfeedback.ignoreEnergize
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.ignoreEnergize = val
                    UF:UpdateUnit(unit)
                end
            },
            ignoreOther = {
                type = "toggle",
                name = "Ignore Other",
                order = 14,
                get = function()
                    return UF.config[unit].combatfeedback.ignoreOther
                end,
                set = function(_, val)
                    UF.config[unit].combatfeedback.ignoreOther = val
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                        name = "Point",
                        desc = "The anchor point on the castbar.",
                        order = 21,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                    relativePoint = {
                        type = "select",
                        name = "Relative Point",
                        desc = "The point on the unit frame to attach to.",
                        order = 22,
                        values = UF.anchorPoints,
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
                        hidden = function()
                            return UF.config[unit].castbar.detached
                        end,
                        get = function()
                            for key, value in ipairs(UF.anchorPoints) do
                                if value == UF.config[unit].castbar.point[2] then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            UF.config[unit].castbar.point[2] = UF.anchorPoints[key]
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                        disabled = function()
                            return UF.themedUnits[unit] and UF:IsBlizzardTheme() or nil
                        end,
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
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit][indicatorName].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit][indicatorName].point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 2,
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit][indicatorName].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit][indicatorName].point[2] = UF.anchorPoints[key]
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
    if not R.isClassic and UF.defaults[unit].pvpClassificationIndicator then
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
    if not R.isClassic and UF.defaults[unit].groupRoleIndicator then
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
    if UF.defaults[unit].offlineIcon then
        args.offlineIcon = UF:CreateUnitIndicatorOption(unit, "offlineIcon", #args, "Offline Icon")
    end

    return indicators
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
    buffFrame = {point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13}},
    player = {
        enabled = true,
        size = {180, 42},
        scale = 1,
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"CENTER", "UIParent", "BOTTOM", 0, 360},
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
                font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
                fontSize = 11,
                fontOutline = "NONE",
                fontShadow = true,
                tag = "[curpp]",
                frequentUpdates = true
            },
            powerPrediction = true,
            energyManaRegen = true
        },
        name = {
            enabled = true,
            size = {155, 10},
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = true,
            detached = false,
            attachedPoint = "LEFT",
            size = {38, 38},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        restingIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
        pvpClassificationIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        resurrectIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "CENTER", 0, 0}},
        summonIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
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
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            detached = true,
            showIcon = true,
            showIconOutside = false,
            showSafeZone = true,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 12,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = true,
            detached = false,
            attachedPoint = "RIGHT",
            size = {38, 38},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        questIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "LEFT", 0, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "RIGHT", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "TOP", 0, 0}},
        summonIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "CENTER", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    targettarget = {
        enabled = true,
        size = {95, 30},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Target", "BOTTOMRIGHT", 15, 0},
        frameLevel = 20,
        health = {
            enabled = true,
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"CENTER", "CENTER", 0, 1},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        raidTargetIndicator = {enabled = false, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 20,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = true,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "RIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = true,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "CENTER", 0, 0}},
        summonIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "CENTER", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 20,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "CENTER",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        raidTargetIndicator = {enabled = false, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {130, 30},
        scale = 1,
        point = {"RIGHT", "UIParent", "BOTTOM", -160, 240},
        frameLevel = 11,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            size = {150, 6},
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "LEFT",
            tag = "[name]"
        },
        level = {
            enabled = true,
            size = {20, 10},
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = true,
            detached = false,
            attachedPoint = "LEFT",
            size = {26, 26},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "CENTER", 0, 0}},
        summonIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "CENTER", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            size = {130, 18},
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = true,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 14,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1},

        unitAnchorPoint = "BOTTOM",
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
        frameLevel = 20,
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"TOP", "TOP", 0, -8},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {36, 36},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "CENTER", 0, 0}},
        summonIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "CENTER", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"LEFT", "RIGHT", 5, 0},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        summonIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"LEFT", "RIGHT", 5, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"TOP", "TOP", 0, -8},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        summonIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"LEFT", "RIGHT", 5, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
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
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"TOP", "TOP", 0, -8},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        summonIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"LEFT", "RIGHT", 5, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    arena = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "NONE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        portrait = {
            enabled = false,
            detached = false,
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4}
        },
        combatIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "LEFT", 0, 0}},
        leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
        groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        pvpIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        pvpClassificationIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        resurrectIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        summonIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        offlineIcon = {enabled = true, size = {40, 40}, point = {"CENTER", "CENTER", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"RIGHT", "LEFT", -5, 0},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        auraHighlight = {enabled = true, glow = true, border = true},
        threat = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    nameplates = {
        enabled = true,
        size = {150, 16},
        scale = 1,
        frameLevel = 10,
        health = {
            enabled = true,
            value = {
                enabled = true,
                point = {"CENTER", "CENTER", 0, 0},
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
            border = {enabled = true, size = 4},
            shadow = {enabled = true},
            value = {
                enabled = false,
                point = {"CENTER", "CENTER", 0, 0},
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
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 2},
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
            point = {"BOTTOMRIGHT", "TOPRIGHT", 0, 2},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 13,
            fontOutline = "OUTLINE",
            fontShadow = true,
            justifyH = "RIGHT",
            tag = "[difficultycolor][level]"
        },
        questIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
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
            point = {"CENTER", "UIParent", "TOP", 0, -160},
            attachedPoint = {"TOP", "BOTTOM", 0, -2},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 4,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "NONE",
            fontShadow = true
        },
        combatfeedback = {
            enabled = false,
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 19,
            fontOutline = "OUTLINE",
            fontShadow = false,
            ignoreImmune = false,
            ignoreDamage = false,
            ignoreHeal = false,
            ignoreEnergize = false,
            ignoreOther = false
        },
        threat = {enabled = true, glow = true, border = true},
        target = {enabled = true, glow = true, border = true, arrows = true},
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,

        showComboPoints = false,
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("player", 1, true),
                        position = UF:CreateUnitPositionOption("player", 2, true),
                        border = UF:CreateUnitBorderOption("player", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("player", 11),
                power = UF:CreateUnitPowerOption("player", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("player", 1),
                        level = UF:CreateUnitLevelOption("player", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("player", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("player", 14, false, true),
                indicators = UF:CreateUnitIndicatorsOption("player", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("target", 1, true),
                        position = UF:CreateUnitPositionOption("target", 2, true),
                        border = UF:CreateUnitBorderOption("target", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("target", 11),
                power = UF:CreateUnitPowerOption("target", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("target", 1),
                        level = UF:CreateUnitLevelOption("target", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("target", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("target", 14),
                indicators = UF:CreateUnitIndicatorsOption("target", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("targettarget", 1, true),
                        position = UF:CreateUnitPositionOption("targettarget", 2, true),
                        border = UF:CreateUnitBorderOption("targettarget", 3, true)
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
                        level = UF:CreateUnitLevelOption("targettarget", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("targettarget", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("targettarget", 14),
                indicators = UF:CreateUnitIndicatorsOption("targettarget", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("pet", 1, true),
                        position = UF:CreateUnitPositionOption("pet", 2, true),
                        border = UF:CreateUnitBorderOption("pet", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("pet", 11),
                power = UF:CreateUnitPowerOption("pet", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("pet", 1),
                        level = UF:CreateUnitLevelOption("pet", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("pet", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("pet", 14),
                indicators = UF:CreateUnitIndicatorsOption("pet", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("focus", 1, true),
                        position = UF:CreateUnitPositionOption("focus", 2, true),
                        border = UF:CreateUnitBorderOption("focus", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("focus", 11),
                power = UF:CreateUnitPowerOption("focus", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("focus", 1),
                        level = UF:CreateUnitLevelOption("focus", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("focus", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("focus", 14),
                indicators = UF:CreateUnitIndicatorsOption("focus", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("focustarget", 1, true),
                        position = UF:CreateUnitPositionOption("focustarget", 2, true),
                        border = UF:CreateUnitBorderOption("focustarget", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("focustarget", 11),
                power = UF:CreateUnitPowerOption("focustarget", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("focustarget", 1),
                        level = UF:CreateUnitLevelOption("focustarget", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("focustarget", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("focustarget", 14),
                indicators = UF:CreateUnitIndicatorsOption("focustarget", 15)
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
                        return UF.headers.party.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the party frames.",
                    func = function()
                        if not UF.headers.party.forceShow then
                            UF.headers.party:ForceShow()
                        else
                            UF.headers.party:UnforceShow()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("party", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                                }
                            }
                        },
                        showPlayer = {
                            type = "toggle",
                            name = "Show Player",
                            order = 3,
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
                            order = 4,
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
                            order = 5,
                            get = function()
                                return UF.config.party.showSolo
                            end,
                            set = function(_, val)
                                UF.config.party.showSolo = val
                                UF:UpdateUnit("party")
                            end
                        },
                        border = UF:CreateUnitBorderOption("party", 6, true)
                    }
                },
                health = UF:CreateUnitHealthOption("party", 11),
                power = UF:CreateUnitPowerOption("party", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("party", 1),
                        level = UF:CreateUnitLevelOption("party", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("party", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("party", 14),
                indicators = UF:CreateUnitIndicatorsOption("party", 15)
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
                        return UF.headers.raid.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the raid frames.",
                    func = function()
                        if not UF.headers.raid.forceShow then
                            UF.headers.raid:ForceShow()
                        else
                            UF.headers.raid:UnforceShow()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("raid", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                        border = UF:CreateUnitBorderOption("raid", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("raid", 11),
                power = UF:CreateUnitPowerOption("raid", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("raid", 1),
                        level = UF:CreateUnitLevelOption("raid", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("raid", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("raid", 14),
                indicators = UF:CreateUnitIndicatorsOption("raid", 15)
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
                        return UF.headers.tank.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the tank frames.",
                    func = function()
                        if not UF.headers.tank.forceShow then
                            UF.headers.tank:ForceShow()
                        else
                            UF.headers.tank:UnforceShow()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("tank", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                        border = UF:CreateUnitBorderOption("tank", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("tank", 11),
                power = UF:CreateUnitPowerOption("tank", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("tank", 1),
                        level = UF:CreateUnitLevelOption("tank", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("tank", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("tank", 14),
                indicators = UF:CreateUnitIndicatorsOption("tank", 15)
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
                        return UF.headers.assist.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the assist frames.",
                    func = function()
                        if not UF.headers.assist.forceShow then
                            UF.headers.assist:ForceShow()
                        else
                            UF.headers.assist:UnforceShow()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("assist", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                        border = UF:CreateUnitBorderOption("assist", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("assist", 11),
                power = UF:CreateUnitPowerOption("assist", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("assist", 1),
                        level = UF:CreateUnitLevelOption("assist", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("assist", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("assist", 14),
                indicators = UF:CreateUnitIndicatorsOption("assist", 15)
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
                        return UF.headers.boss.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the boss frames.",
                    func = function()
                        if not UF.headers.boss.forceShow then
                            UF.headers.boss:ForceShow()
                        else
                            UF.headers.boss:UnforceShow()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("boss", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                        border = UF:CreateUnitBorderOption("boss", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("boss", 11),
                power = UF:CreateUnitPowerOption("boss", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("boss", 1),
                        level = UF:CreateUnitLevelOption("boss", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("boss", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("boss", 14),
                indicators = UF:CreateUnitIndicatorsOption("boss", 15)
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
                        return UF.headers.arena.forceShow and "Hide Frames" or "Show Frames"
                    end,
                    desc = "Forcibly show/hide the arena frames.",
                    func = function()
                        if not UF.headers.arena.forceShow then
                            UF.headers.arena:ForceShow()
                        else
                            UF.headers.arena:UnforceShowArena()
                        end
                    end
                },
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("arena", 1, true),
                        layout = {
                            type = "group",
                            name = "Layout",
                            order = 2,
                            inline = true,
                            args = {
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
                        border = UF:CreateUnitBorderOption("arena", 3, true)
                    }
                },
                health = UF:CreateUnitHealthOption("arena", 11),
                power = UF:CreateUnitPowerOption("arena", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("arena", 1),
                        level = UF:CreateUnitLevelOption("arena", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("arena", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("arena", 14),
                indicators = UF:CreateUnitIndicatorsOption("arena", 15)
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
                general = {
                    type = "group",
                    name = "General",
                    order = 10,
                    args = {
                        size = UF:CreateUnitSizeOption("nameplates", 1, true),
                        border = UF:CreateUnitBorderOption("nameplates", 2, true)
                    }
                },
                health = UF:CreateUnitHealthOption("nameplates", 11),
                power = UF:CreateUnitPowerOption("nameplates", 12),
                texts = {
                    type = "group",
                    name = "Texts",
                    order = 13,
                    args = {
                        name = UF:CreateUnitNameOption("nameplates", 1),
                        level = UF:CreateUnitLevelOption("nameplates", 2),
                        combatfeedback = UF:CreateUnitCombatFeedbackOption("nameplates", 3)
                    }
                },
                castbar = UF:CreateUnitCastbarOption("nameplates", 14),
                indicators = UF:CreateUnitIndicatorsOption("nameplates", 15)
            }
        }
    }
})
