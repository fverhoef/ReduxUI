local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

UF.themes = {Blizzard = "Blizzard", Blizzard_LargeHealth = "Blizzard_LargeHealth", Custom = "Custom"}

Addon.config.defaults.profile.modules.unitFrames = {
    enabled = true,
    font = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbars = {
        health = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        healthPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        power = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        powerPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPower = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPowerPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        castbar = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux")
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
        }
    },
    player = {
        enabled = true,
        size = {175, 42},
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = false, showDuration = true, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {250, 25}, showIcon = true, showIconOutside = false, showSafeZone = true, borderSize = 6, fontSize = 12},
        combatfeedback = {enabled = true},
        fader = Addon.config.faders.onShow
    },
    target = {
        enabled = true,
        size = {175, 42},
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = true, showDuration = true, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {113, 15}, showIcon = true, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true},
        fader = Addon.config.faders.onShow
    },
    targettarget = {
        enabled = true,
        size = {93, 45},
        point = {"TOPRIGHT", AddonName .. "Target", "BOTTOMRIGHT", 15, 0},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = false, showDuration = true, numBuffs = 0, onlyShowPlayerBuffs = true, numDebuffs = 16, onlyShowPlayerDebuffs = true, showDebuffsOnTop = false},
        castbar = {enabled = false, size = {89, 15}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = false},
        fader = Addon.config.faders.onShow
    },
    pet = {
        enabled = true,
        size = {175, 42},
        point = {"TOPRIGHT", AddonName .. "Player", "BOTTOMRIGHT", 34, 5},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = true, showDuration = false, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {89, 15}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true},
        fader = Addon.config.faders.onShow
    },
    focus = {
        enabled = Addon.IsRetail,
        size = {93, 45},
        point = {"TOP", "UIParent", "TOP", 0, 300},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = true, showDuration = true, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {113, 15}, showIcon = true, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true},
        fader = Addon.config.faders.onShow
    },
    focustarget = {
        enabled = Addon.IsRetail,
        size = {175, 42},
        point = {"TOPRIGHT", AddonName .. "Focus", "BOTTOMRIGHT", 15, 0},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = false, showDuration = true, numBuffs = 0, onlyShowPlayerBuffs = true, numDebuffs = 16, onlyShowPlayerDebuffs = true, showDebuffsOnTop = false},
        castbar = {enabled = false, size = {89, 15}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = false},
        fader = Addon.config.faders.onShow
    },
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {105, 30},
        point = {"BOTTOM", "UIParent", "BOTTOM", -550, 320},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
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
        castbar = {enabled = true, size = {89, 15}, showIcon = true, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true, fontSize = 14},
        fader = Addon.config.faders.onShow,

        xOffset = 0,
        yOffset = 50,
        showPlayer = false,
        showSolo = false,
        showInRaid = false
    },
    raid = {
        enabled = true,
        size = {80, 22},
        point = "TOP",
        points = { -- list of 8 points, one for each raid group
            {"TOPLEFT", 20, -20},
            {"TOP", AddonName .. "RaidHeader1", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader2", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader3", "BOTTOM", 0, -10},
            {"TOPLEFT", AddonName .. "RaidHeader1", "TOPRIGHT", 10, 0},
            {"TOP", AddonName .. "RaidHeader5", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader6", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader7", "BOTTOM", 0, -10}
        },
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = false},
        castbar = {enabled = false},
        border = {enabled = true, size = 6},
        fader = Addon.config.faders.onShow,

        scale = 1,
        xOffset = 0,
        yOffset = -5,
        visibility = "[group:raid] show",
        showPlayer = false,
        showSolo = false,
        showParty = false,
        showRaid = true
    },
    boss = {enabled = Addon.IsRetail},
    tank = {enabled = true},
    assist = {enabled = true},
    nameplates = {
        enabled = true,
        size = {150, 16},
        health = {statusbar = nil},
        power = {enabled = true, height = 6},
        auras = {enabled = true, showDuration = true, numBuffs = 0, onlyShowPlayerBuffs = true, numDebuffs = 16, onlyShowPlayerDebuffs = true, showDebuffsOnTop = false},
        castbar = {enabled = true, size = {150, 12}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = false, ignoreImmune = true, ignoreDamage = true, ignoreHeal = false, ignoreEnergize = true, ignoreOther = true},
        fader = Addon.config.faders.onShow,

        showBorder = true,
        borderSize = 6,
        showPower = false,
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
            nameplateMinAlpha = 0.8,
            nameplateMaxAlpha = 1,
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

Addon.config.options.args.unitFrames = {
    type = "group",
    name = "Unit Frames",
    order = 15,
    args = {
        header = {type = "header", name = Addon.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return UF.config.db.profile.enabled
            end,
            set = function(_, val)
                UF.config.db.profile.enabled = val
                ReloadUI()
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
                return UF.themes[UF.config.db.profile.theme]
            end,
            set = function(_, key)
                print(key)
                UF.config.db.profile.theme = UF.themes[key]
                UF:OnUpdate()
            end
        },
        lineBreak2 = {type = "header", name = "", order = 4},
        statusbars = {
            type = "group",
            name = "Status Bar Textures",
            order = 5,
            inline = true,
            args = {
                health = {
                    type = "select",
                    name = "Health",
                    desc = "Set the texture to use for health bars.",
                    order = 1,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.health == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.health = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                healthPrediction = {
                    type = "select",
                    name = "Health Prediction (Healing)",
                    desc = "Set the texture to use for health prediction bars.",
                    order = 2,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.healthPrediction == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.healthPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                lineBreak1 = {type = "header", name = "", order = 10},
                power = {
                    type = "select",
                    name = "Power",
                    desc = "Set the texture to use for power bars.",
                    order = 11,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.power == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.power = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                powerPrediction = {
                    type = "select",
                    name = "Power Prediction (Power Cost)",
                    desc = "Set the texture to use for power prediction bars.",
                    order = 12,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.powerPrediction == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.powerPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                lineBreak2 = {type = "header", name = "", order = 20},
                additionalPower = {
                    type = "select",
                    name = "Additional Power",
                    desc = "Set the texture to use for power bars.",
                    order = 21,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.additionalPower == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.additionalPower = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                additionalPowerPrediction = {
                    type = "select",
                    name = "Additional Power Prediction (Power Cost)",
                    desc = "Set the texture to use for additional power prediction bars.",
                    order = 22,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.additionalPowerPrediction == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.additionalPowerPrediction = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                },
                lineBreak3 = {type = "header", name = "", order = 30},
                castbar = {
                    type = "select",
                    name = "Cast Bars",
                    desc = "Set the texture to use for cast bars.",
                    order = 31,
                    dialogControl = "LSM30_Statusbar",
                    values = Addon.Libs.SharedMedia:HashTable("statusbar"),
                    get = function()
                        for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                            if UF.config.db.profile.statusbars.castbar == texture then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        UF.config.db.profile.statusbars.castbar = Addon.Libs.SharedMedia:Fetch("statusbar", key)
                        UF:OnUpdate()
                    end
                }
            }
        },
        colors = {
            type = "group",
            name = "Status Bar Colors",
            order = 6,
            inline = true,
            args = {
                health = {
                    type = "color",
                    name = "Health",
                    order = 1,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.health
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.health
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                mana = {
                    type = "color",
                    name = "Mana",
                    order = 2,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.mana
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.mana
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                rage = {
                    type = "color",
                    name = "Rage",
                    order = 3,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.rage
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.rage
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                energy = {
                    type = "color",
                    name = "Energy",
                    order = 4,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.energy
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.energy
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                focus = {
                    type = "color",
                    name = "Focus",
                    order = 5,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.focus
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.focus
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                comboPoints = {
                    type = "color",
                    name = "Combo Points",
                    order = 6,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.comboPoints
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.comboPoints
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                castbar = {
                    type = "color",
                    name = "Castbar",
                    order = 20,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.castbar
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.castbar
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                castbar_Shielded = {
                    type = "color",
                    name = "Castbar (Shielded)",
                    order = 21,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.castbar_Shielded
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.castbar_Shielded
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
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
                deathKnight = {
                    type = "color",
                    name = "Death Knight",
                    order = 0,
                    hidden = Addon.IsClassic,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.DEATHKNIGHT
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.DEATHKNIGHT
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                demonHunter = {
                    type = "color",
                    name = "Demon Hunter",
                    order = 1,
                    hidden = Addon.IsClassic,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.DEMONHUNTER
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.DEMONHUNTER
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                druid = {
                    type = "color",
                    name = "Druid",
                    order = 2,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.DRUID
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.DRUID
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                hunter = {
                    type = "color",
                    name = "Hunter",
                    order = 3,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.HUNTER
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.HUNTER
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                mage = {
                    type = "color",
                    name = "Mage",
                    order = 4,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.MAGE
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.MAGE
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                monk = {
                    type = "color",
                    name = "Monk",
                    order = 5,
                    hidden = Addon.IsClassic,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.MONK
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.MONK
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                paladin = {
                    type = "color",
                    name = "Paladin",
                    order = 6,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.PALADIN
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.PALADIN
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                priest = {
                    type = "color",
                    name = "Priest",
                    order = 7,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.PRIEST
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.PRIEST
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                rogue = {
                    type = "color",
                    name = "Rogue",
                    order = 8,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.ROGUE
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.ROGUE
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                shaman = {
                    type = "color",
                    name = "Shaman",
                    order = 9,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.SHAMAN
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.SHAMAN
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                warlock = {
                    type = "color",
                    name = "Warlock",
                    order = 10,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.WARLOCK
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.WARLOCK
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                },
                warrior = {
                    type = "color",
                    name = "Warrior",
                    order = 11,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.class.WARRIOR
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.class.WARRIOR
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        UF:OnUpdate()
                    end
                }
            }
        },
        player = {
            type = "group",
            name = "Player",
            order = 12,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.player.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.player.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        target = {
            type = "group",
            name = "Target",
            order = 13,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.target.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.target.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        targettarget = {
            type = "group",
            name = "Target's Target",
            order = 14,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.targettarget.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.targettarget.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        pet = {
            type = "group",
            name = "Pet",
            order = 15,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.pet.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.pet.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        focus = {
            type = "group",
            name = "Focus Target",
            order = 16,
            hidden = Addon.IsClassic,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.focus.enabled
                    end,
                    set = function(_, val)
                        if Addon.IsRetail then
                            UF.config.db.profile.focus.enabled = val
                            ReloadUI()
                        end
                    end
                }
            }
        },
        focustarget = {
            type = "group",
            name = "Focus Target's Target",
            order = 17,
            hidden = Addon.IsClassic,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.focustarget.enabled
                    end,
                    set = function(_, val)
                        if Addon.IsRetail then
                            UF.config.db.profile.focustarget.enabled = val
                            ReloadUI()
                        end
                    end
                }
            }
        },
        party = {
            type = "group",
            name = "Party",
            order = 18,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.party.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.party.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        raid = {
            type = "group",
            name = "Raid",
            order = 19,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.raid.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.raid.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        tank = {
            type = "group",
            name = "Tanks",
            order = 20,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.tank.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.tank.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        assist = {
            type = "group",
            name = "Assist",
            order = 21,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.assist.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.assist.enabled = val
                        ReloadUI()
                    end
                }
            }
        },
        boss = {
            type = "group",
            name = "Boss",
            order = 22,
            hidden = Addon.IsClassic,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.boss.enabled
                    end,
                    set = function(_, val)
                        if Addon.IsRetail then
                            UF.config.db.profile.boss.enabled = val
                            ReloadUI()
                        end
                    end
                }
            }
        },
        nameplates = {
            type = "group",
            name = "Nameplates",
            order = 23,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    confirm = function()
                        return "Disabling this unit requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.nameplates.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.nameplates.enabled = val
                        ReloadUI()
                    end
                }
            }
        }
    }
}
