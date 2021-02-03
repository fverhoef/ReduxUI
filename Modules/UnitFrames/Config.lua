local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.themes = {Blizzard = "Blizzard", Blizzard_LargeHealth = "Blizzard_LargeHealth", Custom = "Custom"}

function UF:IsBlizzardTheme()
    return R.config.db.profile.modules.unitFrames.theme == UF.themes.Blizzard or R.config.db.profile.modules.unitFrames.theme ==
               UF.themes.Blizzard_LargeHealth
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
                if R.config.db.profile.modules.unitFrames.statusbars[option] == texture then
                    return key
                end
            end
        end,
        set = function(_, key)
            R.config.db.profile.modules.unitFrames.statusbars[option] = R.Libs.SharedMedia:Fetch("statusbar", key)
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
            local color = R.config.db.profile.modules.unitFrames.colors[option]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = R.config.db.profile.modules.unitFrames.colors[option]
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
            local color = R.config.db.profile.modules.unitFrames.colors.class[class]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = R.config.db.profile.modules.unitFrames.colors.class[class]
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
            return R.config.db.profile.modules.unitFrames[unit].enabled
        end,
        set = function(_, val)
            R.config.db.profile.modules.unitFrames[unit].enabled = val
            ReloadUI()
        end
    }
end

function UF:CreateUnitSizeOption(unit, order, inline)
    return {
        type = "group",
        name = "Size",
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
                    return R.config.db.profile.modules.unitFrames[unit].size[1]
                end,
                set = function(_, val)
                    R.config.db.profile.modules.unitFrames[unit].size[1] = val
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
                    return R.config.db.profile.modules.unitFrames[unit].size[2]
                end,
                set = function(_, val)
                    R.config.db.profile.modules.unitFrames[unit].size[2] = val
                    UF:UpdateAll()
                end
            }
        }
    }
end

function UF:CreateUnitHealthOption(unit, order, inline)
    return {
        type = "group",
        name = "Health",
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
                    return R.config.db.profile.modules.unitFrames[unit].health.height
                end,
                set = function(_, val)
                    R.config.db.profile.modules.unitFrames[unit].health.height = val
                    UF:UpdateAll()
                end
            }
        }
    }
end

