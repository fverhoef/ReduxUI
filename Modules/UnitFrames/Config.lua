local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.themes = {Blizzard = "Blizzard", Blizzard_LargeHealth = "Blizzard_LargeHealth"}
UF.anchorPoints = {"TOPLEFT", "TOP", "TOPRIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT", "CENTER"}
UF.anchors = {
    ["UIParent"] = "UIParent",
    ["Player"] = addonName .. "Player",
    ["Target"] = addonName .. "Target",
    ["Pet"] = addonName .. "Pet"
}
UF.unitAnchors = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
UF.groupAnchors = {"TOP", "BOTTOM", "LEFT", "RIGHT"}
UF.horizontalGrowthDirections = {"LEFT", "RIGHT"}
UF.verticalGrowthDirections = {"UP", "DOWN"}
UF.groupUnits = {["party"] = true, ["raid"] = true, ["assist"] = true, ["tank"] = true}

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
                name = "General",
                order = 9,
                args = {
                    size = UF:CreateUnitSizeOption(unit, 1, true),
                    border = UF:CreateUnitBorderOption(unit, 10, true),
                    artwork = UF:CreateUnitArtworkOption(unit, 11, true),
                    highlight = UF:CreateUnitHighlightOption(unit, 14, true)
                }
            },
            elements = {
                type = "group",
                name = "Elements",
                order = 10,
                args = {
                    health = UF:CreateUnitHealthOption(unit, 1),
                    power = UF:CreateUnitPowerOption(unit, 2),
                    castbar = UF:CreateUnitCastbarOption(unit, 3, false, unit == "player")
                }
            },
            texts = {
                type = "group",
                name = "Texts",
                order = 15,
                args = {
                    name = UF:CreateUnitNameOption(unit, 1),
                    health = UF:CreateUnitHealthValueOption(unit, 2),
                    power = UF:CreateUnitPowerValueOption(unit, 3),
                    level = UF:CreateUnitLevelOption(unit, 4),
                    combatfeedback = UF:CreateUnitCombatFeedbackOption(unit, 5)
                }
            },
            indicators = UF:CreateUnitIndicatorsOption(unit, 16),
            auras = UF:CreateUnitAurasOptions(unit, 17)
        }
    }

    if unit ~= "nameplates" then
        options.args.general.args.position = UF:CreateUnitPositionOption(unit, 2, true)
        options.args.elements.args.portrait = UF:CreateUnitPortraitOption(unit, 4)
    end

    if UF.groupUnits[unit] then
        options.args.forceShow = {
            order = 2,
            type = "execute",
            name = function()
                return UF.headers[unit].forceShow and "Hide Frames" or "Show Frames"
            end,
            desc = "Forcibly show/hide the " .. unit .. " frames.",
            func = function()
                if not UF.headers[unit].forceShow then
                    UF.headers[unit]:ForceShow()
                else
                    UF.headers[unit]:UnforceShow()
                end
            end
        }

        options.args.general.args.layout = {
            type = "group",
            name = "Layout",
            order = 3,
            inline = true,
            args = {
                desc = {
                    type = "description",
                    name = "These options control how each unit is positioned within the group.",
                    order = 0
                },
                unitAnchorPoint = {
                    type = "select",
                    name = "Unit Anchor Point",
                    order = 1,
                    values = UF.unitAnchors,
                    get = function()
                        for key, anchor in ipairs(UF.unitAnchors) do
                            if UF.config[unit].unitAnchorPoint == anchor then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config[unit].unitAnchorPoint = UF.unitAnchors[key]
                        UF:UpdateUnit(unit)
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
                    name = "Group Anchor Point",
                    order = 4,
                    hidden = unit ~= "raid",
                    values = UF.groupAnchors,
                    get = function()
                        for key, anchor in ipairs(UF.groupAnchors) do
                            if UF.config[unit].groupAnchorPoint == anchor then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config[unit].groupAnchorPoint = UF.groupAnchors[key]
                        UF:UpdateUnit(unit)
                    end
                },
                groupSpacing = {
                    type = "range",
                    name = "Group Spacing",
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
                    name = "Show Player",
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
                    name = "Show in Raid",
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
                    name = "Show when Solo",
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
        name = "Enabled",
        order = order,
        width = width,
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
            desc = {
                type = "description",
                name = "Frame and header positions can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand.",
                order = 1
            },
            point = {
                type = "select",
                name = "Point",
                desc = "The point on the frame to attach to the anchor.",
                order = 11,
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
                order = 12,
                values = UF.anchors,
                hidden = true,
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
                order = 13,
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
                name = "Offset (Y)",
                desc = "The vertical offset from the anchor point.",
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

function UF:CreateUnitArtworkOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Artwork",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].artwork.enabled
                end,
                set = function(_, val)
                    UF.config[unit].artwork.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakBackground = {type = "description", name = "", order = 10},
            background = {
                type = "group",
                name = "Background",
                order = 11,
                inline = true,
                args = {
                    texture = {
                        name = "Texture",
                        type = "input",
                        desc = "The path to the texture to use.",
                        order = 1,
                        width = "full",
                        get = function()
                            return UF.config[unit].artwork.background.texture
                        end,
                        set = function(_, val)
                            UF.config[unit].artwork.background.texture = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    color = {
                        type = "color",
                        name = "Color",
                        order = 5,
                        hasAlpha = true,
                        get = function()
                            local color = UF.config[unit].artwork.background.color
                            return color[1], color[2], color[3], color[4] or 1
                        end,
                        set = function(_, r, g, b, a)
                            local color = UF.config[unit].artwork.background.color
                            color[1] = r
                            color[2] = g
                            color[3] = b
                            color[4] = a or 1
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            }
        }
    }
end

function UF:CreateUnitHealthOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Health Bar",
        order = order,
        inline = inline,
        args = {
            desc = {
                order = 1,
                type = "description",
                name = "NOTE: The size of the health bar for a unit always matches the frame size; to resize it, adjust the size of the frame (or add padding below)."
            },
            padding = {
                type = "group",
                name = "Padding",
                order = 2,
                inline = true,
                args = {
                    paddingLeft = {
                        type = "range",
                        name = "Left",
                        order = 1,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[1]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[1] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingRight = {
                        type = "range",
                        name = "Right",
                        order = 2,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingTop = {
                        type = "range",
                        name = "Top",
                        order = 3,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[3]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[3] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingBottom = {
                        type = "range",
                        name = "Bottom",
                        order = 4,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[4]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[4] = val
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            }
        }
    }
end

function UF:CreateUnitHealthValueOption(unit, order, inline, name)
    return {
        type = "group",
        name = name or "Health",
        order = order,
        inline = inline,
        args = {
            enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function()
                    return UF.config[unit].health.value.enabled
                end,
                set = function(_, val)
                    UF.config[unit].health.value.enabled = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakPoint = {type = "header", name = "Position", order = 2},
            point = {
                type = "select",
                name = "Point",
                desc = "The anchor point on the text to attach.",
                order = 11,
                values = UF.anchorPoints,
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
                get = function()
                    return UF.config[unit].health.value.point[4]
                end,
                set = function(_, val)
                    UF.config[unit].health.value.point[4] = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreakFont = {type = "header", name = "Font", order = 20},
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
            lineBreakTag = {type = "header", name = "Tag", order = 30},
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
        name = name or "Power Bar",
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
            lineBreakDetached = {type = "description", name = "", order = 2},
            layout = {
                type = "group",
                name = "Layout",
                order = 3,
                inline = true,
                args = {
                    width = {
                        type = "range",
                        name = "Width",
                        desc = "The width of the power bar. Only applicable when the power bar is detached or inset.",
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
                        name = "Height",
                        desc = "The height of the power bar.",
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
                        name = "Detached",
                        desc = "Whether the power bar is detached from the health bar.",
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
                        name = "Inset",
                        desc = "Whether the power bar is displayed as an inset.",
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
                        name = "Inset Point",
                        order = 5,
                        inline = true,
                        hidden = function()
                            return not UF.config[unit].power.inset
                        end,
                        args = {
                            point = {
                                type = "select",
                                name = "Point",
                                desc = "The anchor point on the power bar to attach.",
                                order = 1,
                                values = UF.anchorPoints,
                                get = function()
                                    for key, value in ipairs(UF.anchorPoints) do
                                        if value == UF.config[unit].power.insetPoint[1] then
                                            return key
                                        end
                                    end
                                end,
                                set = function(_, key)
                                    UF.config[unit].power.insetPoint[1] = UF.anchorPoints[key]
                                    UF:UpdateUnit(unit)
                                end
                            },
                            relativePoint = {
                                type = "select",
                                name = "Relative Point",
                                desc = "The point on the frame to attach value text to.",
                                order = 2,
                                values = UF.anchorPoints,
                                get = function()
                                    for key, value in ipairs(UF.anchorPoints) do
                                        if value == UF.config[unit].power.insetPoint[2] then
                                            return key
                                        end
                                    end
                                end,
                                set = function(_, key)
                                    UF.config[unit].power.insetPoint[2] = UF.anchorPoints[key]
                                    UF:UpdateUnit(unit)
                                end
                            },
                            offsetX = {
                                type = "range",
                                name = "Offset (X)",
                                desc = "The horizontal offset from the anchor point.",
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
                                name = "Offset (Y)",
                                desc = "The vertical offset from the anchor point.",
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
            lineBreakPadding = {type = "description", name = "", order = 4},
            padding = {
                type = "group",
                name = "Padding",
                order = 5,
                inline = true,
                args = {
                    paddingLeft = {
                        type = "range",
                        name = "Left",
                        order = 1,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[1]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[1] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingRight = {
                        type = "range",
                        name = "Right",
                        order = 2,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[2]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[2] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingTop = {
                        type = "range",
                        name = "Top",
                        order = 3,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[3]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[3] = val
                            UF:UpdateUnit(unit)
                        end
                    },
                    paddingBottom = {
                        type = "range",
                        name = "Bottom",
                        order = 4,
                        min = 0,
                        softMax = 100,
                        step = 1,
                        width = 2 / 3,
                        get = function()
                            return UF.config[unit].power.padding[4]
                        end,
                        set = function(_, val)
                            UF.config[unit].power.padding[4] = val
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            },
            lineBreak2 = {type = "description", name = "", order = 6},
            powerPrediction = {
                type = "toggle",
                name = "Power Prediction",
                desc = "Whether power prediction is enabled for the player's power bar.",
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
                name = "Energy/Mana Regen Tick",
                desc = "Whether the energy/mana regen tick is enabled for the player's power bar.",
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
                values = UF.anchorPoints,
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
                values = UF.anchorPoints,
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
                values = UF.anchorPoints,
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
            lineBreak1 = {type = "header", name = "Font", order = 2},
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
            lineBreak2 = {type = "header", name = "Display Options", order = 9},
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
            round = {
                type = "toggle",
                name = "Use Round Portrait",
                desc = "Whether the portrait texture is round or square.",
                disabled = function() return UF.config[unit].portrait.model end,
                order = 3,
                get = function()
                    return UF.config[unit].portrait.round
                end,
                set = function(_, val)
                    UF.config[unit].portrait.round = val
                    UF:UpdateUnit(unit)
                end
            },
            class = {
                type = "toggle",
                name = "Use Class Icons",
                desc = "Whether to use class icons for the portrait texture.",
                order = 4,
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
                order = 5,
                get = function()
                    return UF.config[unit].portrait.model
                end,
                set = function(_, val)
                    UF.config[unit].portrait.class = false
                    UF.config[unit].portrait.model = val
                    UF:UpdateUnit(unit)
                end
            },
            lineBreak1 = {type = "description", name = "", order = 2},
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
                values = UF.anchorPoints,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].portrait.point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].portrait.point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 22,
                values = UF.anchorPoints,
                hidden = function()
                    return not UF.config[unit].portrait.detached
                end,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].portrait.point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].portrait.point[2] = UF.anchorPoints[key]
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
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].auras[setting].point[1] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].auras[setting].point[1] = UF.anchorPoints[key]
                    UF:UpdateUnit(unit)
                end
            },
            relativePoint = {
                type = "select",
                name = "Relative Point",
                desc = "The point on the unit frame to attach to.",
                order = 22,
                values = UF.anchorPoints,
                get = function()
                    for key, value in ipairs(UF.anchorPoints) do
                        if value == UF.config[unit].auras[setting].point[2] then
                            return key
                        end
                    end
                end,
                set = function(_, key)
                    UF.config[unit].auras[setting].point[2] = UF.anchorPoints[key]
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
    theme = nil,
    lockTheme = false,
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
        targetHighlight = {1, 1, 1, 1},
        colorHealthClass = true,
        colorHealthSmooth = false,
        colorHealthDisconnected = true,
        colorPowerClass = false,
        colorPowerSmooth = false,
        colorPowerDisconnected = true
    },
    buffFrame = {point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -215, -13}},
    player = {
        enabled = true,
        size = {180, 42},
        scale = 1,
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        frameLevel = 10,
        artwork = {
            enabled = false,
            background = {
                texture = R.media.textures.unitFrames.targetFrame_LargerHealth,
                coords = {1, 0.09375, 0, 0.78125},
                point = {"TOPLEFT", "TOPLEFT", -47, 22},
                size = {232, 100},
                color = {0.5, 0.5, 0.5, 1}
            },
            highlight = {
                texture = R.media.textures.unitFrames.targetFrame_Flash,
                coords = {0.9453125, 0, 0, 0.181640625},
                point = {"TOPLEFT", "TOPLEFT", -33, 22},
                size = {242, 93}
            }
        },
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            detached = true,
            inset = false,
            insetPoint = {"CENTER", "BOTTOM", 0, 0},
            size = {180, 25},
            padding = {0, 0, 0, 0},
            point = {"TOP", "UIParent", "BOTTOM", 0, 300},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {38, 38},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
        },
        combatIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
        restingIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = false,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    target = {
        enabled = true,
        size = {180, 42},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        frameLevel = 10,
        artwork = {
            enabled = false,
            background = {
                texture = R.media.textures.unitFrames.targetFrame_LargerHealth,
                coords = {0.09375, 1, 0, 0.78125},
                point = {"TOPRIGHT", "TOPRIGHT", 47, 22},
                size = {232, 100},
                color = {0.5, 0.5, 0.5, 1}
            },
            highlight = {
                texture = R.media.textures.unitFrames.targetFrame_Flash,
                coords = {0, 0.9453125, 0, 0.182},
                point = {"TOPRIGHT", "TOPRIGHT", 33, 22},
                size = {242, 93}
            },
            elite = {
                texture = R.media.textures.unitFrames.targetFrame_Elite,
                coords = {0.09375, 1, 0, 0.78125},
                point = {"CENTER", "CENTER", 20, -7},
                size = {232, 100}
            },
            rare = {
                texture = R.media.textures.unitFrames.targetFrame_Rare,
                coords = {0.09375, 1, 0, 0.78125},
                point = {"CENTER", "CENTER", 20, -7},
                size = {232, 100}
            },
            rareElite = {
                texture = R.media.textures.unitFrames.targetFrame_RareElite,
                coords = {0.09375, 1, 0, 0.78125},
                point = {"CENTER", "CENTER", 20, -7},
                size = {232, 100}
            }
        },
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"LEFT", "BOTTOMLEFT", 10, 0},
            size = {122, 12},
            padding = {0, 0, 0, 0},
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
            point = {"LEFT", "RIGHT", -10, 0},
            attachedPoint = "RIGHT",
            size = {38, 38},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = false,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    targettarget = {
        enabled = true,
        size = {95, 30},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "BOTTOM", 340, 300},
        frameLevel = 20,
        artwork = {
            enabled = false,
            background = {
                texture = R.media.textures.unitFrames.targetTargetFrame,
                coords = {0.015625, 0.7265625, 0, 0.703125},
                point = {"CENTER", "CENTER", 0, 0},
                size = {95, 45},
                color = {0.5, 0.5, 0.5, 1}
            },
            highlight = {}
        },
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"CENTER", "BOTTOM", 0, 0},
            size = {60, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
        },
        raidTargetIndicator = {enabled = false, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        auras = {
            enabled = false,
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    pet = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Player", "BOTTOMRIGHT", 34, 5},
        frameLevel = 20,
        artwork = {
            enabled = false,
            background = {
                texture = R.media.textures.unitFrames.smallTargetingFrame,
                coords = {0, 1, 0, 1},
                point = {"TOPLEFT", "TOPLEFT", 0, -2},
                size = {128, 64},
                color = {0.5, 0.5, 0.5, 1}
            },
            highlight = {
                texture = R.media.textures.unitFrames.partyFrame_Flash,
                coords = {0, 1, 0, 1},
                point = {"TOPLEFT", "TOPLEFT", 0, -2},
                size = {128, 64}
            }
        },
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
        },
        combatIndicator = {enabled = false, size = {16, 16}, point = {"CENTER", "RIGHT", 0, 0}},
        raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        auras = {
            enabled = true,
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    focus = {
        enabled = R.isRetail,
        size = {90, 45},
        scale = 1,
        point = {"TOP", "UIParent", "TOP", 0, 300},
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {60, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    focustarget = {
        enabled = R.isRetail,
        size = {90, 30},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        frameLevel = 20,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {60, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
        },
        raidTargetIndicator = {enabled = false, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
        auras = {
            enabled = false,
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {130, 30},
        scale = 1,
        point = {"RIGHT", "UIParent", "BOTTOM", -160, 240},
        frameLevel = 11,
        artwork = {
            enabled = false,
            background = {
                texture = R.media.textures.unitFrames.partyFrame,
                coords = {0, 1, 0, 1},
                point = {"TOPLEFT", "TOPLEFT", 0, -2},
                size = {128, 64},
                color = {0.5, 0.5, 0.5, 1}
            },
            highlight = {
                texture = R.media.textures.unitFrames.partyFrame_Flash,
                coords = {0, 1, 0, 1},
                point = {"TOPLEFT", "TOPLEFT", 0, -2},
                size = {128, 64}
            }
        },
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", -10, 0},
            size = {84, 10},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {26, 26},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 20,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 20,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,

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
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {70, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {36, 36},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
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
        point = {"TOPRIGHT", "UIParent", "BOTTOMRIGHT", 15, 0},
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    tank = {
        enabled = true,
        size = {90, 36},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -200},
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
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
        showPlayer = true,
        showSolo = true,
        showParty = true,
        showRaid = true

        -- visibility = "[group:raid] show"
    },
    assist = {
        enabled = true,
        size = {90, 36},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -400},
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
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
        showPlayer = true,
        showSolo = true,
        showParty = true,
        showRaid = true

        -- visibility = "[group:raid] show"
    },
    arena = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", "UIParent", "BOTTOMRIGHT", 15, 0},
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            point = {"RIGHT", "LEFT", 10, 0},
            attachedPoint = "LEFT",
            size = {42, 42},
            border = {enabled = true, size = 4},
            round = false,
            class = false,
            model = false
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
            buffs = {
                enabled = true,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 25,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetClassColor = true
        },
        border = {enabled = true, size = 4},
        shadow = {enabled = true},
        fader = R.config.faders.onShow
    },
    nameplates = {
        enabled = true,
        size = {150, 16},
        scale = 1,
        frameLevel = 10,
        artwork = {enabled = false, background = {}, highlight = {}},
        health = {
            enabled = true,
            padding = {0, 0, 0, 0},
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
            inset = true,
            insetPoint = {"RIGHT", "BOTTOMRIGHT", 10, 0},
            size = {80, 12},
            padding = {0, 0, 0, 0},
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
            buffs = {
                enabled = false,
                point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
                initialAnchor = "TOPLEFT",
                growthX = "RIGHT",
                growthY = "DOWN",
                iconSize = 32,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 32
            },
            debuffs = {
                enabled = true,
                point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
                initialAnchor = "BOTTOMLEFT",
                growthX = "RIGHT",
                growthY = "UP",
                iconSize = 32,
                spacing = 2,
                numColumns = 5,
                showDuration = true,
                onlyShowPlayer = false,
                num = 16
            }
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
        highlight = {
            enabled = true,
            colorShadow = true,
            colorBorder = true,
            debuffs = true,
            onlyDispellableDebuffs = false,
            threat = true,
            target = true,
            targetArrows = true,
            targetClassColor = false
        },
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
                    name = "Themes are presets for the look and feel of unit frames. Select a theme and hit 'Apply' to apply the theme to all frames styled by that theme."
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
                },
                applyTheme = {
                    order = 3,
                    type = "execute",
                    name = "Apply Theme",
                    desc = "Apply the selected theme.",
                    func = function()
                        UF:ApplyTheme()
                    end
                },
                lockTheme = {
                    type = "toggle",
                    name = "Lock Theme",
                    desc = "When checked, locks the theme in place, which means the settings for the theme cannot be overridden.",
                    order = 4,
                    get = function()
                        return UF.config.lockTheme
                    end,
                    set = function(_, val)
                        UF.config.lockTheme = val
                        UF:UpdateAll()
                    end
                }
            }
        },
        fonts = {
            type = "group",
            name = "Fonts",
            order = 5,
            inline = true,
            args = {
                font = {
                    name = "Default Font Family",
                    type = "select",
                    desc = "The default font family for unit frame texts.",
                    order = 1,
                    dialogControl = "LSM30_Font",
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                            if UF.config.font == font then
                                return key
                            end
                        end
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
        boss = UF:CreateUnitOptions("boss", 20, false, "Boss", R.isClassic),
        arena = UF:CreateUnitOptions("arena", 21, false, "Arena", R.isClassic),
        nameplates = UF:CreateUnitOptions("nameplates", 22, false, "Nameplates")
    }
})
