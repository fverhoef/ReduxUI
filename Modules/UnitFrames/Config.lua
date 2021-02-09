local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.themes = {Blizzard = "Blizzard", Blizzard_LargeHealth = "Blizzard_LargeHealth", Custom = "Custom"}
UF.anchorPoints = {"TOPLEFT", "TOP", "TOPRIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT"}
UF.anchors = {"UIParent"}
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
                    UF:UpdateAll()
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
                    UF:UpdateAll()
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
                    UF:UpdateAll()
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
                    UF.config[unit].size[4] = val
                    UF:UpdateAll()
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
                    UF.config[unit].size[5] = val
                    UF:UpdateAll()
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
                    UF:UpdateAll()
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
                    UF:UpdateAll()
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
                    UF:UpdateAll()
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
            height = {
                type = "range",
                name = "Height",
                desc = "The height of the unit's health bar. Note the width is always equal to the frame's width.",
                order = 1,
                min = 1,
                softMax = 400,
                step = 1,
                get = function()
                    return UF.config[unit].health.height
                end,
                set = function(_, val)
                    UF.config[unit].health.height = val
                    UF:UpdateAll()
                end
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
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = true, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 13},
        portrait = {enabled = true, detached = false, attachedPoint = "LEFT", size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {250, 25},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = true,
            borderSize = 12,
            fontSize = 12
        },
        combatfeedback = {enabled = true},
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    target = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = true, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 13},
        portrait = {enabled = true, detached = false, attachedPoint = "RIGHT", size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            showDuration = true,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {113, 15},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = true},
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    targettarget = {
        enabled = true,
        size = {93, 45},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Target", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 11},
        portrait = {enabled = false, detached = false, attachedPoint = "LEFT", size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 11},
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            showDuration = false,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = true},
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focus = {
        enabled = R.isRetail,
        size = {93, 45},
        scale = 1,
        point = {"TOP", "UIParent", "TOP", 0, 300},
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 11},
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            showDuration = true,
            numBuffs = 16,
            onlyShowPlayerBuffs = false,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true
        },
        castbar = {
            enabled = true,
            size = {113, 15},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = true},
        auraHighlight = {enabled = true, glow = true, border = true},
        border = {enabled = true, size = 12},
        shadow = {enabled = true},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focustarget = {
        enabled = R.isRetail,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 11},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 11},
        portrait = {enabled = true, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            showDuration = true,
            numBuffs = 16,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true,
            iconSize = 16
        },
        castbar = {
            enabled = true,
            size = {89, 15},
            showIcon = true,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = true, fontSize = 14},
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
            height = 6,
            value = {enabled = true, point = {"TOP", 0, -20}, fontSize = 11, tag = "[curhp_status]"}
        },
        power = {enabled = true, detached = false, size = {150, 8}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 12},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = true, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {enabled = false},
        castbar = {enabled = false},
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 6, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = false,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = false,
            size = {89, 15},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {enabled = false},
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
        health = {enabled = true, height = 16, value = {enabled = true, tag = "[curhp_status]"}},
        power = {enabled = false, detached = false, size = {150, 12}, value = {enabled = false, tag = "[curpp]"}},
        name = {enabled = true, fontSize = 13},
        portrait = {enabled = false, detached = false, size = {42, 42}},
        leaderIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        assistantIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        masterLooterIndicator = {enabled = false, size = {16, 16}, point = {"TOP", 0, 0}},
        auras = {
            enabled = true,
            showDuration = true,
            numBuffs = 0,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = true,
            showDebuffsOnTop = false
        },
        castbar = {
            enabled = true,
            size = {150, 12},
            showIcon = false,
            showIconOutside = false,
            showSafeZone = false,
            borderSize = 12
        },
        combatfeedback = {
            enabled = false,
            ignoreImmune = true,
            ignoreDamage = true,
            ignoreHeal = false,
            ignoreEnergize = true,
            ignoreOther = true
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
                    order = 3,
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
        statusbarTextures = {
            type = "group",
            name = "Status Bar Textures",
            order = 5,
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
            order = 6,
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
            order = 7,
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
            name = "Player",
            order = 12,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Player", order = 0},
                enabled = UF:CreateUnitEnabledOption("player", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("player", 10, true),
                position = UF:CreateUnitPositionOption("player", 11, true),
                health = UF:CreateUnitHealthOption("player", 12, true)
            }
        },
        target = {
            type = "group",
            name = "Target",
            order = 13,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("target", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("target", 10, true),
                position = UF:CreateUnitPositionOption("target", 11, true),
                health = UF:CreateUnitHealthOption("target", 12, true)
            }
        },
        targettarget = {
            type = "group",
            name = "Target's Target",
            order = 14,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Target's Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("targettarget", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("targettarget", 10, true),
                position = UF:CreateUnitPositionOption("targettarget", 11, true),
                health = UF:CreateUnitHealthOption("targettarget", 12, true)
            }
        },
        pet = {
            type = "group",
            name = "Pet",
            order = 15,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Pet", order = 0},
                enabled = UF:CreateUnitEnabledOption("pet", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("pet", 10, true),
                position = UF:CreateUnitPositionOption("pet", 11, true),
                health = UF:CreateUnitHealthOption("pet", 12, true)
            }
        },
        focus = {
            type = "group",
            name = "Focus Target",
            order = 16,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Focus Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("focus", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("focus", 10, true),
                position = UF:CreateUnitPositionOption("focus", 11, true),
                health = UF:CreateUnitHealthOption("focus", 12, true)
            }
        },
        focustarget = {
            type = "group",
            name = "Focus Target's Target",
            order = 17,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Focus Target's Target", order = 0},
                enabled = UF:CreateUnitEnabledOption("focustarget", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("focustarget", 10, true),
                position = UF:CreateUnitPositionOption("focustarget", 11, true),
                health = UF:CreateUnitHealthOption("focustarget", 12, true)
            }
        },
        party = {
            type = "group",
            name = "Party",
            order = 18,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Party", order = 0},
                enabled = UF:CreateUnitEnabledOption("party", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
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
                    order = 4,
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
                                UF:UpdatePartyHeader()
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
                                UF:UpdatePartyHeader()
                            end
                        }
                    }
                },
                size = UF:CreateUnitSizeOption("party", 10, true),
                position = UF:CreateUnitPositionOption("party", 11, true),
                health = UF:CreateUnitHealthOption("party", 12, true),
                showPlayer = {
                    type = "toggle",
                    name = "Show Player",
                    order = 20,
                    get = function()
                        return UF.config.party.showPlayer
                    end,
                    set = function(_, val)
                        UF.config.party.showPlayer = val
                        UF:UpdatePartyHeader()
                    end
                },
                showRaid = {
                    type = "toggle",
                    name = "Show in Raid",
                    order = 21,
                    get = function()
                        return UF.config.party.showRaid
                    end,
                    set = function(_, val)
                        UF.config.party.showRaid = val
                        UF:UpdatePartyHeader()
                    end
                },
                showSolo = {
                    type = "toggle",
                    name = "Show when Solo",
                    order = 22,
                    get = function()
                        return UF.config.party.showSolo
                    end,
                    set = function(_, val)
                        UF.config.party.showSolo = val
                        UF:UpdatePartyHeader()
                    end
                }
            }
        },
        raid = {
            type = "group",
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
                    order = 4,
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
                                UF:UpdateRaidHeader()
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
                                UF:UpdateRaidHeader()
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
                                UF:UpdateRaidHeader()
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
                                UF:UpdateRaidHeader()
                            end
                        }
                    }
                },
                size = UF:CreateUnitSizeOption("raid", 10, true, "Unit Size"),
                position = UF:CreateUnitPositionOption("raid", 11, true),
                health = UF:CreateUnitHealthOption("raid", 12, true)
            }
        },
        tank = {
            type = "group",
            name = "Tanks",
            order = 20,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Tanks", order = 0},
                enabled = UF:CreateUnitEnabledOption("tank", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("tank", 10, true),
                position = UF:CreateUnitPositionOption("tank", 11, true),
                health = UF:CreateUnitHealthOption("tank", 12, true)
            }
        },
        assist = {
            type = "group",
            name = "Assist",
            order = 21,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Assist", order = 0},
                enabled = UF:CreateUnitEnabledOption("assist", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("assist", 10, true),
                position = UF:CreateUnitPositionOption("assist", 11, true),
                health = UF:CreateUnitHealthOption("assist", 12, true)
            }
        },
        boss = {
            type = "group",
            name = "Boss",
            order = 22,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Boss", order = 0},
                enabled = UF:CreateUnitEnabledOption("boss", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("boss", 10, true),
                position = UF:CreateUnitPositionOption("boss", 11, true),
                health = UF:CreateUnitHealthOption("boss", 12, true)
            }
        },
        arena = {
            type = "group",
            name = "Arena",
            order = 23,
            hidden = R.isClassic,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Arena", order = 0},
                enabled = UF:CreateUnitEnabledOption("arena", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("arena", 10, true),
                position = UF:CreateUnitPositionOption("arena", 11, true),
                health = UF:CreateUnitHealthOption("arena", 12, true)
            }
        },
        nameplates = {
            type = "group",
            name = "Nameplates",
            order = 24,
            args = {
                header = {type = "header", name = R.title .. " > Unit Frames: Nameplates", order = 0},
                enabled = UF:CreateUnitEnabledOption("nameplates", 1),
                lineBreak1 = {type = "header", name = "", order = 2},
                size = UF:CreateUnitSizeOption("nameplates", 10, true),
                health = UF:CreateUnitHealthOption("nameplates", 11, true)
            }
        }
    }
})