R.config.defaults.profile.modules.unitFrames = {
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
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    target = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    targettarget = {
        enabled = true,
        size = {93, 45},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Target", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    pet = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Player", "BOTTOMRIGHT", 34, 5},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focus = {
        enabled = R.isRetail,
        size = {93, 45},
        scale = 1,
        point = {"TOP", "UIParent", "TOP", 0, 300},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    focustarget = {
        enabled = R.isRetail,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {105, 30},
        scale = 1,
        point = {"BOTTOM", "UIParent", "BOTTOM", -550, 320},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        auraHighlight = {enabled = true, mode = "GLOW"},
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1},

        xOffset = 0,
        yOffset = 50,
        showPlayer = false,
        showSolo = false,
        showInRaid = false
    },
    raid = {
        enabled = true,
        size = {90, 36},
        scale = 1,
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -20},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 8}, value = {tag = "[curpp]"}},
        portrait = {enabled = false},
        auras = {enabled = false},
        castbar = {enabled = false},
        combatfeedback = {enabled = false},
        auraHighlight = {enabled = true, mode = "GLOW"},
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,

        unitAnchorPoint = "TOP",
        xOffset = 0,
        yOffset = 0,
        columnSpacing = 0,
        columnAnchorPoint = "LEFT",
        maxColumns = 5,
        unitsPerColumn = 1,
        groupBy = "GROUP", -- GROUP, CLASS, ROLE
        groupingOrder = "1,2,3,4,5,6,7,8",
        sortMethod = "INDEX", -- NAME, INDEX
        sortDir = "ASC", -- ASC, DESC
        showPlayer = false,
        showSolo = false,
        showParty = false,
        showRaid = true,

        --visibility = "[group:raid] show"
    },
    boss = {
        enabled = R.isRetail,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    tank = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    assist = {
        enabled = true,
        size = {175, 42},
        scale = 1,
        point = {"TOPRIGHT", addonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {enabled = true, height = 6, value = {tag = "[curhp_status]"}},
        power = {enabled = true, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = true},
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
        border = {enabled = true, size = 12},
        fader = R.config.faders.onShow,
        texture = nil,
        textureColor = {0.5, 0.5, 0.5, 1}
    },
    nameplates = {
        enabled = true,
        size = {150, 16},
        health = {enabled = true, height = 16, value = {tag = "[curhp_status]"}},
        power = {enabled = false, detached = false, size = {150, 12}, value = {tag = "[curpp]"}},
        portrait = {enabled = false},
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
        border = {enabled = true, size = 12},
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
}

R.config.options.args.unitFrames = {
    type = "group",
    name = "Unit Frames",
    order = 14,
    args = {
        header = {type = "header", name = R.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.unitFrames.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.unitFrames.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.unitFrames.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.UnitFrames:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2},
        theme = {
            type = "select",
            name = "Theme",
            desc = "Select the unit frame theme.",
            order = 3,
            values = UF.themes,
            get = function()
                return UF.themes[R.config.db.profile.modules.unitFrames.theme]
            end,
            set = function(_, key)
                R.config.db.profile.modules.unitFrames.theme = UF.themes[key]
                UF:UpdateAll()
            end
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
                health = UF:CreateStatusBarColorOption("Health", "health", 1),
                mana = UF:CreateStatusBarColorOption("Mana", "mana", 2),
                rage = UF:CreateStatusBarColorOption("Rage", "rage", 3),
                energy = UF:CreateStatusBarColorOption("Energy", "energy", 4),
                focus = UF:CreateStatusBarColorOption("Focus", "focus", 5),
                comboPoints = UF:CreateStatusBarColorOption("Combo Points", "comboPoints", 6),
                castbar = UF:CreateStatusBarColorOption("Castbar", "castbar", 7),
                castbar_Shielded = UF:CreateStatusBarColorOption("Castbar (Shielded)", "castbar_Shielded", 8),
                lineBreak1 = {type = "header", name = "", order = 15},
                colorHealthClass = {
                    type = "toggle",
                    name = "Color Health by Class",
                    order = 20,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorHealthClass
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorHealthClass = val
                        UF:UpdateAll()
                    end
                },
                colorHealthSmooth = {
                    type = "toggle",
                    name = "Color Health by Value",
                    order = 21,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorHealthSmooth
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorHealthSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorHealthDisconnected = {
                    type = "toggle",
                    name = "Color Health when Disconnected",
                    order = 22,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorHealthDisconnected
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorHealthDisconnected = val
                        UF:UpdateAll()
                    end
                },
                colorPowerClass = {
                    type = "toggle",
                    name = "Color Power by Class",
                    order = 30,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorPowerClass
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorPowerClass = val
                        UF:UpdateAll()
                    end
                },
                colorPowerSmooth = {
                    type = "toggle",
                    name = "Color Power by Value",
                    order = 31,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorPowerSmooth
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorPowerSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorPowerDisconnected = {
                    type = "toggle",
                    name = "Color Power when Disconnected",
                    order = 32,
                    get = function()
                        return R.config.db.profile.modules.unitFrames.colors.colorPowerDisconnected
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.unitFrames.colors.colorPowerDisconnected = val
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
                deathKnight = UF:CreateClassColorOption("DEATHKNIGHT", R:LocalizedClassName("Death Knight"), 0, R.isClassic),
                demonHunter = UF:CreateClassColorOption("DEMONHUNTER", R:LocalizedClassName("Demon Hunter"), 1, R.isClassic),
                druid = UF:CreateClassColorOption("DRUID", R:LocalizedClassName("Druid"), 2),
                hunter = UF:CreateClassColorOption("HUNTER", R:LocalizedClassName("Hunter"), 3),
                mage = UF:CreateClassColorOption("MAGE", R:LocalizedClassName("Mage"), 4),
                monk = UF:CreateClassColorOption("MONK", R:LocalizedClassName("Monk"), 5, R.isClassic),
                paladin = UF:CreateClassColorOption("PALADIN", R:LocalizedClassName("Paladin"), 6),
                priest = UF:CreateClassColorOption("PRIEST", R:LocalizedClassName("Priest"), 7),
                rogue = UF:CreateClassColorOption("ROGUE", R:LocalizedClassName("Rogue"), 8),
                shaman = UF:CreateClassColorOption("SHAMAN", R:LocalizedClassName("Shaman"), 9),
                warlock = UF:CreateClassColorOption("WARLOCK", R:LocalizedClassName("Warlock"), 10),
                warrior = UF:CreateClassColorOption("WARRIOR", R:LocalizedClassName("Warrior"), 11)
            }
        },
        player = {
            type = "group",
            name = "Player",
            order = 12,
            args = {enabled = UF:CreateUnitEnabledOption("player", 0), size = UF:CreateUnitSizeOption("player", 10, true)}
        },
        target = {
            type = "group",
            name = "Target",
            order = 13,
            args = {enabled = UF:CreateUnitEnabledOption("target", 0), size = UF:CreateUnitSizeOption("target", 10, true)}
        },
        targettarget = {
            type = "group",
            name = "Target's Target",
            order = 14,
            args = {
                enabled = UF:CreateUnitEnabledOption("targettarget", 0),
                size = UF:CreateUnitSizeOption("targettarget", 10, true)
            }
        },
        pet = {
            type = "group",
            name = "Pet",
            order = 15,
            args = {enabled = UF:CreateUnitEnabledOption("pet", 0), size = UF:CreateUnitSizeOption("pet", 10, true)}
        },
        focus = {
            type = "group",
            name = "Focus Target",
            order = 16,
            hidden = R.isClassic,
            args = {enabled = UF:CreateUnitEnabledOption("focus", 0), size = UF:CreateUnitSizeOption("focus", 10, true)}
        },
        focustarget = {
            type = "group",
            name = "Focus Target's Target",
            order = 17,
            hidden = R.isClassic,
            args = {
                enabled = UF:CreateUnitEnabledOption("focustarget", 0),
                size = UF:CreateUnitSizeOption("focustarget", 10, true)
            }
        },
        party = {
            type = "group",
            name = "Party",
            order = 18,
            args = {enabled = UF:CreateUnitEnabledOption("party", 0), size = UF:CreateUnitSizeOption("party", 10, true)}
        },
        raid = {
            type = "group",
            name = "Raid",
            order = 19,
            args = {
                enabled = UF:CreateUnitEnabledOption("raid", 0),
                lineBreak1 = {type = "header", name = "", order = 1},
                forceShow = {
                    order = 2,
                    type = "execute",
                    name = "Force Show/Hide",
                    desc = "Forcibly show/hide the raid frames.",
                    func = function()
                        if not UF.forceShowRaid then
                            UF:ForceShowRaid()
                        else
                            UF:UnforceShowRaid()
                        end
                    end
                },
                size = UF:CreateUnitSizeOption("raid", 10, true)
            }
        },
        tank = {
            type = "group",
            name = "Tanks",
            order = 20,
            args = {enabled = UF:CreateUnitEnabledOption("tank", 0), size = UF:CreateUnitSizeOption("tank", 10, true)}
        },
        assist = {
            type = "group",
            name = "Assist",
            order = 21,
            args = {enabled = UF:CreateUnitEnabledOption("assist", 0), size = UF:CreateUnitSizeOption("assist", 10, true)}
        },
        boss = {
            type = "group",
            name = "Boss",
            order = 22,
            hidden = R.isClassic,
            args = {enabled = UF:CreateUnitEnabledOption("boss", 0), size = UF:CreateUnitSizeOption("boss", 10, true)}
        },
        nameplates = {
            type = "group",
            name = "Nameplates",
            order = 23,
            args = {enabled = UF:CreateUnitEnabledOption("nameplates", 0), size = UF:CreateUnitSizeOption("nameplates", 10, true)}
        }
    }
}
